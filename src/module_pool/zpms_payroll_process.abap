*&---------------------------------------------------------------*
*& Report ZPMS_PAYROLL_PROCESS
*&---------------------------------------------------------------*
*& Purpose : Runs the monthly payroll calculation for all active
*&           employees and writes results into ZPMS_PAY_TRN.
*&           GROSS_PAY = BASIC + HRA + DA
*&           NET_PAY   = GROSS_PAY - (PF + TAX)
*&---------------------------------------------------------------*
REPORT zpms_payroll_process.

PARAMETERS: p_month TYPE zpms_pay_trn-paymonth OBLIGATORY
              DEFAULT sy-datum(6).

DATA: lt_emp TYPE TABLE OF zpms_emp_mst,
      lt_sal TYPE TABLE OF zpms_sal_mst,
      lt_trn TYPE TABLE OF zpms_pay_trn,
      lv_processed TYPE i,
      lv_errors    TYPE i.

START-OF-SELECTION.

  SELECT * FROM zpms_emp_mst INTO TABLE @lt_emp
    WHERE status = 'A'.   " active employees only

  SELECT * FROM zpms_sal_mst INTO TABLE @lt_sal.

  LOOP AT lt_emp INTO DATA(ls_emp).

    READ TABLE lt_sal INTO DATA(ls_sal) WITH KEY empid = ls_emp-empid.

    IF sy-subrc <> 0.
      lv_errors = lv_errors + 1.
      WRITE: / 'No salary record for', ls_emp-empid, '- skipped'.
      CONTINUE.
    ENDIF.

    " Avoid duplicate processing for the same month
    SELECT SINGLE empid FROM zpms_pay_trn
      INTO @DATA(lv_dummy)
      WHERE empid = @ls_emp-empid
        AND paymonth = @p_month.

    IF sy-subrc = 0.
      WRITE: / ls_emp-empid, 'already processed for', p_month, '- skipped'.
      CONTINUE.
    ENDIF.

    DATA(lv_gross) = ls_sal-basic + ls_sal-hra + ls_sal-da.
    DATA(lv_deduct) = ls_sal-pf + ls_sal-tax.
    DATA(lv_net)   = lv_gross - lv_deduct.

    APPEND VALUE #(
      empid         = ls_emp-empid
      paymonth      = p_month
      gross_pay     = lv_gross
      total_deduct  = lv_deduct
      net_pay       = lv_net
      run_date      = sy-datum
      run_status    = 'P'
    ) TO lt_trn.

    lv_processed = lv_processed + 1.
  ENDLOOP.

  IF lt_trn IS NOT INITIAL.
    INSERT zpms_pay_trn FROM TABLE lt_trn.
    IF sy-subrc = 0.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
      MESSAGE 'Payroll run failed to save' TYPE 'E'.
    ENDIF.
  ENDIF.

  WRITE: / '--- Payroll Run Summary ---'.
  WRITE: / 'Month     :', p_month.
  WRITE: / 'Processed :', lv_processed.
  WRITE: / 'Skipped   :', lv_errors.
