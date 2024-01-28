\echo 'xqcc_quarantine_reason.sql loaded'

do $$
declare
    v_main_id bigint;
begin
    select start_migration_log('xqcc_quarantine_reason.sql') into v_main_id; commit;

    with id_code_map as (
        select id, code from quarantine_reasons
        union select qr.id, '5041' from quarantine_reasons qr where code = '5060' -- 5041 was merged with 5060
        union select qr.id, '5042' from quarantine_reasons qr where code = '5070' -- 5042 was merged with 5070
    )

    insert into xqcc_quarantine_reasons (
        transaction_id,
        quarantine_reason_id,
        created_at,
        updated_at
    )
    select
        t.id as transaction_id,
        qr.id as quarantine_reason_id,
        coalesce(xqfr.creation_date, clock_timestamp()) as created_at,
        coalesce(xqfr.creation_date, clock_timestamp()) as updated_at
    from fomema_backup_nios.xqcc_quarantine_fw_reason xqfr join transactions t on xqfr.trans_id = t.code
    join id_code_map qr on xqfr.reason_code = qr.code
    order by xqfr.creation_date
    ;
    perform end_migration_log(v_main_id);
end
$$;

\echo 'xqcc_quarantine_reason.sql ended'
