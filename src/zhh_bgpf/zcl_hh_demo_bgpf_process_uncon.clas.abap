CLASS zcl_hh_demo_bgpf_process_uncon DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    INTERFACES if_bgmc_operation.
    INTERFACES if_bgmc_op_single_tx_uncontr.

    METHODS constructor
      IMPORTING it_data TYPE zcl_hh_demo_bgpf_data=>tt_data.

  PRIVATE SECTION.
    DATA mt_data TYPE zcl_hh_demo_bgpf_data=>tt_data.
ENDCLASS.


CLASS zcl_hh_demo_bgpf_process_uncon IMPLEMENTATION.
  METHOD if_bgmc_op_single_tx_uncontr~execute.
    data(lo_table) = new zcl_hh_demo_bgpf_data( ).

    loop at mt_data into data(ls_data).
      lo_table->add( ls_data ).
    endloop.

    lo_table->save( abap_true ).
  ENDMETHOD.

  METHOD constructor.
    mt_data = it_data.
  ENDMETHOD.
ENDCLASS.
