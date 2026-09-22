*&---------------------------------------------------------------*
*& Exception Class ZCX_PAYROLL_EXCEPTION
*&---------------------------------------------------------------*
*& Purpose : Custom exception hierarchy for proper TRY/CATCH
*&           error handling instead of MESSAGE TYPE 'E' / sy-subrc
*&           checks scattered everywhere.
*&---------------------------------------------------------------*
CLASS zcx_payroll_exception DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_message.

    CONSTANTS:
      BEGIN OF employee_not_found,
        msgid TYPE symsgid VALUE 'ZPAYROLL',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'EMPID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF employee_not_found,

      BEGIN OF invalid_salary,
        msgid TYPE symsgid VALUE 'ZPAYROLL',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'SALARY',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_salary.

    DATA: empid  TYPE char10,
          salary TYPE p LENGTH 8 DECIMALS 2.

    METHODS constructor
      IMPORTING
        textid   LIKE if_t100_message=>t100key OPTIONAL
        empid    TYPE char10 OPTIONAL
        salary   TYPE p OPTIONAL
        previous LIKE previous OPTIONAL.

ENDCLASS.

CLASS zcx_payroll_exception IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
    me->empid  = empid.
    me->salary = salary.

    IF textid IS INITIAL.
      if_t100_message~t100key = employee_not_found.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

*&---------------------------------------------------------------*
*& Usage example (in a payroll processing method)
*&---------------------------------------------------------------*
*  TRY.
*      IF ls_emp IS INITIAL.
*        RAISE EXCEPTION TYPE zcx_payroll_exception
*          EXPORTING
*            textid = zcx_payroll_exception=>employee_not_found
*            empid  = iv_empid.
*      ENDIF.
*
*      IF ls_emp-salary <= 0.
*        RAISE EXCEPTION TYPE zcx_payroll_exception
*          EXPORTING
*            textid = zcx_payroll_exception=>invalid_salary
*            empid  = iv_empid
*            salary = ls_emp-salary.
*      ENDIF.
*
*    CATCH zcx_payroll_exception INTO DATA(lx_error).
*      MESSAGE lx_error->get_text( ) TYPE 'E'.
*  ENDTRY.
*
* Requires text elements ZPAYROLL 001/002 maintained via SE91/message class ZPAYROLL.
