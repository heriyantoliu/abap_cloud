CLASS zcl_hh_demo_bgpf_start DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS run_uncontrolled_process
      RETURNING VALUE(rd_result) TYPE string.

    METHODS run_controlled_process
      RETURNING VALUE(rd_result) TYPE string.

    METHODS wait_and_log
      IMPORTING io_out    TYPE REF TO if_oo_adt_classrun_out
                id_string TYPE string
      RAISING   cx_bgmc.
ENDCLASS.


CLASS zcl_hh_demo_bgpf_start IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM zhh_dmo_bgpf.
    COMMIT WORK.

    out->write( 'Start uncontrolled' ).
    DATA(ld_string) = run_uncontrolled_process( ).
    TRY.
        wait_and_log( io_out    = out
                      id_string = ld_string ).
      CATCH cx_bgmc.

    ENDTRY.

    out->write( 'Start controlled' ).
    ld_string = run_controlled_process( ).
    TRY.
        wait_and_log( io_out    = out
                      id_string = ld_string ).
      CATCH cx_bgmc.

    ENDTRY.
  ENDMETHOD.

  METHOD run_uncontrolled_process.
    DATA lo_operation TYPE REF TO if_bgmc_op_single_tx_uncontr.

    DATA(lt_data) = VALUE zcl_hh_demo_bgpf_data=>tt_data(
                              ( description = 'Test 1' inumber = 12 amount = '12.54' currency = 'EUR' )
                              ( description = 'Test 2' inumber = 95 amount = '0.21' currency = 'USD' )
                              ( description = 'Test 3' inumber = 547 amount = '145.50' currency = 'EUR' ) ).

    lo_operation = NEW zcl_hh_demo_bgpf_process_uncon( lt_data ).

    TRY.
        DATA(lo_process) = cl_bgmc_process_factory=>get_default( )->create( ).
        lo_process->set_name( 'Uncontrolled Process' )->set_operation_tx_uncontrolled( lo_operation ).

        DATA(lo_process_monitor) = lo_process->save_for_execution( ).
        COMMIT WORK.

        RETURN lo_process_monitor->to_string( ).
      CATCH cx_bgmc.
        ROLLBACK WORK.
    ENDTRY.
  ENDMETHOD.

  METHOD wait_and_log.
    DATA(lo_process_monitor) = cl_bgmc_process_factory=>create_monitor_from_string( id_string ).

    DO.
      IF sy-index = 60.
        EXIT.
      ENDIF.
      DATA(ld_state) = lo_process_monitor->get_state( ).

      io_out->write( ld_state ).
      io_out->write( utclong_current( ) ).

      IF    ld_state = if_bgmc_process_monitor=>gcs_state-successful
         OR ld_state = if_bgmc_process_monitor=>gcs_state-erroneous.
        EXIT.
      ENDIF.

      WAIT UP TO 1 SECONDS.
    ENDDO.
  ENDMETHOD.

  METHOD run_controlled_process.
    DATA lo_operation TYPE REF TO if_bgmc_op_single.

    DATA(lt_data) = VALUE zcl_bs_demo_bgpf_data=>tt_data(
                              ( description = 'Control 1' inumber = 12 amount = '12.54' currency = 'EUR' )
                              ( description = 'Control 2' inumber = 95 amount = '0.21' currency = 'USD' )
                              ( description = 'Control 3' inumber = 547 amount = '145.50' currency = 'EUR' ) ).

    lo_operation = NEW zcl_hh_demo_bgpf_process_contr( lt_data ).

    TRY.
        DATA(lo_process) = cl_bgmc_process_factory=>get_default( )->create( ).

        lo_process->set_name( 'Controlled Process' )->set_operation( lo_operation ).
        DATA(lo_process_monitor) = lo_process->save_for_execution( ).
        COMMIT WORK.

        RETURN lo_process_monitor->to_string( ).
      CATCH cx_bgmc.
        ROLLBACK WORK.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
