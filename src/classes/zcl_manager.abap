*&---------------------------------------------------------------*
*& Class ZCL_MANAGER
*&---------------------------------------------------------------*
*& Purpose : Inherits from ZCL_EMPLOYEE to demonstrate
*&           inheritance and method redefinition (OOABAP).
*&---------------------------------------------------------------*
CLASS zcl_manager DEFINITION PUBLIC CREATE PUBLIC
  INHERITING FROM zcl_employee.

  PUBLIC SECTION.
    DATA: team_size TYPE i READ-ONLY.

    METHODS:
      constructor
        IMPORTING
          iv_empid     TYPE char10
          iv_ename     TYPE char40
          iv_dept      TYPE char10
          iv_salary    TYPE p
          iv_team_size TYPE i,

      calculate_bonus REDEFINITION,
      get_details     REDEFINITION.

ENDCLASS.

CLASS zcl_manager IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      iv_empid  = iv_empid
      iv_ename  = iv_ename
      iv_dept   = iv_dept
      iv_salary = iv_salary ).
    team_size = iv_team_size.
  ENDMETHOD.

  METHOD calculate_bonus.
    " Managers get base bonus (from super) + 2% per team member
    rv_bonus = super->calculate_bonus( ) + ( salary * '0.02' * team_size ).
  ENDMETHOD.

  METHOD get_details.
    rv_details = super->get_details( ) && | | Manages { team_size } people|.
  ENDMETHOD.

ENDCLASS.
