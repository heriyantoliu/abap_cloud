CLASS zcl_hh_demo_bgpf_data DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES ts_data TYPE zhh_dmo_bgpf.
    TYPES tt_data TYPE TABLE OF ts_data WITH EMPTY KEY.

    METHODS add
      IMPORTING is_data TYPE ts_data.

    METHODS save
      IMPORTING id_commit TYPE abap_bool.

  PRIVATE SECTION.
    DATA mt_data TYPE tt_data.
ENDCLASS.


CLASS zcl_hh_demo_bgpf_data IMPLEMENTATION.
  METHOD add.
    WAIT UP TO 1 SECONDS.

    DATA(ls_data) = is_data.
    TRY.
        ls_data-identifier = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error.

    ENDTRY.
    ls_data-created_from = cl_abap_context_info=>get_user_alias( ).
    ls_data-created_at   = utclong_current( ).

    INSERT ls_data INTO TABLE mt_data.
  ENDMETHOD.

  METHOD save.
    INSERT zhh_dmo_bgpf FROM TABLE @mt_data.
    IF id_commit = abap_true.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
