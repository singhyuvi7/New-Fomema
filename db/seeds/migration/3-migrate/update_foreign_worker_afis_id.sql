\echo "update_foreign_worker_afis_id.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('update_foreign_worker_afis_id.sql') into v_log_id;
        commit;

        UPDATE foreign_workers set afis_id = bt.afis_id from biodata_transactions bt where foreign_workers.latest_transaction_id = bt.transaction_id;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "update_foreign_worker_afis_id.sql ended"