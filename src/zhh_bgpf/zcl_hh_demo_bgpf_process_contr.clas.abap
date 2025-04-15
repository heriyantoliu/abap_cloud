CLASS zcl_hh_demo_bgpf_process_contr DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    INTERFACES if_bgmc_operation.
    INTERFACES if_bgmc_op_single.

    METHODS
      constructor
        IMPORTING it_data TYPE zcl_hh_demo_bgpf_data=>tt_data.

  PRIVATE SECTION.
    DATA mt_data TYPE zcl_hh_demo_bgpf_data=>tt_data.
ENDCLASS.


CLASS zcl_hh_demo_bgpf_process_contr IMPLEMENTATION.
  METHOD if_bgmc_op_single~execute.
    data(lo_table) = new zcl_hh_demo_bgpf_data( ).

    cl_abap_tx=>modify( ).

    loop at mt_data into data(ls_data).
      lo_table->add( ls_data ).
    endloop.

    cl_abap_tx=>save( ).

    lo_table->save( abap_false ).
  ENDMETHOD.

  METHOD constructor.
    mt_data = it_data.
  ENDMETHOD.
ENDCLASS.
