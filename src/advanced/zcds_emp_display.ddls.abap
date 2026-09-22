"! CDS View: ZCDS_EMP_DISPLAY
"! Purpose: Modern data-modeling replacement for the ZR_EMP_REPORT
"! Open SQL join - pushes the join/aggregation down to the database
"! and can be consumed directly by Fiori/Analytics tools, not just
"! a classic ABAP report. Create via ADT (Eclipse) or SE80 New DDLS.
"!---------------------------------------------------------------
@AbapCatalog.sqlViewName: 'ZVEMPDISPLAY'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Employee Display with Department'
define view ZCDS_EMP_DISPLAY
  as select from zemp_master as e
  inner join     zdept_master as d
    on e.dept = d.deptid
{
  key e.empid,
      e.ename,
      e.dept,
      d.deptname,
      d.location,
      e.salary,
      e.currcy,
      e.doj,

      // Derived field - years of service, computed in the DB layer
      case
        when e.doj is not null
        then cast( dats_days_between( e.doj, $session.system_date ) / 365 as integer )
        else 0
      end as years_of_service
}

/*
Usage:
  SELECT * FROM zcds_emp_display INTO TABLE @DATA(lt_emp)
    WHERE dept = 'IT'.

Why this matters over a plain Open SQL JOIN in a report:
  - Reusable across multiple reports, Fiori apps, and CDS-based analytics
    (single source of truth for the join logic)
  - Push-down: filtering/aggregation happens in the database, not in ABAP
  - Can be extended with associations, authorization checks
    (@AccessControl.authorizationCheck), and annotations for OData exposure
*/
