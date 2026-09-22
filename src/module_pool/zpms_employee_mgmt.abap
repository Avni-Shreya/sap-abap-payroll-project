*&---------------------------------------------------------------*
*& Module Pool ZPMS_EMPLOYEE_MGMT
*&---------------------------------------------------------------*
*& Purpose : Add / Display / Update / Delete for ZPMS_EMP_MST via
*&           a classic dialog screen (Screen 0100, built in SE51
*&           with input fields for each column + an OK-CODE field).
*&---------------------------------------------------------------*
PROGRAM zpms_employee_mgmt.

TABLES: zpms_emp_mst.

DATA: gv_mode  TYPE c LENGTH 1,   " A=Add, D=Display, U=Update, X=Delete
      gs_emp   TYPE zpms_emp_mst.

MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.
  SET TITLEBAR 'TITLE_0100'.

  " Fields are read-only in Display mode, editable otherwise
  LOOP AT SCREEN.
    IF gv_mode = 'D'.
      screen-input = 0.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.

MODULE user_command_0100 INPUT.
  DATA(lv_ok) = sy-ucomm.
  CLEAR sy-ucomm.

  CASE lv_ok.
    WHEN 'ADD'.
      gv_mode = 'A'.
      CLEAR zpms_emp_mst.

    WHEN 'DISP'.
      gv_mode = 'D'.
      PERFORM read_employee.

    WHEN 'UPD'.
      gv_mode = 'U'.
      PERFORM read_employee.

    WHEN 'DEL'.
      PERFORM delete_employee.

    WHEN 'SAVE'.
      PERFORM save_employee.

    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.

FORM read_employee.
  SELECT SINGLE * FROM zpms_emp_mst
    INTO zpms_emp_mst
    WHERE empid = zpms_emp_mst-empid.

  IF sy-subrc <> 0.
    MESSAGE 'Employee not found' TYPE 'E'.
  ENDIF.
ENDFORM.

FORM save_employee.
  IF zpms_emp_mst-empid IS INITIAL.
    MESSAGE 'Employee ID is required' TYPE 'E'.
    RETURN.
  ENDIF.

  CASE gv_mode.
    WHEN 'A'.
      INSERT zpms_emp_mst FROM zpms_emp_mst.
      IF sy-subrc = 0.
        MESSAGE 'Employee added' TYPE 'S'.
      ELSE.
        MESSAGE 'Employee ID already exists' TYPE 'E'.
      ENDIF.

    WHEN 'U'.
      UPDATE zpms_emp_mst FROM zpms_emp_mst.
      IF sy-subrc = 0.
        MESSAGE 'Employee updated' TYPE 'S'.
      ELSE.
        MESSAGE 'Update failed' TYPE 'E'.
      ENDIF.
  ENDCASE.

  COMMIT WORK.
ENDFORM.

FORM delete_employee.
  DELETE FROM zpms_emp_mst WHERE empid = zpms_emp_mst-empid.
  IF sy-subrc = 0.
    COMMIT WORK.
    MESSAGE 'Employee deleted' TYPE 'S'.
  ELSE.
    MESSAGE 'Delete failed / employee not found' TYPE 'E'.
  ENDIF.
ENDFORM.
