\echo "update_transactions_is_imm_insert.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('update_transactions_is_imm_insert.sql - fw_trans') into v_log_id;
        commit;

        update transactions set is_imm_insert = 'TRUE'
        from fomema_backup_nios.fw_transaction fw_t where transactions.code = fw_t.trans_id
        and fw_t.imm_send_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "update_transactions_is_imm_insert.sql fw_trans done"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('update_transactions_is_imm_insert.sql - new trans') into v_log_id;
        commit;

        update transactions set is_imm_insert = 'TRUE'
        from myimms_requests mr, myimms_responses mres
        where transactions.code = mr.txn_id 
        and mr.id = mres.myimms_request_id
        and mr.sts_ind = 'I' and mres.status = '1';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "update_transactions_is_imm_insert.sql ended"