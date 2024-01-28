\echo "sp_fin_batch_items.sql loaded"

-- group : doctor
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('sp_fin_batch_items.sql - group doctor') into v_log_id;
        commit;

        insert into sp_fin_batch_items (
            sp_fin_batch_id,transaction_id, amount,
            itemable_id, itemable_type, company_name,
            clinic_name, created_at, updated_at, 
            reference_id
        ) 
        select fb.id, tr.id, sr.amount, 
            sp.id, 'Doctor', sp.company_name,
            sp.clinic_name, sr.creation_date, sr.creation_date,
            sr.batchid
        from fomema_backup_nios.sppayment_reference sr
        join sp_fin_batches fb on sr.batchid = fb.reference_id
        join transactions tr on sr.transid = tr.code
        join doctors sp on sr.service_provider_code = sp.code
        where fb.batchable_type = 'ServiceProviderGroup' and fb.service_provider_type = 'Doctor' 
        and sr.creation_date < '2020-10-19';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "sp_fin_batch_items.sql - doc group done"

-- group : xray
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('sp_fin_batch_items.sql - group xray') into v_log_id;
        commit;

        insert into sp_fin_batch_items (
            sp_fin_batch_id,transaction_id, amount,
            itemable_id, itemable_type, company_name,
            clinic_name, created_at, updated_at, 
            reference_id
        ) 
        select fb.id, tr.id, sr.amount, 
            sp.id, 'XrayFacility', sp.company_name,
            sp.name, sr.creation_date, sr.creation_date,
            sr.batchid
        from fomema_backup_nios.sppayment_reference sr
        join sp_fin_batches fb on sr.batchid = fb.reference_id
        join transactions tr on sr.transid = tr.code
        join xray_facilities sp on sr.service_provider_code = sp.code
        where fb.batchable_type = 'ServiceProviderGroup' and fb.service_provider_type = 'XrayFacility' 
        and sr.creation_date < '2020-10-19';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "sp_fin_batch_items.sql - xray group done"

-- doctor
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('sp_fin_batch_items.sql - doctor') into v_log_id;
        commit;

        insert into sp_fin_batch_items (
            sp_fin_batch_id,transaction_id, amount,
            itemable_id, itemable_type, company_name,
            clinic_name, created_at, updated_at, 
            reference_id
        ) 
        select fb.id, tr.id, sr.amount, 
            sp.id, 'Doctor', sp.company_name,
            sp.clinic_name, sr.creation_date, sr.creation_date,
            sr.batchid
        from fomema_backup_nios.sppayment_reference sr
        join sp_fin_batches fb on sr.batchid = fb.reference_id
        join transactions tr on sr.transid = tr.code
        join doctors sp on sr.service_provider_code = sp.code
        where fb.batchable_type = 'Doctor' 
        and sr.creation_date < '2020-10-19';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "sp_fin_batch_items.sql - doc done"

-- xray
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('sp_fin_batch_items.sql - xray') into v_log_id;
        commit;

        insert into sp_fin_batch_items (
            sp_fin_batch_id,transaction_id, amount,
            itemable_id, itemable_type, company_name,
            clinic_name, created_at, updated_at, 
            reference_id
        ) 
        select fb.id, tr.id, sr.amount, 
            sp.id, 'XrayFacility', sp.company_name,
            sp.name, sr.creation_date, sr.creation_date,
            sr.batchid
        from fomema_backup_nios.sppayment_reference sr
        join sp_fin_batches fb on sr.batchid = fb.reference_id
        join transactions tr on sr.transid = tr.code
        join xray_facilities sp on sr.service_provider_code = sp.code
        where fb.batchable_type = 'XrayFacility' 
        and sr.creation_date < '2020-10-19';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "sp_fin_batch_items.sql - xray done"

\echo "sp_fin_batch_items.sql ended"
