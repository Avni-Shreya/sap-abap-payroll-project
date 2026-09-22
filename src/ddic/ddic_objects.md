# Data Dictionary Objects (Module 2)

DDIC objects (tables, structures, foreign keys) are created in **SE11**, not written as
source-code files — this file documents exactly what to create so the repo is a complete
build spec, and includes the equivalent `TYPES` declarations for reference/testing outside
the dictionary.

## 1. Transparent Table: ZEMP_MASTER

| Field    | Key | Data Element | Type       | Length | Description            |
|----------|-----|--------------|------------|--------|-------------------------|
| MANDT    | X   | MANDT        | CLNT       | 3      | Client                 |
| EMPID    | X   | ZDE_EMPID    | CHAR       | 10     | Employee ID             |
| ENAME    |     | ZDE_ENAME    | CHAR       | 40     | Employee Name           |
| DEPT     |     | ZDE_DEPTID   | CHAR       | 10     | Department (FK)         |
| DOJ      |     | ZDE_DOJ      | DATS       | 8      | Date of Joining         |
| SALARY   |     | ZDE_SALARY   | CURR       | 15,2   | Salary                 |
| CURRCY   |     | WAERS        | CUKY       | 5      | Currency key (for SALARY)|

**Foreign key:** `ZEMP_MASTER-DEPT` → `ZDEPT_MASTER-DEPTID` (check table `ZDEPT_MASTER`)

## 2. Transparent Table: ZDEPT_MASTER

| Field     | Key | Data Element  | Type | Length | Description       |
|-----------|-----|---------------|------|--------|--------------------|
| MANDT     | X   | MANDT         | CLNT | 3      | Client             |
| DEPTID    | X   | ZDE_DEPTID    | CHAR | 10     | Department ID      |
| DEPTNAME  |     | ZDE_DEPTNAME  | CHAR | 30     | Department Name    |
| LOCATION  |     | ZDE_LOCATION  | CHAR | 30     | Location            |

## 3. Structure: ZEMP_DISPLAY_STR (used for ALV output in Module 3)

| Field     | Type/Reference          |
|-----------|--------------------------|
| EMPID     | ZEMP_MASTER-EMPID        |
| ENAME     | ZEMP_MASTER-ENAME        |
| DEPTNAME  | ZDEPT_MASTER-DEPTNAME    |
| LOCATION  | ZDEPT_MASTER-LOCATION    |
| SALARY    | ZEMP_MASTER-SALARY       |
| CURRCY    | ZEMP_MASTER-CURRCY       |

## Build steps in SE11

1. `SE11` → Database table → enter `ZEMP_MASTER` → Create
2. Add fields as above, mark `EMPID` as primary key
3. Go to **Technical Settings**, choose a suitable data class (e.g. `APPL0`) and size category
4. **Currency/Quantity Fields** tab → link `SALARY` to `CURRCY`
5. Repeat for `ZDEPT_MASTER`
6. On `ZEMP_MASTER`, go to **Foreign Keys** → create FK on `DEPT` referencing `ZDEPT_MASTER`
7. Activate both tables
8. Create `ZEMP_DISPLAY_STR` the same way but as a **Structure**, not a table
9. Load 10–15 sample rows via `SE16N` (or the loader program below)

## Equivalent ABAP TYPES (for local testing / documentation)

```abap
TYPES: BEGIN OF zemp_master,
         mandt  TYPE mandt,
         empid  TYPE char10,
         ename  TYPE char40,
         dept   TYPE char10,
         doj    TYPE dats,
         salary TYPE p LENGTH 8 DECIMALS 2,
         currcy TYPE waers,
       END OF zemp_master.

TYPES: BEGIN OF zdept_master,
         mandt    TYPE mandt,
         deptid   TYPE char10,
         deptname TYPE char30,
         location TYPE char30,
       END OF zdept_master.

TYPES: BEGIN OF zemp_display_str,
         empid    TYPE char10,
         ename    TYPE char40,
         deptname TYPE char30,
         location TYPE char30,
         salary   TYPE p LENGTH 8 DECIMALS 2,
         currcy   TYPE waers,
       END OF zemp_display_str.
```
