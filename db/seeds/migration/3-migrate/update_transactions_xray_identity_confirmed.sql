\echo "update_transactions_xray_identity_confirmed.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('update_transactions_xray_identity_confirmed.sql') into v_log_id;
        commit;

        update transactions set xray_worker_identity_confirmed = 'TRUE'
        from fomema_backup_nios.fw_transaction fw_t where transactions.code = fw_t.trans_id
        and fw_t.xrayfp_date is not null and xray_worker_identity_confirmed = 'FALSE';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "update_transactions_xray_identity_confirmed.sql ended"