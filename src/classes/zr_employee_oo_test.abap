*&---------------------------------------------------------------*
*& Report ZR_EMPLOYEE_OO_TEST
*&---------------------------------------------------------------*
*& Purpose : Test report - creates ZCL_EMPLOYEE / ZCL_MANAGER
*&           objects and calls their methods.
*&---------------------------------------------------------------*
REPORT zr_employee_oo_test.

DATA: lo_emp TYPE REF TO zcl_employee,
      lo_mgr TYPE REF TO zcl_manager,
      lt_emp TYPE TABLE OF REF TO zcl_employee.

START-OF-SELECTION.

  lo_emp = NEW zcl_employee(
    iv_empid  = '1001'
    iv_ename  = 'Ananya Sharma'
    iv_dept   = 'IT'
    iv_salary = '45000' ).

  lo_mgr = NEW zcl_manager(
    iv_empid     = '2001'
    iv_ename     = 'Vikram Rao'
    iv_dept      = 'IT'
    iv_salary    = '90000'
    iv_team_size = 5 ).

  APPEND lo_emp TO lt_emp.
  APPEND lo_mgr TO lt_emp.   " polymorphism: manager stored as employee ref

  LOOP AT lt_emp INTO DATA(lo_current).
    lo_current->display( ).
  ENDLOOP.
