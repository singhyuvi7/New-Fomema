\echo "transaction_unsuitable_reasons.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('transaction_unsuitable_reasons.sql') into v_log_id;
        commit;

        with union_unsuitable_reasons as (
            select trans_id, unsuitable_id
            from fomema_backup_nios.fw_unsuitable_reasons
            group by trans_id, unsuitable_id

            union

            select fd.trans_id, urm.unsuitable_id
            from fomema_backup_nios.unsuitable_reasons_map urm
            join fomema_backup_nios.fw_detail fd on fd.parameter_code = urm.parameter_code
            group by trans_id, unsuitable_id
        )

        insert into transaction_unsuitable_reasons (
            transaction_id, unsuitable_reason_id,
            created_at, updated_at
        )
        select
            lt.id, usr.unsuitable_id,
            clock_timestamp(), clock_timestamp()
        from
            transactions lt
            join union_unsuitable_reasons usr on lt.code = usr.trans_id;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "transaction_unsuitable_reasons.sql ended"