*&---------------------------------------------------------------*
*& Module Pool ZPMS_SALARY_MGMT
*&---------------------------------------------------------------*
*& Purpose : Add / Display / Update / Delete for ZPMS_SAL_MST.
*&           Same pattern as ZPMS_EMPLOYEE_MGMT, plus a check that
*&           the employee exists before a salary record is added.
*&---------------------------------------------------------------*
PROGRAM zpms_salary_mgmt.

TABLES: zpms_sal_mst.

DATA: gv_mode TYPE c LENGTH 1.

MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.
  SET TITLEBAR 'TITLE_0100'.

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
      CLEAR zpms_sal_mst KEEPING zpms_sal_mst-empid.

    WHEN 'DISP'.
      gv_mode = 'D'.
      PERFORM read_salary.

    WHEN 'UPD'.
      gv_mode = 'U'.
      PERFORM read_salary.

    WHEN 'DEL'.
      PERFORM delete_salary.

    WHEN 'SAVE'.
      PERFORM save_salary.

    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.

FORM read_salary.
  SELECT SINGLE * FROM zpms_sal_mst
    INTO zpms_sal_mst
    WHERE empid = zpms_sal_mst-empid.

  IF sy-subrc <> 0.
    MESSAGE 'Salary record not found' TYPE 'E'.
  ENDIF.
ENDFORM.

FORM save_salary.
  DATA: lv_exists TYPE char10.

  IF zpms_sal_mst-empid IS INITIAL.
    MESSAGE 'Employee ID is required' TYPE 'E'.
    RETURN.
  ENDIF.

  " Referential check - employee must exist before a salary record does
  SELECT SINGLE empid FROM zpms_emp_mst
    INTO lv_exists
    WHERE empid = zpms_sal_mst-empid.

  IF sy-subrc <> 0.
    MESSAGE 'No such employee in Employee Master - add employee first' TYPE 'E'.
    RETURN.
  ENDIF.

  CASE gv_mode.
    WHEN 'A'.
      INSERT zpms_sal_mst FROM zpms_sal_mst.
      IF sy-subrc = 0.
        MESSAGE 'Salary record added' TYPE 'S'.
      ELSE.
        MESSAGE 'Salary record already exists for this employee' TYPE 'E'.
      ENDIF.

    WHEN 'U'.
      UPDATE zpms_sal_mst FROM zpms_sal_mst.
      IF sy-subrc = 0.
        MESSAGE 'Salary record updated' TYPE 'S'.
      ELSE.
        MESSAGE 'Update failed' TYPE 'E'.
      ENDIF.
  ENDCASE.

  COMMIT WORK.
ENDFORM.

FORM delete_salary.
  DELETE FROM zpms_sal_mst WHERE empid = zpms_sal_mst-empid.
  IF sy-subrc = 0.
    COMMIT WORK.
    MESSAGE 'Salary record deleted' TYPE 'S'.
  ELSE.
    MESSAGE 'Delete failed / record not found' TYPE 'E'.
  ENDIF.
ENDFORM.
