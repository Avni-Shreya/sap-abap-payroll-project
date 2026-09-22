# Debugging Practice Log (Module 4)

Three deliberate bugs introduced into a copy of `ZR_EMP_REPORT`, found and fixed
using the classic ABAP debugger (`/h`). Use these as ready-made interview stories.

---

## Bug 1: Wrong comparison operator (logic error)

**Symptom:** High-salary flag was showing for everyone, including low earners.

```abap
" BEFORE (bug)
IF gs_employee-salary > 0.        " always true, should compare to 50000
  WRITE: '--> High salary band'.
ENDIF.
```

```abap
" AFTER (fix)
IF gs_employee-salary > 50000.
  WRITE: '--> High salary band'.
ENDIF.
```

**How found:** Set a breakpoint at the `IF`, watched `gs_employee-salary` in the
Debugger's variable view, and stepped through each loop iteration — confirmed the
condition was structurally wrong, not a data issue.

---

## Bug 2: Internal table not cleared before reuse

**Symptom:** After the second call of a subroutine, old records from the first
call were still appearing in the output (data "carried over").

```abap
" BEFORE (bug)
FORM build_department_list USING p_dept.
  SELECT * FROM zemp_master INTO TABLE gt_emp_display
    WHERE dept = p_dept.
  " gt_emp_display not cleared -> next call appends to old data
ENDFORM.
```

```abap
" AFTER (fix)
FORM build_department_list USING p_dept.
  CLEAR gt_emp_display[].
  SELECT * FROM zemp_master INTO TABLE gt_emp_display
    WHERE dept = p_dept.
ENDFORM.
```

**How found:** Used a watchpoint on `gt_emp_display` (Debugger → Watchpoint →
"on change of variable"), which stopped execution exactly when the second SELECT
appended instead of replacing — made the missing CLEAR obvious immediately.

---

## Bug 3: Typo in field-symbol assignment causing a dump

**Symptom:** Program raised `GETWA_NOT_ASSIGNED` (short dump).

```abap
" BEFORE (bug)
FIELD-SYMBOLS: <fs_emp> TYPE zemp_master.
READ TABLE gt_emp ASSIGNING <fs_emp> WITH KEY empid = lv_empid.
<fs_emp>-ename = 'Updated Name'.   " dumps if READ TABLE found nothing
```

```abap
" AFTER (fix)
FIELD-SYMBOLS: <fs_emp> TYPE zemp_master.
READ TABLE gt_emp ASSIGNING <fs_emp> WITH KEY empid = lv_empid.
IF sy-subrc = 0.
  <fs_emp>-ename = 'Updated Name'.
ELSE.
  MESSAGE 'Employee not found' TYPE 'I'.
ENDIF.
```

**How found:** Reproduced the dump, opened it via `ST22`, jumped straight into the
debugger from the dump screen, and saw `<fs_emp>` was unassigned — traced it back
to a missing `sy-subrc` check after `READ TABLE ... ASSIGNING`.

---

## Interview soundbite

> "I intentionally break my own programs to practice debugging — logic errors,
> stale internal table data, and unassigned field-symbols are the three most
> common fresher mistakes, and I know exactly how to spot each one with
> breakpoints, watchpoints, and `sy-subrc` checks."
