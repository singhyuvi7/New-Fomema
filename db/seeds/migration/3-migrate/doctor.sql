
\echo 'doctor.sql loaded'

do $$
declare
    v_log_id bigint;
    co_id bigint;
    new_ic_id bigint;
    v_roc_id bigint;
begin
    select start_migration_log('doctor.sql') into v_log_id;
    commit;

    select id into co_id from payment_methods where code = 'OUT_CASHORDER';
    select id into new_ic_id from payment_methods where code = 'OUT_GIRONEWIC';
    select id into v_roc_id from payment_methods where code = 'OUT_GIROROC';

    with nios_group as (
        select g.id, g.group_code, g.service_type, g.email_address, g.male_rate, g.female_rate, g.bank_account_no, g.bank_account_holder_name, banks.id as bank_id, g.roc, count(g.id) as cnt
        from fomema_backup_nios.service_providers_group g
        join fomema_backup_nios.service_providers_group_member m on g.id = m.service_providers_group_id
        left join banks on g.bank_code = banks.code
        where g.service_type = 'D'
        group by g.id, g.group_code, g.service_type, g.email_address, g.male_rate, g.female_rate, g.bank_account_no, g.bank_account_holder_name, banks.id, g.roc
    )
    insert into doctors (
        code, 
        name, 
        company_name, 
        business_registration_number,
        clinic_name, 
        created_at, 
        icno, 
        apc_number, 
        apc_year, 
        address1, 
        address2, 
        address3, 
        address4, 
        postcode, 
        phone, 
        fax, 
        state_id, 
        town_id, 
        country_id, 
        xray_facility_id, 
        laboratory_id, 
        email, 
        has_xray, 
        qualification, 
        solo_clinic, 
        group_clinic, 
        status, 
        comment, 
        quota, 
        quota_used, 
        district_health_office_id, 
        created_by, 
        updated_by, 
        updated_at, 
        male_rate, 
        female_rate, 
        bank_account_number, 
        bank_id, 
        mobile, 
        renewal_agreement_date, 
        fp_device,
        service_provider_group_id, 
        registration_approved_at,
        activated_at,
        payment_method_id,
        email_payment, 
        bank_payment_id
    ) 
    select 
        distinct dm.doctor_code as code, 
        dm.doctor_name as name, 
        case when nios_group.cnt = 1 then nios_group.bank_account_holder_name else null end, 
        case when nios_group.cnt = 1 then nios_group.roc else null end, 
        dm.clinic_name, coalesce(dm.creation_date, clock_timestamp()) as created_at, 
        coalesce(dm.doctor_ic_new, dm.doctor_ic_old), dm.application_number, dm.application_year::integer, 
        coalesce(dm.address1,''), coalesce(dm.address2,''), coalesce(dm.address3,''), coalesce(dm.address4,''), 
        dm.post_code, dm.phone, dm.fax, 
        states.id state_id, towns.id town_id, countries.id country_id, 
        xray_facilities.id xray_facility_id, laboratories.id laboratory_id, dm.email_id, 
        case when dm.own_xray_clinic = 'Y' then true else false end has_xray, dm.qualification, 
        dm.no_of_solo_clinics::integer, dm.no_of_group_clinics::integer, 
        case when dm.status_code = 'Y' then 'ACTIVE' else 'INACTIVE' end as status, 
        dm.comments as comment, 
        dm.quota as quota, 
        dm.quota_use as quota_used, 
        dho.id as district_health_office_id, 
        creator_users.id as created_by, 
        updator_users.id as updated_by, 
        coalesce(dm.modification_date, clock_timestamp()) as updated_at, 
        case when nios_group.cnt = 1 then nios_group.male_rate else dm.male_rate end as male_rate,
        case when nios_group.cnt = 1 then nios_group.female_rate else dm.female_rate end as female_rate,
        case when nios_group.cnt = 1 then nios_group.bank_account_no else dm.bank_account_no end, 
        case when nios_group.cnt = 1 then nios_group.bank_id else banks.id end, 
        dm.mobile_no mobile, dm.renewal_date renewal_agreement_date, coalesce(dm.fp_device, 0) fp_device,
        case when nios_group.cnt = 1 then null else sp_group.id end service_provider_group_id,
        case when dm.status_code = 'Y' then coalesce(dm.creation_date, clock_timestamp()) end as registration_approved_at,
        case when dm.status_code = 'Y' then coalesce(dm.creation_date, clock_timestamp()) end as activated_at,
        case when nios_group.cnt = 1 then (case when nios_group.bank_account_no is null then co_id else v_roc_id end)
        when dm.bank_account_no is null then co_id
        when dm.mystics_ic = 0 then co_id 
        when dm.mystics_ic in (1,2) then new_ic_id end,
        case when nios_group.cnt = 1 then nios_group.email_address else dm.email_id end, 
        case when nios_group.cnt = 1 then nios_group.roc else coalesce(dm.doctor_ic_new, dm.doctor_ic_old) end
    from fomema_backup_nios.doctor_master dm 
    left join states on states.code = dm.state_code 
    left join towns on towns.code = dm.district_code 
    left join countries on countries.old_code = dm.country_code 
    left join fomema_backup_nios.v_user_master creators on dm.creator_id = creators.uuid 
    left join users creator_users on creators.userid = creator_users.code 
    left join fomema_backup_nios.v_user_master updators on dm.modify_id = updators.uuid 
    left join users updator_users on updators.userid = updator_users.code 
    left join fomema_backup_nios.district_office doff on doff.office_code = dm.nearest_district_office 
    left join district_health_offices dho on dho.code = doff.office_code 
    left join banks on dm.bank_code = banks.code 
    left join xray_facilities on dm.xray_code = xray_facilities.code 
    left join laboratories on dm.laboratory_code = laboratories.code
    left join fomema_backup_nios.service_providers_group_member group_member on dm.doctor_code = group_member.service_member
    left join nios_group on group_member.service_providers_group_id = nios_group.id
    left join service_provider_groups sp_group on nios_group.group_code = sp_group.code
    order by created_at;

    perform end_migration_log(v_log_id);
end
$$;

\echo 'doctor.sql ended'
