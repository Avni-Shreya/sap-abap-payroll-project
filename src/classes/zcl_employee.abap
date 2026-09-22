*&---------------------------------------------------------------*
*& Class ZCL_EMPLOYEE
*&---------------------------------------------------------------*
*& Purpose : OOABAP base class - Module 5 of the mini-project.
*&---------------------------------------------------------------*
CLASS zcl_employee DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    DATA: empid  TYPE char10   READ-ONLY,
          ename  TYPE char40   READ-ONLY,
          dept   TYPE char10   READ-ONLY,
          salary TYPE p LENGTH 8 DECIMALS 2 READ-ONLY.

    METHODS:
      constructor
        IMPORTING
          iv_empid  TYPE char10
          iv_ename  TYPE char40
          iv_dept   TYPE char10
          iv_salary TYPE p,

      get_details
        RETURNING VALUE(rv_details) TYPE string,

      calculate_bonus
        RETURNING VALUE(rv_bonus) TYPE p,

      display.

ENDCLASS.

CLASS zcl_employee IMPLEMENTATION.

  METHOD constructor.
    empid  = iv_empid.
    ename  = iv_ename.
    dept   = iv_dept.
    salary = iv_salary.
  ENDMETHOD.

  METHOD get_details.
    rv_details = |{ empid } - { ename } ({ dept }) - Salary: { salary }|.
  ENDMETHOD.

  METHOD calculate_bonus.
    " Business rule: 10% of salary as annual bonus
    rv_bonus = salary * '0.10'.
  ENDMETHOD.

  METHOD display.
    WRITE: / get_details( ), '| Bonus:', calculate_bonus( ).
  ENDMETHOD.

ENDCLASS.
