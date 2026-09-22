*&---------------------------------------------------------------*
*& Report ZR_EMP_REPORT
*&---------------------------------------------------------------*
*& Purpose : Open SQL reporting program - JOIN, selection screen,
*&           aggregate query, ALV output. Module 3 of the
*&           SAP ABAP Fresher mini-project.
*&---------------------------------------------------------------*
REPORT zr_emp_report.

TYPES: BEGIN OF ty_emp_display,
         empid    TYPE char10,
         ename    TYPE char40,
         deptname TYPE char30,
         location TYPE char30,
         salary   TYPE p LENGTH 8 DECIMALS 2,
         currcy   TYPE waers,
       END OF ty_emp_display.

TYPES: BEGIN OF ty_dept_avg,
         dept       TYPE char10,
         avg_salary TYPE p LENGTH 8 DECIMALS 2,
       END OF ty_dept_avg.

DATA: gt_emp_display TYPE TABLE OF ty_emp_display,
      gt_dept_avg    TYPE TABLE OF ty_dept_avg.

"---------------------------------------------------------------
" Selection screen
"---------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_dept FOR zemp_master-dept,
                  s_doj  FOR zemp_master-doj.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  "---------------------------------------------------------------
  " GOOD PRACTICE: single Open SQL JOIN instead of nested SELECTs
  "---------------------------------------------------------------
  SELECT e~empid, e~ename, d~deptname, d~location, e~salary, e~currcy
    FROM zemp_master AS e
    INNER JOIN zdept_master AS d
      ON e~dept = d~deptid
    WHERE e~dept IN @s_dept
      AND e~doj  IN @s_doj
    ORDER BY e~empid
    INTO TABLE @gt_emp_display.

  "---------------------------------------------------------------
  " Aggregate query: average salary per department
  "---------------------------------------------------------------
  SELECT dept, AVG( salary ) AS avg_salary
    FROM zemp_master
    WHERE dept IN @s_dept
    GROUP BY dept
    INTO TABLE @gt_dept_avg.

  PERFORM display_alv.

*&---------------------------------------------------------------*
*& NOTE - Anti-pattern (kept here only for the interview
*& "how would you optimize this" discussion). Do NOT run this
*& in a real system against large tables.
*&---------------------------------------------------------------*
*  LOOP AT gt_emp_display INTO DATA(ls_emp).
*    SELECT SINGLE deptname FROM zdept_master
*      INTO @DATA(lv_deptname)
*      WHERE deptid = @ls_emp-deptname.   " <- SELECT inside LOOP = 1 query per row
*  ENDLOOP.
*  " Fixed by replacing with the single JOIN query above:
*  " one round trip to the database instead of N.

FORM display_alv.
  DATA(lo_alv) = NEW cl_salv_table( ).

  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = lo_alv
        CHANGING  t_table      = gt_emp_display ).
      lo_alv->get_functions( )->set_all( abap_true ).
      lo_alv->display( ).
    CATCH cx_salv_msg INTO DATA(lx_msg).
      WRITE: / lx_msg->get_text( ).
  ENDTRY.
ENDFORM.
