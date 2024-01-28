
\echo 'service_provider_group.sql loaded';

DO $$
    DECLARE
        v_log_id bigint;
        v_country_id bigint;
        v_roc_id bigint;
    BEGIN
        select start_migration_log('service_provider_group.sql') into v_log_id;
        commit;

        select id into v_roc_id from payment_methods where code = 'OUT_GIROROC';

        SELECT id into v_country_id from countries where code = 'MYS';

        with temp_tbl as (
            select g.id, g.group_name, g.service_type
            from fomema_backup_nios.service_providers_group g
            join fomema_backup_nios.service_providers_group_member m
            on g.id = m.service_providers_group_id
            group by g.group_name, g.id, g.service_type
            having count(g.id) > 1
        )

        insert into service_provider_groups (
            category,code,name,address1,address2,address3,address4,country_id,
            state_id,town_id,postcode,phone,fax,email,male_rate,female_rate,bank_id,
            bank_account_holder_name,bank_account_number,status,
            created_at,updated_at,created_by,updated_by,bank_payment_id,business_registration_number,email_payment,
            payment_method_id
        ) 
        select 'Doctor', lg.group_code, lg.group_name, lg.address1, lg.address2, lg.address3, lg.address4, v_country_id,
        states.id, towns.id, lg.postcode, lg.phone, lg.fax, lg.email_address, lg.male_rate, lg.female_rate, banks.id, lg.bank_account_holder_name, lg.bank_account_no, case when lg.isactive = 'Y' then 'ACTIVE' else 'INACTIVE' end, 
        coalesce(lg.creation_date, lg.modification_date, clock_timestamp()) as created_at, 
        coalesce(lg.modification_date, clock_timestamp()) as updated_at, creator_users.id,updator_users.id, lg.roc, lg.roc, 
        lg.email_address,
        v_roc_id
        from fomema_backup_nios.service_providers_group lg 
        join temp_tbl on lg.id = temp_tbl.id
        left join fomema_backup_nios.v_user_master creators on lg.creator_id = creators.uuid 
        left join users creator_users on creators.userid = creator_users.code
        left join fomema_backup_nios.v_user_master updators on lg.modify_id = updators.uuid 
        left join users updator_users on updators.userid = updator_users.code
        left join states on lg.state_code = states.code
        left join towns on lg.district_code = towns.code
        left join banks on lg.bank_code = banks.code
        where lg.service_type = 'D'
        order by lg.creation_date;

        with temp_tbl as (
            select g.id, g.group_name, g.service_type
            from fomema_backup_nios.service_providers_group g
            join fomema_backup_nios.service_providers_group_member m
            on g.id = m.service_providers_group_id
            group by g.group_name, g.id, g.service_type
            having count(g.id) > 1
        )

        insert into service_provider_groups (
            category,code,name,address1,address2,address3,address4,country_id,
            state_id,town_id,postcode,phone,fax,email,male_rate,female_rate,bank_id,
            bank_account_holder_name,bank_account_number,status,
            created_at,updated_at,created_by,updated_by,bank_payment_id,business_registration_number,email_payment,
            payment_method_id
        ) 
        select 'XrayFacility', lg.group_code, lg.group_name, lg.address1, lg.address2, lg.address3, lg.address4, v_country_id,
        states.id, towns.id, lg.postcode, lg.phone, lg.fax, lg.email_address, 22.50, 22.50, banks.id, lg.bank_account_holder_name, lg.bank_account_no, case when lg.isactive = 'Y' then 'ACTIVE' else 'INACTIVE' end, 
        coalesce(lg.creation_date, lg.modification_date, clock_timestamp()) as created_at, 
        coalesce(lg.modification_date, clock_timestamp()) as updated_at, creator_users.id,updator_users.id, lg.roc, lg.roc, 
        lg.email_address,
        v_roc_id
        from fomema_backup_nios.service_providers_group lg 
        join temp_tbl on lg.id = temp_tbl.id
        left join fomema_backup_nios.v_user_master creators on lg.creator_id = creators.uuid 
        left join users creator_users on creators.userid = creator_users.code
        left join fomema_backup_nios.v_user_master updators on lg.modify_id = updators.uuid 
        left join users updator_users on updators.userid = updator_users.code
        left join states on lg.state_code = states.code
        left join towns on lg.district_code = towns.code
        left join banks on lg.bank_code = banks.code
        where lg.service_type = 'X'
        order by lg.creation_date;

        with temp_tbl as (
            select g.id, g.group_name, g.service_type
            from fomema_backup_nios.service_providers_group g
            join fomema_backup_nios.service_providers_group_member m
            on g.id = m.service_providers_group_id
            group by g.group_name, g.id, g.service_type
            having count(g.id) > 1
        )

        insert into service_provider_groups (
            category,code,name,address1,address2,address3,address4,country_id,
            state_id,town_id,postcode,phone,fax,email,male_rate,female_rate,bank_id,
            bank_account_holder_name,bank_account_number,status,
            created_at,updated_at,created_by,updated_by,bank_payment_id,business_registration_number,email_payment,
            payment_method_id
        ) 
        select 'Laboratory', lg.group_code, lg.group_name, lg.address1, lg.address2, lg.address3, lg.address4, v_country_id,
        states.id, towns.id, lg.postcode, lg.phone, lg.fax, lg.email_address, lg.male_rate, lg.female_rate, banks.id, lg.bank_account_holder_name, lg.bank_account_no, case when lg.isactive = 'Y' then 'ACTIVE' else 'INACTIVE' end, 
        coalesce(lg.creation_date, lg.modification_date, clock_timestamp()) as created_at, 
        coalesce(lg.modification_date, clock_timestamp()) as updated_at, creator_users.id,updator_users.id, lg.roc, lg.roc, 
        lg.email_address,
        v_roc_id
        from fomema_backup_nios.service_providers_group lg 
        join temp_tbl on lg.id = temp_tbl.id
        left join fomema_backup_nios.v_user_master creators on lg.creator_id = creators.uuid 
        left join users creator_users on creators.userid = creator_users.code
        left join fomema_backup_nios.v_user_master updators on lg.modify_id = updators.uuid 
        left join users updator_users on updators.userid = updator_users.code
        left join states on lg.state_code = states.code
        left join towns on lg.district_code = towns.code
        left join banks on lg.bank_code = banks.code
        where lg.service_type = 'L'
        order by lg.creation_date;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "service_provider_group.sql ended"