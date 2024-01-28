\echo "sp_fin_batches.sql loaded"

-- doctor
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('sp_fin_batches.sql - doctor') into v_log_id;
        commit;

        insert into sp_fin_batches (
            fin_batch_id, batchable_id, batchable_type, 
            total_amount, status, company_name, 
            clinic_name, created_at, updated_at,
            invoice_no, invoice_date, gst_tax, 
            gst_code, gst_type, gst_amount,
            bank_account_number, bank_id, reference_id, 
            transaction_type, created_by, updated_by,
            service_provider_type
        ) 
        select fb.id, d.id,'Doctor',
            py.amount, 'SUCCESS', d.company_name,
            d.clinic_name,py.create_date,py.create_date,
            py.invoice_no, py.invoice_date, py.gst_tax,
            py.gst_code, py.gst_type, py.gstamount,
            py.bank_account_no, banks.id, py.reference_id::bigint,
            py.trans_type, creator_users.id, creator_users.id,
            'Doctor'
        from fomema_backup_nios.payment py 
        join doctors d on py.sp_code = d.code
        left join banks on py.bank_code = banks.code
        left join fin_batches fb on cast(py.fin_batch_no as varchar(10)) = fb.code
        left join fomema_backup_nios.v_user_master creators on cast(py.creator_id as bigint) = creators.uuid
        left join users creator_users on creators.userid = creator_users.code
        where py.fin_batch_no is not null and py.sp_type = 'D' and py.service_provider_group_id = '0' 
        and py.fin_batch_no < 20201004;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "sp_fin_batches.sql - doctor done"

-- xray
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('sp_fin_batches.sql - xray') into v_log_id;
        commit;

        insert into sp_fin_batches (
            fin_batch_id, batchable_id, batchable_type, 
            total_amount, status, company_name, 
            created_at, updated_at,
            invoice_no, invoice_date, gst_tax, 
            gst_code, gst_type, gst_amount,
            bank_account_number, bank_id, reference_id, 
            transaction_type, created_by, updated_by,
            service_provider_type
        ) 
        select fb.id, x.id,'XrayFacility',
            py.amount, 'SUCCESS', x.company_name,
            py.create_date,py.create_date,
            py.invoice_no, py.invoice_date, py.gst_tax,
            py.gst_code, py.gst_type, py.gstamount,
            py.bank_account_no, banks.id, py.reference_id::bigint,
            py.trans_type, creator_users.id, creator_users.id,
            'XrayFacility'
        from fomema_backup_nios.payment py 
        join xray_facilities x on py.sp_code = x.code
        left join banks on py.bank_code = banks.code
        left join fin_batches fb on cast(py.fin_batch_no as varchar(10)) = fb.code
        left join fomema_backup_nios.v_user_master creators on cast(py.creator_id as bigint) = creators.uuid
        left join users creator_users on creators.userid = creator_users.code
        where py.fin_batch_no is not null and py.sp_type = 'X' and py.service_provider_group_id = '0' 
        and py.fin_batch_no < 20201004;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "sp_fin_batches.sql - xray done"

-- lab
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('sp_fin_batches.sql - lab') into v_log_id;
        commit;

        insert into sp_fin_batches (
            fin_batch_id, batchable_id, batchable_type, 
            total_amount, status, company_name, 
            created_at, updated_at,
            invoice_no, invoice_date, gst_tax, 
            gst_code, gst_type, gst_amount,
            bank_account_number, bank_id, reference_id, 
            transaction_type, created_by, updated_by,
            service_provider_type
        ) 
        select fb.id, l.id,'Laboratory',
            py.amount, 'SUCCESS', l.company_name,
            py.create_date,py.create_date,
            py.invoice_no, py.invoice_date, py.gst_tax,
            py.gst_code, py.gst_type, py.gstamount,
            py.bank_account_no, banks.id, py.reference_id::bigint,
            py.trans_type, creator_users.id, creator_users.id,
            'Laboratory'
        from fomema_backup_nios.payment py 
        join laboratories l on py.sp_code = l.code
        left join banks on py.bank_code = banks.code
        left join fin_batches fb on cast(py.fin_batch_no as varchar(10)) = fb.code
        left join fomema_backup_nios.v_user_master creators on cast(py.creator_id as bigint) = creators.uuid
        left join users creator_users on creators.userid = creator_users.code
        where py.sp_type = 'L' and py.service_provider_group_id = '0' 
        and py.fin_batch_no < 20201004;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "sp_fin_batches.sql - lab done"

-- group doctor
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('sp_fin_batches.sql - doctor group') into v_log_id;
        commit;

        with nios_group as (
            select g.id, g.group_code, case when g.service_type = 'D' then 'Doctor' when g.service_type = 'X' then 'XrayFacility' when g.service_type = 'L' then 'Laboratory' end service_type, count(g.id) as cnt
            from fomema_backup_nios.service_providers_group g
            join fomema_backup_nios.service_providers_group_member m on g.id = m.service_providers_group_id
            left join banks on g.bank_code = banks.code
            where g.service_type = 'D'
            group by g.id, g.group_code, g.service_type
            having count(g.id) <= 1
        )

        insert into sp_fin_batches (
            fin_batch_id, batchable_id, batchable_type, 
            total_amount, status, company_name, 
            created_at, updated_at,
            invoice_no, invoice_date, gst_tax, 
            gst_code, gst_type, gst_amount,
            bank_account_number, bank_id, reference_id, 
            transaction_type, created_by, updated_by,
            service_provider_type
        ) 
        select fb.id, sp.id, nios_group.service_type,
            py.amount, 'SUCCESS', sp.company_name,
            py.create_date,py.create_date,
            py.invoice_no, py.invoice_date, py.gst_tax,
            py.gst_code, py.gst_type, py.gstamount,
            py.bank_account_no, banks.id, py.reference_id::bigint,
            py.trans_type, creator_users.id, creator_users.id,
            case when py.sp_type = 'D' then 'Doctor' when py.sp_type = 'X' then 'XrayFacility' when py.sp_type = 'L' then 'Laboratory' end
        from fomema_backup_nios.payment py 
        left join banks on py.bank_code = banks.code
        left join fin_batches fb on py.fin_batch_no::varchar = fb.code
        join nios_group on py.service_provider_group_id::bigint = nios_group.id
        left join fomema_backup_nios.service_providers_group_member group_member on nios_group.id = group_member.service_providers_group_id
        left join doctors sp on group_member.service_member = sp.code
        left join fomema_backup_nios.v_user_master creators on cast(py.creator_id as bigint) = creators.uuid
        left join users creator_users on creators.userid = creator_users.code
        where py.fin_batch_no is not null and py.service_provider_group_id is not null and py.service_provider_group_id != '0' 
        and py.fin_batch_no < 20201004 and py.sp_type = 'D';

        with nios_group as (
            select g.id, g.group_code, case when g.service_type = 'D' then 'Doctor' when g.service_type = 'X' then 'XrayFacility' when g.service_type = 'L' then 'Laboratory' end service_type, count(g.id) as cnt
            from fomema_backup_nios.service_providers_group g
            join fomema_backup_nios.service_providers_group_member m on g.id = m.service_providers_group_id
            left join banks on g.bank_code = banks.code
            where g.service_type = 'D'
            group by g.id, g.group_code, g.service_type
        )

        insert into sp_fin_batches (
            fin_batch_id, batchable_id, batchable_type, 
            total_amount, status, company_name, 
            created_at, updated_at,
            invoice_no, invoice_date, gst_tax, 
            gst_code, gst_type, gst_amount,
            bank_account_number, bank_id, reference_id, 
            transaction_type, created_by, updated_by,
            service_provider_type
        ) 
        select fb.id, local_group.id, 'ServiceProviderGroup',
            py.amount, 'SUCCESS', '',
            py.create_date,py.create_date,
            py.invoice_no, py.invoice_date, py.gst_tax,
            py.gst_code, py.gst_type, py.gstamount,
            py.bank_account_no, banks.id, py.reference_id::bigint,
            py.trans_type, creator_users.id, creator_users.id,
            case when py.sp_type = 'D' then 'Doctor' when py.sp_type = 'X' then 'XrayFacility' when py.sp_type = 'L' then 'Laboratory' end
        from fomema_backup_nios.payment py 
        left join banks on py.bank_code = banks.code
        left join fin_batches fb on py.fin_batch_no::varchar = fb.code
        left join nios_group on py.service_provider_group_id::int = nios_group.id
        left join service_provider_groups local_group on nios_group.group_code = local_group.code 
        left join fomema_backup_nios.v_user_master creators on cast(py.creator_id as bigint) = creators.uuid
        left join users creator_users on creators.userid = creator_users.code
        where py.fin_batch_no is not null and py.service_provider_group_id is not null and py.service_provider_group_id != '0' 
        and py.fin_batch_no < 20201004 and py.sp_type = 'D' and (nios_group.cnt > 1 or nios_group.id is null);
        
        perform end_migration_log(v_log_id);
    END
$$;

\echo "sp_fin_batches.sql - doctor group done"

-- group xray
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('sp_fin_batches.sql - xray group') into v_log_id;
        commit;

        with nios_group as (
            select g.id, g.group_code, case when g.service_type = 'D' then 'Doctor' when g.service_type = 'X' then 'XrayFacility' when g.service_type = 'L' then 'Laboratory' end service_type, count(g.id) as cnt
            from fomema_backup_nios.service_providers_group g
            join fomema_backup_nios.service_providers_group_member m on g.id = m.service_providers_group_id
            left join banks on g.bank_code = banks.code
            where g.service_type = 'X'
            group by g.id, g.group_code, g.service_type
            having count(g.id) <= 1
        )

        insert into sp_fin_batches (
            fin_batch_id, batchable_id, batchable_type, 
            total_amount, status, company_name, 
            created_at, updated_at,
            invoice_no, invoice_date, gst_tax, 
            gst_code, gst_type, gst_amount,
            bank_account_number, bank_id, reference_id, 
            transaction_type, created_by, updated_by,
            service_provider_type
        ) 
        select fb.id, sp.id, nios_group.service_type,
            py.amount, 'SUCCESS', sp.company_name,
            py.create_date,py.create_date,
            py.invoice_no, py.invoice_date, py.gst_tax,
            py.gst_code, py.gst_type, py.gstamount,
            py.bank_account_no, banks.id, py.reference_id::bigint,
            py.trans_type, creator_users.id, creator_users.id,
            case when py.sp_type = 'D' then 'Doctor' when py.sp_type = 'X' then 'XrayFacility' when py.sp_type = 'L' then 'Laboratory' end
        from fomema_backup_nios.payment py 
        left join banks on py.bank_code = banks.code
        left join fin_batches fb on py.fin_batch_no::varchar = fb.code
        join nios_group on py.service_provider_group_id::bigint = nios_group.id
        left join fomema_backup_nios.service_providers_group_member group_member on nios_group.id = group_member.service_providers_group_id
        left join xray_facilities sp on group_member.service_member = sp.code
        left join fomema_backup_nios.v_user_master creators on cast(py.creator_id as bigint) = creators.uuid
        left join users creator_users on creators.userid = creator_users.code
        where py.fin_batch_no is not null and py.service_provider_group_id is not null and py.service_provider_group_id != '0' 
        and py.fin_batch_no < 20201004 and py.sp_type = 'X';

        with nios_group as (
            select g.id, g.group_code, case when g.service_type = 'D' then 'Doctor' when g.service_type = 'X' then 'XrayFacility' when g.service_type = 'L' then 'Laboratory' end service_type, count(g.id) as cnt
            from fomema_backup_nios.service_providers_group g
            join fomema_backup_nios.service_providers_group_member m on g.id = m.service_providers_group_id
            left join banks on g.bank_code = banks.code
            where g.service_type = 'X'
            group by g.id, g.group_code, g.service_type
        )

        insert into sp_fin_batches (
            fin_batch_id, batchable_id, batchable_type, 
            total_amount, status, company_name, 
            created_at, updated_at,
            invoice_no, invoice_date, gst_tax, 
            gst_code, gst_type, gst_amount,
            bank_account_number, bank_id, reference_id, 
            transaction_type, created_by, updated_by,
            service_provider_type
        ) 
        select fb.id, local_group.id, 'ServiceProviderGroup',
            py.amount, 'SUCCESS', '',
            py.create_date,py.create_date,
            py.invoice_no, py.invoice_date, py.gst_tax,
            py.gst_code, py.gst_type, py.gstamount,
            py.bank_account_no, banks.id, py.reference_id::bigint,
            py.trans_type, creator_users.id, creator_users.id,
            case when py.sp_type = 'D' then 'Doctor' when py.sp_type = 'X' then 'XrayFacility' when py.sp_type = 'L' then 'Laboratory' end
        from fomema_backup_nios.payment py 
        left join banks on py.bank_code = banks.code
        left join fin_batches fb on py.fin_batch_no::varchar = fb.code
        left join nios_group on py.service_provider_group_id::int = nios_group.id
        left join service_provider_groups local_group on nios_group.group_code = local_group.code 
        left join fomema_backup_nios.v_user_master creators on cast(py.creator_id as bigint) = creators.uuid
        left join users creator_users on creators.userid = creator_users.code
        where py.fin_batch_no is not null and py.service_provider_group_id is not null and py.service_provider_group_id != '0' 
        and py.fin_batch_no < 20201004 and py.sp_type = 'X' and (nios_group.cnt > 1 or nios_group.id is null);
        
        perform end_migration_log(v_log_id);
    END
$$;

\echo "sp_fin_batches.sql - xray group done"

-- group lab
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('sp_fin_batches.sql - lab group') into v_log_id;
        commit;

        with nios_group as (
            select g.id, g.group_code, case when g.service_type = 'D' then 'Doctor' when g.service_type = 'X' then 'XrayFacility' when g.service_type = 'L' then 'Laboratory' end service_type, count(g.id) as cnt
            from fomema_backup_nios.service_providers_group g
            join fomema_backup_nios.service_providers_group_member m on g.id = m.service_providers_group_id
            left join banks on g.bank_code = banks.code
            where g.service_type = 'L'
            group by g.id, g.group_code, g.service_type
            having count(g.id) <= 1
        )

        insert into sp_fin_batches (
            fin_batch_id, batchable_id, batchable_type, 
            total_amount, status, company_name, 
            created_at, updated_at,
            invoice_no, invoice_date, gst_tax, 
            gst_code, gst_type, gst_amount,
            bank_account_number, bank_id, reference_id, 
            transaction_type, created_by, updated_by,
            service_provider_type
        ) 
        select fb.id, sp.id, nios_group.service_type,
            py.amount, 'SUCCESS', sp.company_name,
            py.create_date,py.create_date,
            py.invoice_no, py.invoice_date, py.gst_tax,
            py.gst_code, py.gst_type, py.gstamount,
            py.bank_account_no, banks.id, py.reference_id::bigint,
            py.trans_type, creator_users.id, creator_users.id,
            case when py.sp_type = 'D' then 'Doctor' when py.sp_type = 'X' then 'XrayFacility' when py.sp_type = 'L' then 'Laboratory' end
        from fomema_backup_nios.payment py 
        left join banks on py.bank_code = banks.code
        left join fin_batches fb on py.fin_batch_no::varchar = fb.code
        join nios_group on py.service_provider_group_id::bigint = nios_group.id
        left join fomema_backup_nios.service_providers_group_member group_member on nios_group.id = group_member.service_providers_group_id
        left join laboratories sp on group_member.service_member = sp.code
        left join fomema_backup_nios.v_user_master creators on cast(py.creator_id as bigint) = creators.uuid
        left join users creator_users on creators.userid = creator_users.code
        where py.fin_batch_no is not null and py.service_provider_group_id is not null and py.service_provider_group_id != '0' 
        and py.fin_batch_no < 20201004 and py.sp_type = 'L';

        with nios_group as (
            select g.id, g.group_code, case when g.service_type = 'D' then 'Doctor' when g.service_type = 'X' then 'XrayFacility' when g.service_type = 'L' then 'Laboratory' end service_type, count(g.id) as cnt
            from fomema_backup_nios.service_providers_group g
            join fomema_backup_nios.service_providers_group_member m on g.id = m.service_providers_group_id
            left join banks on g.bank_code = banks.code
            where g.service_type = 'L'
            group by g.id, g.group_code, g.service_type
        )

        insert into sp_fin_batches (
            fin_batch_id, batchable_id, batchable_type, 
            total_amount, status, company_name, 
            created_at, updated_at,
            invoice_no, invoice_date, gst_tax, 
            gst_code, gst_type, gst_amount,
            bank_account_number, bank_id, reference_id, 
            transaction_type, created_by, updated_by,
            service_provider_type
        ) 
        select fb.id, local_group.id, 'ServiceProviderGroup',
            py.amount, 'SUCCESS', '',
            py.create_date,py.create_date,
            py.invoice_no, py.invoice_date, py.gst_tax,
            py.gst_code, py.gst_type, py.gstamount,
            py.bank_account_no, banks.id, py.reference_id::bigint,
            py.trans_type, creator_users.id, creator_users.id,
            case when py.sp_type = 'D' then 'Doctor' when py.sp_type = 'X' then 'XrayFacility' when py.sp_type = 'L' then 'Laboratory' end
        from fomema_backup_nios.payment py 
        left join banks on py.bank_code = banks.code
        left join fin_batches fb on py.fin_batch_no::varchar = fb.code
        left join nios_group on py.service_provider_group_id::int = nios_group.id
        left join service_provider_groups local_group on nios_group.group_code = local_group.code 
        left join fomema_backup_nios.v_user_master creators on cast(py.creator_id as bigint) = creators.uuid
        left join users creator_users on creators.userid = creator_users.code
        where py.fin_batch_no is not null and py.service_provider_group_id is not null and py.service_provider_group_id != '0' 
        and py.fin_batch_no < 20201004 and py.sp_type = 'L' and (nios_group.cnt > 1 or nios_group.id is null);
        
        perform end_migration_log(v_log_id);
    END
$$;

\echo "sp_fin_batches.sql - lab group done"

\echo "sp_fin_batches.sql ended"