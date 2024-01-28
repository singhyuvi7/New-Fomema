\echo "insurance_purchases.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('insurance_purchases.sql') into v_log_id;
        commit;

        insert into insurance_purchases (
            start_date, end_date, product_purchased,
            batch_id, reg_id, employer_id, worker_name, insurance_provider,
            created_at, updated_at
        ) 
        select ip.start_date, ip.end_date, ip.product_name,
            ip.batchid, ip.worker_regid, emp.id, ip.worker_name, ip.ins_svcprovider,
            ip.creation_date, ip.creation_date
        from fomema_backup_portal.insurance_purchase ip 
        left join employers emp on ip.employer_code = emp.code;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "insurance_purchases.sql ended"
