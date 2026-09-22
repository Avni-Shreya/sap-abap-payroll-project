# Smart Form: ZSF_PAYSLIP (Module 6)

Smart Forms are built visually in transaction **SMARTFORMS**, not as flat source
files, so this note documents the exact layout to build. The driver program below
is real, deployable ABAP.

## Form structure (build in SMARTFORMS)

- **Form name:** `ZSF_PAYSLIP`
- **Interface import parameter:** `IS_EMP` TYPE `ZEMP_DISPLAY_STR`
- **Pages/Windows:**
  - `MAIN` window
    - Header text: Company name + "Payslip for <Month/Year>"
    - Address/employee block: Name, Employee ID, Department
    - Table region with columns: `Component | Amount`
      - Basic Salary
      - Allowances (flat 10% of basic, for demo)
      - Deductions (flat 5% of basic, for demo)
      - **Net Pay** (bold row)
- Activate the form; this auto-generates a function module, e.g. `/1BCDWB/SF00000123`

## Driver Program: ZR_PAYSLIP_DRIVER

```abap
*&---------------------------------------------------------------*
*& Report ZR_PAYSLIP_DRIVER
*&---------------------------------------------------------------*
*& Purpose : Reads employee data and calls the ZSF_PAYSLIP
*&           Smart Form. Module 6 of the mini-project.
*&---------------------------------------------------------------*
REPORT zr_payslip_driver.

PARAMETERS: p_empid TYPE zemp_master-empid OBLIGATORY.

DATA: ls_emp     TYPE zemp_display_str,
      lv_fm_name TYPE rs38l_fnam,
      ls_ctrl    TYPE ssfctrlop.

START-OF-SELECTION.

  SELECT SINGLE e~empid, e~ename, d~deptname, d~location, e~salary, e~currcy
    FROM zemp_master AS e
    INNER JOIN zdept_master AS d ON e~dept = d~deptid
    WHERE e~empid = @p_empid
    INTO @ls_emp.

  IF sy-subrc <> 0.
    MESSAGE 'Employee not found' TYPE 'E'.
  ENDIF.

  " 1. Resolve the generated function module for the Smart Form
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZSF_PAYSLIP'
    IMPORTING
      fm_name             = lv_fm_name
    EXCEPTIONS
      no_form             = 1
      no_function_module  = 2
      OTHERS              = 3.

  IF sy-subrc <> 0.
    MESSAGE 'Smart Form not found/activated' TYPE 'E'.
  ENDIF.

  " 2. Call it, passing the employee data
  ls_ctrl-no_dialog = abap_true.

  CALL FUNCTION lv_fm_name
    EXPORTING
      control_parameters = ls_ctrl
      is_emp              = ls_emp
    EXCEPTIONS
      formatting_error    = 1
      internal_error      = 2
      send_error          = 3
      user_canceled       = 4
      OTHERS              = 5.

  IF sy-subrc <> 0.
    MESSAGE 'Error generating payslip' TYPE 'E'.
  ELSE.
    MESSAGE 'Payslip generated successfully' TYPE 'S'.
  ENDIF.
```

## SAP Script alternative (if Smart Forms not available to practice on)

Same idea via transaction `SE71`:
- Create form `ZPAYSLIP`, define window `MAIN`
- Use `CALL FUNCTION 'OPEN_FORM'` → `WRITE_FORM` → `CLOSE_FORM` in the driver
  program instead of a single generated FM call
- Mention both approaches in the interview — it shows you understand the
  difference between the newer (Smart Forms) and legacy (SAP Script) tools.
