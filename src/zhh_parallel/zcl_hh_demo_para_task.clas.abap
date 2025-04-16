CLASS zcl_hh_demo_para_task DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    INTERFACES if_abap_parallel.

    METHODS constructor
      IMPORTING is_partner TYPE zcl_hh_demo_para_data=>ts_partner.

    METHODS get_result
      RETURNING VALUE(rt_result) TYPE zcl_hh_demo_para_data=>tt_result.

  PRIVATE SECTION.
    DATA ms_partner TYPE zcl_hh_demo_para_data=>ts_partner.
    DATA mt_result  TYPE zcl_hh_demo_para_data=>tt_result.
ENDCLASS.


CLASS zcl_hh_demo_para_task IMPLEMENTATION.
  METHOD if_abap_parallel~do.
    WAIT UP TO 1 SECONDS.
    INSERT NEW zcl_hh_demo_para_data( )->get_result_from_partner( ms_partner ) INTO TABLE mt_result.
  ENDMETHOD.

  METHOD constructor.
    ms_partner = is_partner.
  ENDMETHOD.

  METHOD get_result.
    RETURN mt_result.
  ENDMETHOD.
ENDCLASS.
