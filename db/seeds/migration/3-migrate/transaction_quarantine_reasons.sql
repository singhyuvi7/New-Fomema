\echo "transaction_quarantine_reasons.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('transaction_quarantine_reasons.sql') into v_log_id;
        commit;

        with id_code_map as (
            select id, code from quarantine_reasons
            union select qr.id, '5041' from quarantine_reasons qr where code = '5060'
            union select qr.id, '5042' from quarantine_reasons qr where code = '5070'
            union select qr.id, '7240' from quarantine_reasons qr where code = '6100'
        )

        insert into transaction_quarantine_reasons (
            transaction_id, quarantine_reason_id, created_at, updated_at
        )
        select
            local_trans.id, qr.id, coalesce(qfwr.creation_date, clock_timestamp()), coalesce(qfwr.creation_date, clock_timestamp())
        from
            transactions local_trans join fomema_backup_nios.quarantine_fw_reason qfwr on local_trans.code = qfwr.trans_id
            join id_code_map qr on qfwr.reason_code = qr.code;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "transaction_quarantine_reasons.sql ended"