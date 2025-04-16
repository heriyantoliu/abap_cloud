CLASS zcl_hh_demo_para_start DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS start_scenario_1
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS start_scenario_2
      IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.


CLASS zcl_hh_demo_para_start IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    out->write( 'Scenario 1 - Inheritance' ).
    start_scenario_1( out ).

    out->write( 'Scenario 2 - Interface' ).
    start_scenario_2( out ).
  ENDMETHOD.

  METHOD start_scenario_1.
    DATA ld_in     TYPE xstring.
    DATA lt_in     TYPE cl_abap_parallel=>t_in_tab.
    DATA lt_out    TYPE zcl_hh_demo_para_data=>tt_result.
    DATA lt_result TYPE zcl_hh_demo_para_data=>tt_result.

    DATA(lo_timer) = NEW zcl_hh_demo_runtime( ).
    DATA(lo_data) = NEW zcl_hh_demo_para_data( ).
    DATA(lo_parallel) = NEW zcl_hh_demo_para_inheriting( p_num_tasks = 3 ).

    LOOP AT lo_data->get_partners( ) INTO DATA(ls_partner).
      CALL TRANSFORMATION id SOURCE in = ls_partner
           RESULT XML ld_in.

      INSERT ld_in INTO TABLE lt_in.
    ENDLOOP.

    lo_parallel->run( EXPORTING p_in_tab  = lt_in
                      IMPORTING p_out_tab = DATA(l_out_tab) ).

    LOOP AT l_out_tab ASSIGNING FIELD-SYMBOL(<l_out>).
      CALL TRANSFORMATION id SOURCE XML <l_out>-result
           RESULT out = lt_out.
      INSERT LINES OF lt_out INTO TABLE lt_result.
    ENDLOOP.

    io_out->write( lo_timer->get_diff( ) ).
    io_out->write( lt_result ).
  ENDMETHOD.

  METHOD start_scenario_2.
    DATA lt_processes TYPE cl_abap_parallel=>t_in_inst_tab.
    DATA lt_result    TYPE zcl_hh_demo_para_data=>tt_result.

    DATA(lo_timer) = NEW zcl_hh_demo_runtime( ).
    DATA(lo_data) = NEW zcl_hh_demo_para_data( ).

    LOOP AT lo_data->get_partners( ) INTO DATA(ls_partner).
      INSERT NEW zcl_hh_demo_para_task( ls_partner ) INTO TABLE lt_processes.
    ENDLOOP.

    NEW cl_abap_parallel( p_num_tasks = 3 )->run_inst( EXPORTING p_in_tab  = lt_processes
                                                       IMPORTING p_out_tab = DATA(lt_finished) ).

    LOOP AT lt_finished INTO DATA(ls_finished).
      INSERT LINES OF CAST zcl_hh_demo_para_task( ls_finished-inst )->get_result( ) INTO TABLE lt_result.
    ENDLOOP.

    io_out->write( lo_timer->get_diff( ) ).
    io_out->write( lt_result ).
  ENDMETHOD.
ENDCLASS.
