*&---------------------------------------------------------------*
*& Report ZR_EMPLOYEE_BASICS
*&---------------------------------------------------------------*
*& Purpose : Demonstrates ABAP basics - data types, internal
*&           tables, work areas, loops and conditional logic.
*&           Module 1 of the SAP ABAP Fresher mini-project.
*&---------------------------------------------------------------*
REPORT zr_employee_basics.

"---------------------------------------------------------------
" 1. Basic data type declarations
"---------------------------------------------------------------
DATA: gv_char   TYPE c LENGTH 10,      " Character
      gv_numc   TYPE n LENGTH 5,       " Numeric text
      gv_int    TYPE i,                " Integer
      gv_amt    TYPE p LENGTH 8 DECIMALS 2, " Packed number
      gv_date   TYPE d.                " Date

"---------------------------------------------------------------
" 2. Local structure to hold one employee record
"---------------------------------------------------------------
TYPES: BEGIN OF ty_employee,
         empid   TYPE char10,
         ename   TYPE char40,
         dept    TYPE char20,
         salary  TYPE p LENGTH 8 DECIMALS 2,
       END OF ty_employee.

"---------------------------------------------------------------
" 3. Internal table + work area
"---------------------------------------------------------------
DATA: gt_employee TYPE TABLE OF ty_employee,
      gs_employee TYPE ty_employee.

START-OF-SELECTION.

  " Populate dummy data (in the real project this comes from ZEMP_MASTER)
  gs_employee = VALUE #( empid = '1001' ename = 'Ananya Sharma'  dept = 'IT'      salary = '45000.00' ).
  APPEND gs_employee TO gt_employee.

  gs_employee = VALUE #( empid = '1002' ename = 'Rohit Verma'    dept = 'FINANCE' salary = '52000.00' ).
  APPEND gs_employee TO gt_employee.

  gs_employee = VALUE #( empid = '1003' ename = 'Priya Nair'     dept = 'HR'      salary = '38000.00' ).
  APPEND gs_employee TO gt_employee.

  gs_employee = VALUE #( empid = '1004' ename = 'Karan Mehta'    dept = 'IT'      salary = '61000.00' ).
  APPEND gs_employee TO gt_employee.

  " Loop and display with basic conditional flag
  LOOP AT gt_employee INTO gs_employee.
    WRITE: / gs_employee-empid, gs_employee-ename, gs_employee-dept, gs_employee-salary.

    IF gs_employee-salary > 50000.
      WRITE: '  --> High salary band'.
    ELSE.
      WRITE: '  --> Standard salary band'.
    ENDIF.
  ENDLOOP.
