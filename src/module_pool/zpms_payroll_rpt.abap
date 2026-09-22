*&---------------------------------------------------------------*
*& Report ZPMS_PAYROLL_RPT
*&---------------------------------------------------------------*
*& Purpose : Payroll report - shows processed payroll runs with
*&           employee name/department joined in, ALV output.
*&---------------------------------------------------------------*
REPORT zpms_payroll_rpt.

TYPES: BEGIN OF ty_report,
         empid        TYPE char10,
         ename        TYPE char40,
         dept         TYPE char10,
         paymonth     TYPE char6,
         gross_pay    TYPE p LENGTH 8 DECIMALS 2,
         total_deduct TYPE p LENGTH 8 DECIMALS 2,
         net_pay      TYPE p LENGTH 8 DECIMALS 2,
         run_status   TYPE c LENGTH 1,
       END OF ty_report.

DATA: gt_report TYPE TABLE OF ty_report.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_month TYPE zpms_pay_trn-paymonth OBLIGATORY.
  SELECT-OPTIONS: s_dept FOR zpms_emp_mst-dept.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  SELECT t~empid, e~ename, e~dept, t~paymonth,
         t~gross_pay, t~total_deduct, t~net_pay, t~run_status
    FROM zpms_pay_trn AS t
    INNER JOIN zpms_emp_mst AS e ON t~empid = e~empid
    WHERE t~paymonth = @p_month
      AND e~dept IN @s_dept
    ORDER BY e~dept, t~empid
    INTO TABLE @gt_report.

  IF gt_report IS INITIAL.
    MESSAGE 'No payroll data found for the selected criteria' TYPE 'I'.
  ENDIF.

  PERFORM display_alv.

FORM display_alv.
  TRY.
      cl_salv_table=>factory(
        IMPORTING r_salv_table = DATA(lo_alv)
        CHANGING  t_table      = gt_report ).

      lo_alv->get_functions( )->set_all( abap_true ).

      " Total row for Net Pay
      DATA(lo_aggregations) = lo_alv->get_aggregations( ).
      lo_aggregations->add_aggregation(
        columnname  = 'NET_PAY'
        aggregation = if_salv_c_aggregation=>total ).

      lo_alv->display( ).
    CATCH cx_salv_msg INTO DATA(lx_msg).
      WRITE: / lx_msg->get_text( ).
  ENDTRY.
ENDFORM.
