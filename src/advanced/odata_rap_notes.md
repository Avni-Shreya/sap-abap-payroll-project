# OData / RAP Service Exposure Notes (Module 8 - Advanced Track)

This is the "stretch goal" of the project — exposing employee/payroll data as
a web service so it could be consumed by a Fiori app, Power BI, or any
external system. Built via UI tools (Eclipse ADT / SEGW), so this file
documents the design rather than containing runnable flat source.

## Option A — Classic OData (transaction SEGW)

1. `SEGW` → create project `ZPAYROLL_ODATA`
2. Import `ZEMP_DISPLAY_STR` as an Entity Type (or generate from the
   `ZCDS_EMP_DISPLAY` CDS view directly — see Option B, which is preferred)
3. Generate runtime objects (MPC/DPC classes)
4. Redefine `GET_ENTITYSET` in the DPC_EXT class to call the same Open SQL
   join used in `ZR_EMP_REPORT`
5. Register the service in `/IWFND/MAINT_SERVICE`
6. Test via the service's `$metadata` URL and a REST client (Postman)

## Option B — RAP (RESTful ABAP Programming Model) — modern approach

RAP is what SAP recommends for S/4HANA/BTP development today, and builds
directly on top of the CDS view already in this project:

1. Add OData annotations to `ZCDS_EMP_DISPLAY`:
   ```abap
   @OData.publish: true
   ```
2. Create a **Behavior Definition** for the entity (defines Create/Update/Delete
   operations, validations, determinations)
3. Implement a **Behavior Pool** class for any custom validation logic
   (e.g., reject a salary update above a threshold without manager approval —
   this is where `zcx_payroll_exception` from this module would be raised)
4. Expose via a **Service Definition** + **Service Binding** (OData V4, UI or
   Web API type)
5. Preview instantly in the Fiori Elements preview inside ADT — no separate
   front-end coding needed for a basic list/detail app

## Why mention this at all for a fresher interview

You're not expected to have built a full Fiori app as a fresher — but naming
RAP/CDS/OData by name, and showing you understand *how* your existing
Open SQL report would evolve into a web service, tells the interviewer you're
tracking where SAP development is actually headed (classical ABAP → RAP/BTP),
which very few freshers do.
