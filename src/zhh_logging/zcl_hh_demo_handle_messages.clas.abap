CLASS zcl_hh_demo_handle_messages DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    METHODS create_log_entries
      RETURNING VALUE(rd_result) TYPE if_bali_log=>ty_handle
      RAISING   cx_static_check.

    METHODS read_log_entries
      IMPORTING id_id            TYPE if_bali_log=>ty_handle
      RETURNING VALUE(rt_result) TYPE if_bali_log=>ty_item_table
      RAISING   cx_static_check.
ENDCLASS.


CLASS zcl_hh_demo_handle_messages IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    TRY.
        DATA(ld_id) = create_log_entries( ).
        out->write( |Log created: { ld_id }| ).

        DATA(lt_items) = read_log_entries( ld_id ).
        LOOP AT lt_items INTO DATA(ls_item).
          out->write( ls_item-item->get_message_text( ) ).
        ENDLOOP.
      CATCH cx_root INTO DATA(lo_err).
        out->write( lo_err->get_longtext( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD create_log_entries.
    DATA(lo_log) = cl_bali_log=>create( ).

    DATA(lo_handler) = cl_bali_header_setter=>create( object      = 'ZHH_DEMO_LOG_OBJECT'
                                                      subobject   = 'TEST'
                                                      external_id = cl_system_uuid=>create_uuid_c32_static( )
                       )->set_expiry( expiry_date       = CONV d( cl_abap_context_info=>get_system_date( ) + 7 )
                                      keep_until_expiry = abap_true ).
    lo_log->set_header( lo_handler ).

    MESSAGE s001(zhh_demo_log) INTO DATA(ld_message) ##NEEDED.
    lo_log->add_item( cl_bali_message_setter=>create_from_sy( ) ).

    DATA(lo_free) = cl_bali_free_text_setter=>create( severity = if_bali_constants=>c_severity_warning
                                                      text     = 'Execution terminated, dataset not found' ).
    lo_log->add_item( lo_free ).

    DATA(lo_exc) = cl_bali_exception_setter=>create( severity  = if_bali_constants=>c_severity_error
                                                     exception = NEW cx_sy_zerodivide( ) ).
    lo_log->add_item( lo_exc ).

    DATA(lo_msg) = cl_bali_message_setter=>create(
                       severity   = if_bali_constants=>c_severity_status
                       id         = 'ZHH_DEMO_LOG'
                       number     = '002'
                       variable_1 = CONV #( cl_abap_context_info=>get_user_business_partner_id( ) ) ).
    lo_log->add_item( lo_msg ).

    DATA(lo_bapi) = cl_bali_message_setter=>create_from_bapiret2( VALUE #( type       = 'E'
                                                                           id         = 'ZHH_DEMO_LOG'
                                                                           number     = '002'
                                                                           message_v1 = 'DUMMY' ) ).
    lo_log->add_item( lo_bapi ).

    cl_bali_log_db=>get_instance( )->save_log( lo_log ).

    rd_result = lo_log->get_handle( ).
  ENDMETHOD.

  METHOD read_log_entries.
    DATA(lo_log_db) = cl_bali_log_db=>get_instance( ).
    DATA(lo_log) = lo_log_db->load_log( id_id ).
    rt_result = lo_log->get_all_items( ).
  ENDMETHOD.
ENDCLASS.
