*&---------------------------------------------------------------*
*& Class ZCL_EMAIL_NOTIFIER
*&---------------------------------------------------------------*
*& Purpose : Sends an email notification once a payslip is
*&           generated, using the modern cl_bcs (Business
*&           Communication Services) API instead of the older
*&           SO_NEW_DOCUMENT_ATT_SEND_API1 function module.
*&---------------------------------------------------------------*
CLASS zcl_email_notifier DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS send_payslip_notification
      IMPORTING
        iv_recipient_email TYPE ad_smtpadr
        iv_empname         TYPE char40
        iv_month           TYPE char10
      RAISING
        cx_bcs.

ENDCLASS.

CLASS zcl_email_notifier IMPLEMENTATION.

  METHOD send_payslip_notification.
    DATA(lo_send_request) = cl_bcs=>create_persistent( ).

    DATA(lv_text) = |Dear { iv_empname },\n\n| &&
                    |Your payslip for { iv_month } has been generated | &&
                    |and is available in the ESS portal.\n\n| &&
                    |Regards,\nPayroll Team|.

    DATA(lo_document) = cl_document_bcs=>create_document(
      i_type    = 'RAW'
      i_text    = VALUE soli_tab( ( line = lv_text ) )
      i_subject = |Payslip Generated - { iv_month }| ).

    lo_send_request->set_document( lo_document ).

    DATA(lo_recipient) = cl_cam_address_bcs=>create_internet_address(
      iv_recipient_email ).

    lo_send_request->add_recipient( lo_recipient ).
    lo_send_request->set_send_immediately( abap_true ).
    lo_send_request->send( ).

    COMMIT WORK.
  ENDMETHOD.

ENDCLASS.

* Called from ZR_PAYSLIP_DRIVER after a successful Smart Form call:
*
*   TRY.
*       zcl_email_notifier=>send_payslip_notification(
*         iv_recipient_email = 'employee@company.com'
*         iv_empname         = ls_emp-ename
*         iv_month            = sy-datum(6) ).
*     CATCH cx_bcs INTO DATA(lx_bcs).
*       MESSAGE lx_bcs->get_text( ) TYPE 'I'.
*   ENDTRY.
