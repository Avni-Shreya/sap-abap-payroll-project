*&---------------------------------------------------------------*
*& Test Class ZCL_PAYROLL_CALC_TEST
*&---------------------------------------------------------------*
*& Purpose : ABAP Unit tests for ZCL_EMPLOYEE / ZCL_MANAGER bonus
*&           logic - automated testing, not just the manual
*&           test_cases.md log from Module 7.
*&           Run via: right-click program -> Execute -> Unit Test,
*&           or Ctrl+Shift+F10 in ADT (Eclipse), or SE80 -> Test.
*&---------------------------------------------------------------*
CLASS ltc_bonus_calculation DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      bonus_for_standard_employee FOR TESTING,
      bonus_for_manager_with_team FOR TESTING,
      manager_get_details_text    FOR TESTING,
      zero_team_size_manager      FOR TESTING.

ENDCLASS.

CLASS ltc_bonus_calculation IMPLEMENTATION.

  METHOD bonus_for_standard_employee.
    DATA(lo_emp) = NEW zcl_employee(
      iv_empid = '1001' iv_ename = 'Test User'
      iv_dept  = 'IT'    iv_salary = '45000' ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_emp->calculate_bonus( )
      exp = '4500'
      msg = 'Standard employee bonus should be 10% of salary' ).
  ENDMETHOD.

  METHOD bonus_for_manager_with_team.
    DATA(lo_mgr) = NEW zcl_manager(
      iv_empid = '2001' iv_ename = 'Test Manager'
      iv_dept  = 'IT'    iv_salary = '90000' iv_team_size = 5 ).

    " Expected: 10% base (9000) + 2% * salary * team_size (9000) = 18000
    cl_abap_unit_assert=>assert_equals(
      act = lo_mgr->calculate_bonus( )
      exp = '18000'
      msg = 'Manager bonus should include team-size uplift' ).
  ENDMETHOD.

  METHOD manager_get_details_text.
    DATA(lo_mgr) = NEW zcl_manager(
      iv_empid = '2001' iv_ename = 'Test Manager'
      iv_dept  = 'IT'    iv_salary = '90000' iv_team_size = 5 ).

    cl_abap_unit_assert=>assert_char_cp(
      act = lo_mgr->get_details( )
      exp = '*Manages 5 people*'
      msg = 'Manager details should mention team size' ).
  ENDMETHOD.

  METHOD zero_team_size_manager.
    " Edge case: manager with no direct reports yet
    DATA(lo_mgr) = NEW zcl_manager(
      iv_empid = '2002' iv_ename = 'New Manager'
      iv_dept  = 'HR'    iv_salary = '80000' iv_team_size = 0 ).

    cl_abap_unit_assert=>assert_equals(
      act = lo_mgr->calculate_bonus( )
      exp = '8000'
      msg = 'Manager with 0 team members should get only base bonus' ).
  ENDMETHOD.

ENDCLASS.
