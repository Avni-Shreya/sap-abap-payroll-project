*&---------------------------------------------------------------*
*& Report ZR_EMP_EDITABLE_ALV
*&---------------------------------------------------------------*
*& Purpose : Editable ALV Grid with save-back to ZEMP_MASTER,
*&           using cl_gui_alv_grid (interactive, not read-only
*&           like the cl_salv_table version in Module 3).
*&---------------------------------------------------------------*
REPORT zr_emp_editable_alv.

DATA: gt_emp    TYPE TABLE OF zemp_master,
      gs_layout TYPE lvc_s_layo,
      gt_fcat   TYPE lvc_t_fcat.

DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv       TYPE REF TO cl_gui_alv_grid.

CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS handle_data_changed
      FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING er_data_changed.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD handle_data_changed.
    " Fired when the user edits a cell - validate before it's committed
    DATA(lt_good) = er_data_changed->mt_good_cells.
    LOOP AT lt_good INTO DATA(ls_good) WHERE fieldname = 'SALARY'.
      IF ls_good-value < 0.
        er_data_changed->add_protocol_entry(
          i_msgid = 'ZPAYROLL' i_msgno = '003' i_msgty = 'E'
          i_fieldname = 'SALARY' i_row_id = ls_good-row_id ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

DATA(go_handler) = NEW lcl_event_handler( ).

START-OF-SELECTION.
  SELECT * FROM zemp_master INTO TABLE @gt_emp.

  CALL SCREEN 100.

*&---------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.

  IF go_container IS NOT BOUND.
    go_container = NEW #( container_name = 'ALV_CONTAINER' ).
    go_alv       = NEW #( i_parent = go_container ).

    gs_layout-edit = abap_true.

    gt_fcat = VALUE #(
      ( fieldname = 'EMPID'  coltext = 'Emp ID'   edit = abap_false )
      ( fieldname = 'ENAME'  coltext = 'Name'      edit = abap_true )
      ( fieldname = 'DEPT'   coltext = 'Dept'       edit = abap_true )
      ( fieldname = 'SALARY' coltext = 'Salary'     edit = abap_true )
    ).

    SET HANDLER go_handler->handle_data_changed FOR go_alv.

    go_alv->set_table_for_first_display(
      EXPORTING
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_emp
        it_fieldcatalog = gt_fcat ).
  ENDIF.
ENDMODULE.

MODULE user_command_0100 INPUT.
  DATA(lv_ok) = sy-ucomm.
  CLEAR sy-ucomm.

  CASE lv_ok.
    WHEN 'SAVE'.
      go_alv->check_changed_data( ).
      MODIFY zemp_master FROM TABLE gt_emp.
      IF sy-subrc = 0.
        COMMIT WORK.
        MESSAGE 'Changes saved' TYPE 'S'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE 'Save failed' TYPE 'E'.
      ENDIF.

    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

* NOTE: Requires Screen 100 with a Custom Container named ALV_CONTAINER
* and a GUI Status STATUS_0100 with SAVE/BACK/EXIT/CANC function codes,
* built in the Screen Painter (SE51) - referenced here, not auto-generated.
