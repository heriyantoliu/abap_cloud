CLASS zcl_hh_demo_runtime DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor.

    METHODS get_diff
      RETURNING VALUE(rd_result) TYPE timestampl.

  PRIVATE SECTION.
    DATA md_started TYPE timestampl.

    METHODS get_timestampl
      RETURNING VALUE(rd_result) TYPE timestampl.
ENDCLASS.


CLASS zcl_hh_demo_runtime IMPLEMENTATION.
  METHOD constructor.
    md_started = get_timestampl( ).
  ENDMETHOD.

  METHOD get_diff.
    rd_result = get_timestampl( ) - md_started.
  ENDMETHOD.

  METHOD get_timestampl.
    GET TIME STAMP FIELD rd_result.
  ENDMETHOD.
ENDCLASS.
