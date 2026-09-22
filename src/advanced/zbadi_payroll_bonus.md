# BAdI: ZBADI_PAYROLL_BONUS (Module 8 - Advanced Track)

**Why this matters:** BAdIs (Business Add-Ins) are how real SAP projects let
different departments/countries plug in their own business rules without
modifying the core code — a fresher who understands this concept stands out
immediately, because it's usually a mid-level topic.

## Concept demonstrated

Instead of hardcoding the 10% bonus rule inside `ZCL_EMPLOYEE`, expose it as a
BAdI so each region/department could implement its own bonus formula.

## Build steps (SE18 / SE19)

### 1. Define the BAdI interface

```abap
INTERFACE zif_ex_payroll_bonus.
  METHODS:
    calculate_bonus
      IMPORTING
        iv_empid  TYPE char10
        iv_salary TYPE p
      RETURNING
        VALUE(rv_bonus) TYPE p.
ENDINTERFACE.
```

### 2. Create the BAdI definition (SE18)

- Enhancement Spot: `ZES_PAYROLL`
- BAdI Definition: `ZBADI_PAYROLL_BONUS`
- Interface: `ZIF_EX_PAYROLL_BONUS`
- Multiple use: No (single active implementation for this demo)

### 3. Default implementation class

```abap
CLASS zcl_im_payroll_bonus_default DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_ex_payroll_bonus.

ENDCLASS.

CLASS zcl_im_payroll_bonus_default IMPLEMENTATION.

  METHOD zif_ex_payroll_bonus~calculate_bonus.
    " Standard rule: flat 10%
    rv_bonus = iv_salary * '0.10'.
  ENDMETHOD.

ENDCLASS.
```

### 4. Alternate implementation (shows extensibility)

```abap
CLASS zcl_im_payroll_bonus_it DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_ex_payroll_bonus.

ENDCLASS.

CLASS zcl_im_payroll_bonus_it IMPLEMENTATION.

  METHOD zif_ex_payroll_bonus~calculate_bonus.
    " IT department rule: 15% + flat 2000 retention bonus
    rv_bonus = ( iv_salary * '0.15' ) + 2000.
  ENDMETHOD.

ENDCLASS.
```

### 5. Calling the BAdI from ZCL_EMPLOYEE

```abap
METHOD calculate_bonus.
  DATA(lo_badi) = cl_badi_multiple_use=>get_instance( ).
  " (pseudo-code — real call uses GET BADI / CALL BADI statements)
  GET BADI lo_badi_handle
    TYPE zif_ex_payroll_bonus
    FOR zbadi_payroll_bonus.

  CALL BADI lo_badi_handle->calculate_bonus
    EXPORTING
      iv_empid  = empid
      iv_salary = salary
    RECEIVING
      rv_bonus  = rv_bonus.
ENDMETHOD.
```

## Interview talking point

> "I used a BAdI so bonus logic can change per department without touching
> `ZCL_EMPLOYEE` itself — that's the open/closed principle applied the SAP way,
> and it's exactly how SAP itself lets customers extend standard processes
> without core modifications."
