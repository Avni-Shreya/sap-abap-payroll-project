# Test Case Log (Module 7)

| # | Program | Test Case | Input | Expected Output | Actual Output | Pass/Fail |
|---|---------|-----------|-------|------------------|----------------|-----------|
| 1 | ZR_EMP_REPORT | Filter by single department | S_DEPT = IT | Only IT employees shown | Only IT employees shown | Pass |
| 2 | ZR_EMP_REPORT | Filter by date range with no matches | S_DOJ = 01.01.2020–31.12.2020 | Empty ALV grid, no dump | Empty ALV grid, no dump | Pass |
| 3 | ZR_EMP_REPORT | Aggregate average salary | No filter | Correct AVG(salary) per dept | Correct AVG(salary) per dept | Pass |
| 4 | ZCL_EMPLOYEE | Bonus calculation | Salary = 45000 | Bonus = 4500 (10%) | Bonus = 4500 | Pass |
| 5 | ZCL_MANAGER | Bonus calculation with team | Salary = 90000, team_size = 5 | Bonus = 9000 + 9000 = 18000 | Bonus = 18000 | Pass |
| 6 | ZCL_MANAGER | Inheritance - get_details() | - | Includes "Manages 5 people" text | Includes correct text | Pass |
| 7 | ZR_PAYSLIP_DRIVER | Valid employee ID | P_EMPID = 1001 | Payslip PDF/print preview generated | Generated successfully | Pass |
| 8 | ZR_PAYSLIP_DRIVER | Invalid employee ID | P_EMPID = 9999 | Error message "Employee not found" | Correct error message shown | Pass |
| 9 | ZR_LOAD_SAMPLE_DATA | Re-run loader twice | Run twice | No duplicate key dump (MODIFY, not INSERT) | No dump, records updated | Pass |
| 10 | ZR_EMP_REPORT | Debugger - Bug 1 fix verification | Salary = 50000 (boundary) | NOT flagged as high salary (uses >) | Correctly not flagged | Pass |

## How to extend

Add a new row for every program change, and re-run all rows before pushing a
commit that touches Data Dictionary objects — a DDIC change (like a new field)
can silently break an older program that relies on field order.
