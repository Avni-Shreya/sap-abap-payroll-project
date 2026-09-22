*&---------------------------------------------------------------*
*& Module Pool ZPMS_MAIN_NAV
*&---------------------------------------------------------------*
*& Purpose : Main navigation screen (Screen 0100), launched via
*&           custom transaction code ZPAYROLL. Built with
*&           Screen Painter (SE51) + Menu Painter (SE41).
*&---------------------------------------------------------------*
PROGRAM zpms_main_nav.

*&---------------------------------------------------------------*
*& Screen 0100 layout (build in SE51):
*&   4 pushbuttons, function codes:
*&     EMP_MGMT  -> "Employee Management"
*&     SAL_MGMT  -> "Salary Management"
*&     PAY_PROC  -> "Payroll Processing"
*&     PAY_RPT   -> "Payroll Report"
*&   GUI Status 0100 (SE41) with matching menu bar entries and
*&   a standard EXIT/BACK function code.
*&---------------------------------------------------------------*

MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.
  SET TITLEBAR 'TITLE_0100'.   " e.g. "Payroll & Employee Management System"
ENDMODULE.

MODULE user_command_0100 INPUT.
  DATA(lv_ok) = sy-ucomm.
  CLEAR sy-ucomm.

  CASE lv_ok.
    WHEN 'EMP_MGMT'.
      CALL TRANSACTION 'ZPMS_EMP'.        " or: LEAVE TO LIST-PROCESSING / SUBMIT
    WHEN 'SAL_MGMT'.
      CALL TRANSACTION 'ZPMS_SAL'.
    WHEN 'PAY_PROC'.
      SUBMIT zpms_payroll_process AND RETURN.
    WHEN 'PAY_RPT'.
      SUBMIT zpms_payroll_rpt AND RETURN.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------*
*& Transaction code setup (SE93):
*&   ZPAYROLL -> Program and screen (dialog transaction)
*&   Program:  ZPMS_MAIN_NAV
*&   Screen:   0100
*&
*& Sub-transactions ZPMS_EMP / ZPMS_SAL point to
*& ZPMS_EMPLOYEE_MGMT screen 0100 and ZPMS_SALARY_MGMT screen 0100
*& respectively (see those programs + tcode_setup.md for exact steps).
*&---------------------------------------------------------------*
