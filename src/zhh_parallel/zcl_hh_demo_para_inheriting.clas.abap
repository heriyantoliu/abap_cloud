CLASS zcl_hh_demo_para_inheriting DEFINITION
  PUBLIC
  INHERITING FROM cl_abap_parallel FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS do REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_hh_demo_para_inheriting IMPLEMENTATION.
  METHOD do.
    data: ls_partner type zcl_hh_demo_para_data=>ts_partner,
          lt_result type zcl_hh_demo_para_data=>tt_result.

    call TRANSFORMATION id source xml p_in
      result in = ls_partner.

    wait up to 1 seconds.

    insert new zcl_hh_demo_para_data( )->get_result_from_partner( ls_partner ) into table lt_result.

    call transformation id source out = lt_result
      result xml p_out.
  ENDMETHOD.
ENDCLASS.
