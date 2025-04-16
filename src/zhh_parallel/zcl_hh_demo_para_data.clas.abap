CLASS zcl_hh_demo_para_data DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES td_packed  TYPE p LENGTH 15 DECIMALS 3.
    TYPES ts_partner TYPE zhh_partner.
    TYPES tt_partner TYPE TABLE OF ts_partner WITH EMPTY KEY.
    TYPES: BEGIN OF ts_result,
             partner      TYPE zhh_partner-partner,
             name         TYPE zhh_partner-name,
             headers      TYPE i,
             positions    TYPE i,
             pos_per_head TYPE td_packed,
             start_time   TYPE utclong,
             end_time     TYPE utclong,
           END OF ts_result,
           tt_result TYPE TABLE OF ts_result WITH EMPTY KEY.

    METHODS get_partners
      RETURNING VALUE(rt_result) TYPE tt_partner.

    METHODS get_result_from_partner
      IMPORTING is_partner       TYPE ts_partner
      RETURNING VALUE(rs_result) TYPE ts_result.

  PRIVATE SECTION.
    METHODS get_number_of_headers
      IMPORTING is_partner       TYPE ts_partner
      RETURNING VALUE(rd_result) TYPE i.

    METHODS get_number_of_positions
      IMPORTING is_partner       TYPE ts_partner
      RETURNING VALUE(rd_result) TYPE i.

    METHODS get_positions_per_head
      IMPORTING is_partner       TYPE ts_partner
      RETURNING VALUE(rd_result) TYPE zcl_hh_demo_para_data=>td_packed.
ENDCLASS.


CLASS zcl_hh_demo_para_data IMPLEMENTATION.
  METHOD get_number_of_headers.
    SELECT FROM zhh_invoice
      FIELDS *
      WHERE partner = @is_partner-partner
      INTO TABLE @DATA(lt_head).

    " TODO: variable is assigned but never used (ABAP cleaner)
    LOOP AT lt_head INTO DATA(ls_head).
      rd_result += 1.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_number_of_positions.
    SELECT FROM zhh_invoice
      FIELDS *
      WHERE partner = @is_partner-partner
      INTO TABLE @DATA(lt_head).

    LOOP AT lt_head INTO DATA(ls_head).
      SELECT FROM zhh_position
        FIELDS *
        WHERE document = @ls_head-document
        INTO TABLE @DATA(lt_position).

      " TODO: variable is assigned but never used (ABAP cleaner)
      LOOP AT lt_position INTO DATA(ls_position).
        rd_result += 1.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_partners.
    SELECT FROM zhh_partner
      FIELDS *
      WHERE partner BETWEEN '1000000000' AND '1000000006'
      INTO TABLE @rt_result.
  ENDMETHOD.

  METHOD get_positions_per_head.
    DATA lt_count TYPE TABLE OF i WITH EMPTY KEY.

    SELECT FROM zhh_invoice
      FIELDS *
      WHERE partner = @is_partner-partner
      INTO TABLE @DATA(lt_head).

    LOOP AT lt_head INTO DATA(ls_head).
      SELECT FROM zhh_position
        FIELDS *
        WHERE document = @ls_head-document
        INTO TABLE @DATA(lt_position).

      DATA(ld_count) = lines( lt_position ).
      INSERT ld_count INTO TABLE lt_count.
    ENDLOOP.

    DATA(ld_sum) = 0.
    LOOP AT lt_count INTO ld_count.
      ld_sum += ld_count.
    ENDLOOP.

    rd_result = ld_sum / lines( lt_count ).
  ENDMETHOD.

  METHOD get_result_from_partner.
    DATA ls_result TYPE ts_result.

    ls_result-start_time   = utclong_current( ).
    ls_result-partner      = is_partner-partner.
    ls_result-name         = is_partner-name.
    ls_result-headers      = get_number_of_headers( is_partner ).
    ls_result-positions    = get_number_of_positions( is_partner ).
    ls_result-pos_per_head = get_positions_per_head( is_partner ).
    ls_result-end_time     = utclong_current( ).

    RETURN ls_result.
  ENDMETHOD.
ENDCLASS.
