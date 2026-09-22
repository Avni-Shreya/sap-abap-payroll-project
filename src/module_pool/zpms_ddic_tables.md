# Module 9: Module Pool CRUD System — DDIC Tables

Named to match/exceed the reference project's convention. Build in SE11.

## ZPMS_EMP_MST (Employee Master)

| Field | Key | Type | Length | Description |
|---|---|---|---|---|
| MANDT | X | CLNT | 3 | Client |
| EMPID | X | CHAR | 10 | Employee ID |
| ENAME |  | CHAR | 40 | Employee Name |
| DEPT |  | CHAR | 10 | Department |
| DESIG |  | CHAR | 30 | Designation |
| DOJ |  | DATS | 8 | Date of Joining |
| STATUS |  | CHAR | 1 | A=Active, I=Inactive |

## ZPMS_SAL_MST (Salary Master)

| Field | Key | Type | Length | Description |
|---|---|---|---|---|
| MANDT | X | CLNT | 3 | Client |
| EMPID | X | CHAR | 10 | Employee ID (FK -> ZPMS_EMP_MST) |
| BASIC |  | CURR | 15,2 | Basic Salary |
| HRA |  | CURR | 15,2 | House Rent Allowance |
| DA |  | CURR | 15,2 | Dearness Allowance |
| PF |  | CURR | 15,2 | Provident Fund deduction |
| TAX |  | CURR | 15,2 | Tax deduction |
| CURRCY |  | CUKY | 5 | Currency key |

## ZPMS_PAY_TRN (Payroll Transaction — one row generated per payroll run)

| Field | Key | Type | Length | Description |
|---|---|---|---|---|
| MANDT | X | CLNT | 3 | Client |
| EMPID | X | CHAR | 10 | Employee ID |
| PAYMONTH | X | CHAR | 6 | Payroll period, e.g. 202609 |
| GROSS_PAY |  | CURR | 15,2 | BASIC + HRA + DA |
| TOTAL_DEDUCT |  | CURR | 15,2 | PF + TAX |
| NET_PAY |  | CURR | 15,2 | GROSS_PAY - TOTAL_DEDUCT |
| RUN_DATE |  | DATS | 8 | Date the payroll run was executed |
| RUN_STATUS |  | CHAR | 1 | P=Processed, E=Error |

Foreign keys: `ZPMS_SAL_MST-EMPID` → `ZPMS_EMP_MST-EMPID`,
`ZPMS_PAY_TRN-EMPID` → `ZPMS_EMP_MST-EMPID`.
