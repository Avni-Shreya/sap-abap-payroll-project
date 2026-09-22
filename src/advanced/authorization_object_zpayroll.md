# Custom Authorization Object: ZPAYROLL (Module 8 - Advanced Track)

**Why this matters:** Payroll data is sensitive. A fresher who shows they
thought about *who's allowed to see whose salary* — not just how to display
it — signals production-readiness, not just tutorial-following.

## Build steps (SU21)

1. `SU21` → Object Class `ZHR` → New Authorization Object
2. Object: `ZPAYROLL`
3. Fields:
   - `ZDEPT` (department — reuse data element `ZDE_DEPTID`)
   - `ACTVT` (standard SAP activity field: 01=Create, 02=Change, 03=Display)
4. Activate

## Code: AUTHORITY-CHECK in the reporting program

Add this near the top of `ZR_EMP_REPORT` / `ZR_PAYSLIP_DRIVER`, before any
data is read:

```abap
LOOP AT s_dept.
  AUTHORITY-CHECK OBJECT 'ZPAYROLL'
    ID 'ZDEPT' FIELD s_dept-low
    ID 'ACTVT' FIELD '03'.   " Display

  IF sy-subrc <> 0.
    MESSAGE |You are not authorized to view department { s_dept-low }|
      TYPE 'E'.
  ENDIF.
ENDLOOP.
```

## Assigning it to a role (PFCG)

1. `PFCG` → create/open role `Z_HR_PAYROLL_VIEWER`
2. Authorizations tab → manually add object `ZPAYROLL`
3. Restrict `ZDEPT` to the departments this role should see
   (e.g. HR admin for one region only sees their own department)
4. Set `ACTVT` = 03 (display only) for a read-only payroll viewer role,
   or 01/02 for someone allowed to maintain data

## Interview talking point

> "Even in a training project I added a custom authorization object so
> department-level access control is enforced with `AUTHORITY-CHECK`, not
> just left open — that's the first thing a security review would flag in a
> real payroll system."
