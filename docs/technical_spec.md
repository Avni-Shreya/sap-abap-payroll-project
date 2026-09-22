# Technical Specification: Employee & Sales Management Mini-Project

## 1. Objective
Demonstrate core SAP ABAP fresher skills (ABAP basics, Data Dictionary, Open SQL,
debugging, OOABAP, Smart Forms) through one connected, self-contained project.

## 2. Objects Delivered

| Object | Type | Description |
|---|---|---|
| ZEMP_MASTER | Table | Employee master data |
| ZDEPT_MASTER | Table | Department master data |
| ZEMP_DISPLAY_STR | Structure | Combined display structure for reporting |
| ZR_EMPLOYEE_BASICS | Report | ABAP fundamentals demo |
| ZR_LOAD_SAMPLE_DATA | Report | One-time sample data loader |
| ZR_EMP_REPORT | Report | Open SQL + ALV reporting with selection screen |
| ZCL_EMPLOYEE | Class | Base employee OOABAP class |
| ZCL_MANAGER | Class | Inherits ZCL_EMPLOYEE, adds team-based bonus logic |
| ZR_EMPLOYEE_OO_TEST | Report | Test harness for the OOABAP classes |
| ZSF_PAYSLIP | Smart Form | Employee payslip layout |
| ZR_PAYSLIP_DRIVER | Report | Calls ZSF_PAYSLIP with employee data |

## 3. Data Flow

1. `ZR_LOAD_SAMPLE_DATA` populates `ZEMP_MASTER` / `ZDEPT_MASTER`
2. `ZR_EMP_REPORT` joins both tables, filters via selection screen, shows ALV
3. `ZCL_EMPLOYEE` / `ZCL_MANAGER` encapsulate business logic (bonus calculation)
4. `ZR_PAYSLIP_DRIVER` reads one employee's data and renders `ZSF_PAYSLIP`

## 4. Assumptions
- Single client, no authorization checks (kept simple for a fresher demo project)
- Currency hardcoded to INR in sample data
- Bonus rules are illustrative, not based on real company policy

## 5. Known Limitations / Next Steps
- No authority checks (`AUTHORITY-CHECK`) — would add in a production scenario
- No exception classes; uses simple `MESSAGE` handling — could evolve to
  `TRY/CATCH` with custom exception classes
- ALV uses `cl_salv_table` (read-only); could extend to editable ALV with
  `cl_gui_alv_grid` for update scenarios
