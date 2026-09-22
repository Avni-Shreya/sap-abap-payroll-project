FUNCTION zfm_get_employee_details.
*"----------------------------------------------------------------------
*"*"Local interface: (Remote-Enabled Module - flag set in SE37 attributes)
*"  IMPORTING
*"     VALUE(IV_EMPID) TYPE  CHAR10
*"  EXPORTING
*"     VALUE(ES_EMPLOYEE) TYPE  ZEMP_DISPLAY_STR
*"  EXCEPTIONS
*"      EMPLOYEE_NOT_FOUND
*"----------------------------------------------------------------------
*&---------------------------------------------------------------*
*& Purpose : RFC-enabled Function Module - allows an EXTERNAL
*&           system (another SAP system, a middleware, or a
*&           non-SAP app via RFC/SOAP) to fetch employee data.
*&           This is the same mechanism real BAPIs are built on.
*&
*&           Build in SE37: Function module -> Attributes ->
*&           Processing Type -> "Remote-Enabled Module"
*&---------------------------------------------------------------*

  SELECT SINGLE e~empid, e~ename, d~deptname, d~location,
                e~salary, e~currcy
    FROM zemp_master AS e
    INNER JOIN zdept_master AS d ON e~dept = d~deptid
    WHERE e~empid = @iv_empid
    INTO CORRESPONDING FIELDS OF @es_employee.

  IF sy-subrc <> 0.
    RAISE employee_not_found.
  ENDIF.

ENDFUNCTION.

* Consuming this from another system (example, called via RFC destination):
*
*   DATA: ls_employee TYPE zemp_display_str.
*
*   CALL FUNCTION 'ZFM_GET_EMPLOYEE_DETAILS'
*     DESTINATION 'MY_RFC_DEST'
*     EXPORTING
*       iv_empid    = '1001'
*     IMPORTING
*       es_employee = ls_employee
*     EXCEPTIONS
*       employee_not_found = 1
*       communication_failure = 2 MESSAGE lv_msg
*       system_failure        = 3 MESSAGE lv_msg
*       OTHERS = 4.
*
* This is the same pattern used to expose data to a third-party
* payroll system, an external HR tool, or a middleware layer -
* real "integration" experience, not just internal reporting.
