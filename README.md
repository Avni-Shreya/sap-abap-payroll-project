# Payroll & Employee Management System — SAP ABAP

🔗 **Live Demo:** [avni-shreya.github.io/sap-abap-payroll-project](https://avni-shreya.github.io/sap-abap-payroll-project/)

A complete SAP ABAP project for managing employees, salaries, and payroll
processing — built end-to-end from Data Dictionary objects through Module
Pool dialog screens, reporting, forms, and a set of production-style
extensions (custom exceptions, unit tests, authorization checks, and more).

## Project Overview

This project automates employee and payroll management: maintaining employee
and salary master data, running monthly payroll calculations, generating
payslips, and reporting on payroll history — while demonstrating the core and
advanced building blocks of ABAP development along the way.

## Features

- **Employee Management** — Add, Display, Update, Delete (Module Pool CRUD screens)
- **Salary Management** — Add, Display, Update, Delete, with referential checks against the Employee Master
- **Payroll Processing** — monthly calculation of Gross Pay, Deductions, and Net Pay, with duplicate-run protection
- **Payroll Reporting** — ALV report with filters and a Net Pay totals row
- **Payslip Generation** — Smart Form payslip per employee, callable individually or as a scheduled batch job
- **Custom Transaction Code** (`ZPAYROLL`) with a Module Pool main navigation screen
- **OOABAP design** — employee/manager classes with inheritance and bonus calculation logic
- **Reusable data model** — a CDS view for reporting and future Fiori/OData exposure
- **Robust error handling** — a custom exception class hierarchy instead of scattered return-code checks
- **Extensibility** — a BAdI so bonus rules can be customized without touching core logic
- **Automated testing** — ABAP Unit tests covering the bonus calculation logic
- **System integration** — an RFC-enabled function module for external systems to read employee data
- **Access control** — a custom authorization object restricting payroll data by department
- **Notifications** — email alert sent when a payslip is generated
- **Debugging log** — worked examples of finding and fixing real bugs with the ABAP debugger

## Tech Stack

SAP ABAP · Module Pool Programming · Screen Painter (SE51) · Menu Painter (SE41)
· Open SQL · ABAP Dictionary (SE11) · CDS Views · Smart Forms · OOABAP
· BAdI / Enhancement Framework · ABAP Unit · Authorization Objects (SU21) ·
Background Job Scheduling · RFC-Enabled Function Modules

## Database Tables

| Table | Purpose |
|---|---|
| `ZPMS_EMP_MST` | Employee master data |
| `ZPMS_SAL_MST` | Salary master data (basic, HRA, DA, PF, tax) |
| `ZPMS_PAY_TRN` | Payroll transaction history (one row per processed month) |
| `ZEMP_MASTER` / `ZDEPT_MASTER` | Supporting master data used by the reporting/OOABAP modules |

Full field-level definitions are in `src/module_pool/zpms_ddic_tables.md` and
`src/ddic/ddic_objects.md`.

## Transaction Code

`ZPAYROLL` — opens the main navigation screen (Screen 0100), with links to
Employee Management, Salary Management, Payroll Processing, and the Payroll
Report.

## Project Structure

```
sap-abap-project/
├── README.md
├── docs/
│   ├── technical_spec.md          Full technical specification
│   └── index.html                 GitHub Pages showcase page (see Live Demo below)
├── src/
│   ├── basics/                    ABAP fundamentals demo program
│   ├── ddic/                      Data Dictionary build spec + sample data loader
│   ├── reports/                   Open SQL + ALV reporting program
│   ├── debug/                     Debugging log: 3 bugs found and fixed
│   ├── classes/                   OOABAP: employee/manager classes + test report
│   ├── forms/                     Smart Form payslip + driver program
│   ├── module_pool/                Module Pool CRUD screens, tcode, payroll processing & report
│   └── advanced/                  CDS view, exceptions, BAdI, unit tests, RFC, batch jobs,
│                                   authorization object, email notifications, OData notes
└── test/
    └── test_cases.md              Test case log
```

---

## Deploying This Project in an SAP System

ABAP only runs inside an SAP system — there's no way to execute it directly
from GitHub. Build the objects in this order, since later ones depend on
earlier ones:

1. **Data Dictionary tables** (SE11) — build `ZPMS_EMP_MST`, `ZPMS_SAL_MST`,
   `ZPMS_PAY_TRN` from `src/module_pool/zpms_ddic_tables.md`, and
   `ZEMP_MASTER`/`ZDEPT_MASTER` from `src/ddic/ddic_objects.md`. Activate all.
2. **Sample data** — run `src/ddic/zr_load_sample_data.abap` (SE38) once to
   populate test records.
3. **Reports** — create each `.abap` file in `src/basics/`, `src/reports/`,
   and `src/module_pool/` as an Executable Program (SE38), pasting in the
   code and activating.
4. **Classes** — create `ZCL_EMPLOYEE`, `ZCL_MANAGER`, and the ABAP Unit test
   class in `src/classes/` and `src/advanced/` via SE24 (Class Builder) or
   directly in SE38 as local classes.
5. **Smart Form** — build `ZSF_PAYSLIP` in SMARTFORMS per
   `src/forms/zsf_payslip_notes.md`, then create the driver program.
6. **Module Pool screens** — build Screen 0100 for `ZPMS_MAIN_NAV`,
   `ZPMS_EMPLOYEE_MGMT`, and `ZPMS_SALARY_MGMT` using Screen Painter (SE51)
   and Menu Painter (SE41), following `src/module_pool/tcode_setup.md`.
7. **Transaction code** — create `ZPAYROLL` (and sub-tcodes `ZPMS_EMP` /
   `ZPMS_SAL`) in SE93, pointing to the programs and screens above.
8. **Advanced objects** (optional but recommended) — CDS view, custom
   exception class, BAdI, authorization object, and RFC function module from
   `src/advanced/`, each built via ADT/Eclipse or the relevant transaction
   (SE18/SE19 for BAdI, SU21 for the authorization object, SE37 for the
   function module).
9. **Test** — run the ABAP Unit tests, then walk through `test/test_cases.md`
   manually to confirm each program behaves as expected.
10. Assign everything to a **package** and a **transport request** so it can
    move between your development, QA, and production systems normally.

If you don't have access to a company SAP system, the free **SAP BTP ABAP
Environment trial** (via SAP Community / SAP Learning) gives you a real
system with SE11/SE38/SE80 access to build all of this yourself.

---

## Deploying / Publishing This Project on GitHub

### 1. Push the code

```bash
cd sap-abap-project
git init
git add .
git commit -m "Initial commit: Payroll & Employee Management System"

# Create an empty repo first at https://github.com/new (no README/license)
git remote add origin https://github.com/<your-username>/<repo-name>.git
git branch -M main
git push -u origin main
```

If GitHub asks for a password when pushing, use a **Personal Access Token**
instead (GitHub → Settings → Developer settings → Personal access tokens →
Generate new token → scope `repo`).

### 2. Keep it updated

```bash
git add .
git commit -m "Add payroll processing report"
git push
```

### 3. "Live" showcase — what's actually possible on GitHub

GitHub can't execute ABAP — it has no SAP system behind it — so there's no
way to make the program itself run live from a repo. What you *can* do,
which is what recruiters actually look at, is publish a **GitHub Pages**
showcase site that presents the project, its architecture, and real
screenshots/output from your own SAP system:

1. In your repo, keep the page at `docs/index.html` (already included —
   see below)
2. On GitHub: **Settings → Pages → Source → Deploy from a branch → `main`
   branch, `/docs` folder → Save**
3. GitHub gives you a live URL like
   `https://<your-username>.github.io/<repo-name>/` within a minute or two
4. Once you've built the objects in a real SAP system, take screenshots of:
   - The main navigation screen (`ZPAYROLL`)
   - The Employee/Salary CRUD screens
   - The ALV payroll report
   - The generated payslip (Smart Form output / print preview)
5. Add them to a `Screenshots/` folder in the repo and reference them in
   `docs/index.html` (placeholders are already marked with comments) — this
   becomes your "live" result page, linked straight from your resume/LinkedIn.

A starter `docs/index.html` page is included in this project — open it,
replace the placeholder screenshot paths with your own images, and it's
ready to publish.

## Conclusion

This project demonstrates practical, end-to-end SAP ABAP development — Module
Pool Programming, report and form development, OOABAP, and payroll
automation — matching a real-time business scenario from data model to
deployable transaction code.
