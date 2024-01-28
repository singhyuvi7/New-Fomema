/*
    tcupi_letter_refid  tcupi_xrayletter_refid
*/

\echo "tcupi_letters.sql loaded"

\echo "tcupi_letters.sql - For Xray loaded"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('tcupi_letters.sql - For Audit') into v_log_id;
        commit;

        insert into tcupi_letters (
            transaction_id,
            letter_type,
            letter_id,
            created_at,
            updated_at
        )
        select
            local_trans.id,
            'audit',
            qfd.tcupi_xrayletter_refid,
            coalesce(qfd.time_inserted, clock_timestamp()),
            coalesce(qfd.time_inserted, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfd
            join transactions local_trans on qfd.trans_id = local_trans.code
        where
            qfd.tcupi_xrayletter_refid is not null
        order by
            qfd.time_inserted;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "tcupi_letters.sql - For Xray ended"

\echo "tcupi_letters.sql - For Non-audit - loaded"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('tcupi_letters.sql - For Non-audit') into v_log_id;
        commit;

        insert into tcupi_letters (
            transaction_id,
            letter_type,
            letter_id,
            created_at,
            updated_at
        )
        select
            local_trans.id,
            'nonaudit',
            qfd.tcupi_letter_refid,
            coalesce(qfd.time_inserted, clock_timestamp()),
            coalesce(qfd.time_inserted, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfd
            join transactions local_trans on qfd.trans_id = local_trans.code
        where
            qfd.tcupi_letter_refid is not null
        order by
            qfd.time_inserted;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "tcupi_letters.sql - For Non-audit - ended"

\echo "tcupi_letters.sql ended"