\echo "transaction_details.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('transaction_details.sql') into v_log_id;
    commit;

    insert into transaction_details (
        transaction_id, doc_code, 
        doc_name,doc_company_name,doc_clinic_name,
        doc_address1,doc_address2,doc_address3,doc_address4,
        doc_country_id,doc_state_id,doc_town_id,doc_postcode,
        doc_service_provider_group_id,doc_male_rate,doc_female_rate,
        doc_payment_method_id,
        doc_sp_group_code, doc_sp_group_name, 
        doc_sp_group_male_rate, doc_sp_group_female_rate,
        doc_sp_group_payment_method_id,

        xray_code, 
        xray_name,xray_company_name,xray_license_holder_name,
        xray_address1,xray_address2,xray_address3,xray_address4,
        xray_country_id,xray_state_id,xray_town_id,xray_postcode,
        xray_service_provider_group_id,xray_male_rate,xray_female_rate,
        xray_payment_method_id,
        xray_sp_group_code, xray_sp_group_name, 
        xray_sp_group_male_rate, xray_sp_group_female_rate,
        xray_sp_group_payment_method_id,

        lab_code, 
        lab_name,lab_company_name,lab_pic_name,
        lab_pathologist_name,
        lab_address1,lab_address2,lab_address3,lab_address4,
        lab_country_id,lab_state_id,lab_town_id,lab_postcode,
        lab_service_provider_group_id,lab_male_rate,lab_female_rate,
        lab_payment_method_id,
        lab_sp_group_code, lab_sp_group_name, 
        lab_sp_group_male_rate, lab_sp_group_female_rate,
        lab_sp_group_payment_method_id,

        created_at, updated_at
    )
    select local_trans.id , doc_code, 
        doc_name,doc_company_name,doc_clinic_name,
        doc_address1,doc_address2,doc_address3,doc_address4,
        doc_country_id,doc_state_id,doc_town_id,doc_postcode,
        doc_service_provider_group_id,doc_male_rate,doc_female_rate,
        doc_payment_method_id,
        doc_sp_group_code, doc_sp_group_name, 
        doc_sp_group_male_rate, doc_sp_group_female_rate,
        doc_sp_group_payment_method_id,

        xray_code, 
        xray_name,xray_company_name,xray_license_holder_name,
        xray_address1,xray_address2,xray_address3,xray_address4,
        xray_country_id,xray_state_id,xray_town_id,xray_postcode,
        xray_service_provider_group_id,xray_male_rate,xray_female_rate,
        xray_payment_method_id,
        xray_sp_group_code, xray_sp_group_name, 
        xray_sp_group_male_rate, xray_sp_group_female_rate,
        xray_sp_group_payment_method_id,

        lab_code, 
        lab_name,lab_company_name,lab_pic_name,
        lab_pathologist_name,
        lab_address1,lab_address2,lab_address3,lab_address4,
        lab_country_id,lab_state_id,lab_town_id,lab_postcode,
        lab_service_provider_group_id,lab_male_rate,lab_female_rate,
        lab_payment_method_id,
        lab_sp_group_code, lab_sp_group_name, 
        lab_sp_group_male_rate, lab_sp_group_female_rate,
        lab_sp_group_payment_method_id,

        temp_fom.created_at, temp_fom.updated_at
    from (
        (
            select trans_id as doc_trans_id, fpt.created_date as created_at, fpt.created_date as updated_at , sp_code as doc_code, sp.id as doc_id,  
            sp.name doc_name,sp.company_name doc_company_name,sp.clinic_name doc_clinic_name,
            sp.address1 doc_address1,sp.address2 doc_address2,sp.address3 doc_address3,sp.address4 doc_address4,
            sp.country_id doc_country_id,sp.state_id doc_state_id,sp.town_id doc_town_id,sp.postcode doc_postcode,
            local_sp_group.id doc_service_provider_group_id,
            case when fpt.sex = 'M' then amount else 0 end doc_male_rate,
            case when fpt.sex = 'F' then amount else 0 end doc_female_rate,
            sp.payment_method_id doc_payment_method_id,
            local_sp_group.code doc_sp_group_code,local_sp_group.name doc_sp_group_name,
            case when fpt.sex = 'M' then amount else 0 end doc_sp_group_male_rate, 
            case when fpt.sex = 'F' then amount else 0 end doc_sp_group_female_rate,
            local_sp_group.payment_method_id doc_sp_group_payment_method_id
            from fomema_backup_nios.fom_pay_transaction fpt 
            join doctors sp on sp_code = sp.code
            left join fomema_backup_nios.service_providers_group sp_group on fpt.sp_group_id = sp_group.id
            left join service_provider_groups local_sp_group on sp_group.group_code = local_sp_group.code
            where sp_type = 'D'
        ) as doc_join 
    inner join 
        ( 
            select trans_id as xray_trans_id, sp_code as xray_code,  
            sp.name xray_name,sp.company_name xray_company_name,sp.license_holder_name xray_license_holder_name,
            sp.address1 xray_address1,sp.address2 xray_address2,sp.address3 xray_address3,sp.address4 xray_address4,
            sp.country_id xray_country_id,sp.state_id xray_state_id,sp.town_id xray_town_id,sp.postcode xray_postcode,
            local_sp_group.id xray_service_provider_group_id,
            case when fpt.sex = 'M' then amount else 0 end xray_male_rate,
            case when fpt.sex = 'F' then amount else 0 end xray_female_rate,
            sp.payment_method_id xray_payment_method_id,
            local_sp_group.code xray_sp_group_code,local_sp_group.name xray_sp_group_name,
            case when fpt.sex = 'M' then amount else 0 end xray_sp_group_male_rate, 
            case when fpt.sex = 'F' then amount else 0 end xray_sp_group_female_rate,
            local_sp_group.payment_method_id xray_sp_group_payment_method_id
            from fomema_backup_nios.fom_pay_transaction fpt
            join xray_facilities sp on sp_code = sp.code
            left join fomema_backup_nios.service_providers_group sp_group on fpt.sp_group_id = sp_group.id
            left join service_provider_groups local_sp_group on sp_group.group_code = local_sp_group.code
            where sp_type = 'X'
        ) as xray_join 
    on doc_join.doc_trans_id = xray_join.xray_trans_id
    inner join 
        (
            select trans_id as lab_trans_id, sp_code as lab_code,
            sp.name lab_name,sp.company_name lab_company_name,sp.pic_name lab_pic_name,
            sp.pathologist_name lab_pathologist_name,
            sp.address1 lab_address1,sp.address2 lab_address2,sp.address3 lab_address3,sp.address4 lab_address4,
            sp.country_id lab_country_id,sp.state_id lab_state_id,sp.town_id lab_town_id,sp.postcode lab_postcode,
            local_sp_group.id lab_service_provider_group_id,
            case when fpt.sex = 'M' then amount else 0 end lab_male_rate,
            case when fpt.sex = 'F' then amount else 0 end lab_female_rate,
            sp.payment_method_id lab_payment_method_id,
            local_sp_group.code lab_sp_group_code,local_sp_group.name lab_sp_group_name,
            case when fpt.sex = 'M' then amount else 0 end lab_sp_group_male_rate, 
            case when fpt.sex = 'F' then amount else 0 end lab_sp_group_female_rate,
            local_sp_group.payment_method_id lab_sp_group_payment_method_id
            from fomema_backup_nios.fom_pay_transaction fpt
            join laboratories sp on sp_code = sp.code
            left join fomema_backup_nios.service_providers_group sp_group on fpt.sp_group_id = sp_group.id
            left join service_provider_groups local_sp_group on sp_group.group_code = local_sp_group.code
            where sp_type = 'L'
        ) as lab_join
    on doc_join.doc_trans_id = lab_join.lab_trans_id
    ) as temp_fom
    join transactions local_trans on temp_fom.doc_trans_id = local_trans.code;

    perform end_migration_log(v_log_id);
end
$$;

\echo "transaction_details.sql ended"