# Transaction Code & Screen/Menu Painter Setup (Module 9)

## 1. Screen Painter (SE51) — Screen 0100 for ZPMS_MAIN_NAV

1. `SE51` → Program `ZPMS_MAIN_NAV` → Screen `0100` → Create
2. Screen attributes: Screen type = Normal, no GUI titlebar needed here
   (set via `TITLEBAR` in PBO instead)
3. Layout: drop 4 pushbuttons in the Layout Editor:
   - "Employee Management" → function code `EMP_MGMT`
   - "Salary Management" → function code `SAL_MGMT`
   - "Payroll Processing" → function code `PAY_PROC`
   - "Payroll Report" → function code `PAY_RPT`
4. Flow logic auto-generates `PROCESS BEFORE OUTPUT` / `PROCESS AFTER INPUT`
   calling `MODULE status_0100` and `MODULE user_command_0100` — matches the
   module pool code in `zpms_main_nav.abap`

Repeat similarly for `ZPMS_EMPLOYEE_MGMT` screen 0100 (input fields for
EMPID/ENAME/DEPT/DESIG/DOJ/STATUS bound to table `ZPMS_EMP_MST`, via
**Dictionary/Program Fields** in the Layout Editor) and `ZPMS_SALARY_MGMT`
screen 0100 (fields bound to `ZPMS_SAL_MST`).

## 2. Menu Painter (SE41) — GUI Status

Create GUI Status `STATUS_0100` for each program:

**ZPMS_MAIN_NAV / STATUS_0100**
- Menu bar: none required beyond standard
- Function keys: `EMP_MGMT`, `SAL_MGMT`, `PAY_PROC`, `PAY_RPT`, `EXIT`

**ZPMS_EMPLOYEE_MGMT / STATUS_0100** and **ZPMS_SALARY_MGMT / STATUS_0100**
- Toolbar buttons: `ADD`, `DISP`, `UPD`, `DEL`, `SAVE`, `BACK`

Also maintain Title `TITLE_0100` for each (Goto → Text Elements → Titles).

## 3. Transaction Code (SE93)

| Tcode | Type | Program | Screen |
|---|---|---|---|
| `ZPAYROLL` | Dialog Transaction | `ZPMS_MAIN_NAV` | `0100` |
| `ZPMS_EMP` | Dialog Transaction | `ZPMS_EMPLOYEE_MGMT` | `0100` |
| `ZPMS_SAL` | Dialog Transaction | `ZPMS_SALARY_MGMT` | `0100` |

Steps for each:
1. `SE93` → enter tcode name → Create
2. Choose "Dialog Transaction"
3. Enter the Program name and Start Screen number
4. Save, assign to a package/transport request
5. Test by entering the tcode in the SAP GUI command field

## 4. End-to-end flow once built

```
ZPAYROLL (tcode)
  └── ZPMS_MAIN_NAV, Screen 0100 (main navigation)
        ├── EMP_MGMT → ZPMS_EMP tcode → Employee CRUD screen
        ├── SAL_MGMT → ZPMS_SAL tcode → Salary CRUD screen
        ├── PAY_PROC → ZPMS_PAYROLL_PROCESS (batch calculation)
        └── PAY_RPT  → ZPMS_PAYROLL_RPT (ALV report with totals)
```

This is the same architecture the reference project describes (custom tcode +
Module Pool main navigation + Screen/Menu Painter), built out with working
code you can paste directly into SE38/SE51/SE41/SE93.
