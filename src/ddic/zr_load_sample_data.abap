*&---------------------------------------------------------------*
*& Report ZR_LOAD_SAMPLE_DATA
*&---------------------------------------------------------------*
*& Purpose : One-time loader to populate ZDEPT_MASTER and
*&           ZEMP_MASTER with sample data for the mini-project.
*&           Run once after activating the DDIC objects.
*&---------------------------------------------------------------*
REPORT zr_load_sample_data.

DATA: lt_dept TYPE TABLE OF zdept_master,
      lt_emp  TYPE TABLE OF zemp_master.

START-OF-SELECTION.

  lt_dept = VALUE #(
    ( deptid = 'IT'      deptname = 'Information Technology' location = 'Noida' )
    ( deptid = 'FINANCE' deptname = 'Finance'                location = 'Noida' )
    ( deptid = 'HR'      deptname = 'Human Resources'        location = 'Delhi' )
  ).

  lt_emp = VALUE #(
    ( empid = '1001' ename = 'Ananya Sharma' dept = 'IT'      doj = '20240115' salary = '45000.00' currcy = 'INR' )
    ( empid = '1002' ename = 'Rohit Verma'   dept = 'FINANCE' doj = '20230601' salary = '52000.00' currcy = 'INR' )
    ( empid = '1003' ename = 'Priya Nair'    dept = 'HR'      doj = '20240301' salary = '38000.00' currcy = 'INR' )
    ( empid = '1004' ename = 'Karan Mehta'   dept = 'IT'      doj = '20220910' salary = '61000.00' currcy = 'INR' )
    ( empid = '1005' ename = 'Sneha Iyer'    dept = 'IT'      doj = '20250104' salary = '39000.00' currcy = 'INR' )
  ).

  MODIFY zdept_master FROM TABLE lt_dept.
  MODIFY zemp_master  FROM TABLE lt_emp.

  IF sy-subrc = 0.
    COMMIT WORK.
    WRITE: / 'Sample data loaded successfully.'.
  ELSE.
    ROLLBACK WORK.
    WRITE: / 'Data load failed.'.
  ENDIF.
