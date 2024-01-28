
\echo 'radiologist.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('radiologist.sql') into v_log_id; commit;

    insert into radiologists (
        code, name, created_at, 
        address1, address2, address3, address4, 
        postcode, phone, fax, 
        town_id, state_id, country_id, 
        email, qualification, status, comment, 
        created_by, updated_by, updated_at, 
        district_health_office_id, icno, is_pcr, 
        apc_year, apc_number, nsr_number, 
        xray_facility_name, renewal_agreement_date,
        registration_approved_at,
        activated_at
    ) 
    select r.radiologist_code, r.radiologist_name, coalesce(r.creation_date, clock_timestamp()), 
    r.address1, r.address2, r.address3, r.address4, 
    r.post_code, r.phone, r.fax, 
    /* r.district_code */ towns.id town_id, /* r.state_code */ states.id state_id, /* r.country_code */ countries.id country_id, 
    r.email_id, r.qualification, /* r.status_code */ case when r.status_code = 'Y' then 'ACTIVE' 
    else 'INACTIVE' end status, r.comments, 
    /* r.creator_id */ creator_users.id created_by, /* r.modify_id */ updator_users.id updated_by, coalesce(r.modification_date, clock_timestamp()), 
    /* r.nearest_district_office */ dho.id district_health_office_id, coalesce(r.radiologist_ic_new, r.radiologist_ic_old), /* r.is_pcr */ case when r.is_pcr = 'Y' then true else false end is_pcr, 
    r.apc_year::integer, r.apc_no, r.nsr_no, 
    r.xray_name, r.renewal_date ,
    case when r.status_code = 'Y' then coalesce(r.creation_date, clock_timestamp()) end,
    case when r.status_code = 'Y' then coalesce(r.creation_date, clock_timestamp()) end
    from fomema_backup_nios.radiologist_master r 
    left join states on states.code = r.state_code 
    left join towns on towns.code = r.district_code 
    left join countries on countries.old_code = r.country_code 
    left join fomema_backup_nios.v_user_master creators on r.creator_id = creators.uuid 
    left join users creator_users on creators.userid = creator_users.code 
    left join fomema_backup_nios.v_user_master updators on r.modify_id = updators.uuid 
    left join users updator_users on updators.userid = updator_users.code 
    left join fomema_backup_nios.district_office doff on doff.office_code = r.nearest_district_office 
    left join district_health_offices dho on dho.code = doff.office_code
    order by r.creation_date;

    perform end_migration_log(v_log_id);
end
$$;

\echo 'radiologist.sql ended'
