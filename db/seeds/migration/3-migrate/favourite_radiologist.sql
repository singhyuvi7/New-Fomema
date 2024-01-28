\echo 'favourite_radiologist.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('favourite_radiologist.sql') into v_log_id; commit;

    insert into favourite_radiologists (
        xray_facility_id,
        radiologist_id,
        created_at,
        updated_at,
        created_by,
        updated_by
    )
    select 
    /* xc.bc_xray_code */ xf.id as xray_facility_id, 
    /* xc.bc_radiologist_code */ r.id as radiologist_id, 
    coalesce(xc.modify_date, clock_timestamp()) as created_at,
    coalesce(xc.modify_date, clock_timestamp()) as updated_by,
    /* um.modify_id */ u.id as created_by, 
    /* um.modify_id */ u.id as updated_by 
    from fomema_backup_nios.xray_coupling xc join xray_facilities xf on xc.bc_xray_code = xf.code 
    join radiologists r on xc.bc_radiologist_code = r.code 
    left join fomema_backup_nios.v_user_master um on xc.modify_id = um.uuid 
    left join users u on um.userid = u.code
    order by xc.modify_date
    ;

    perform end_migration_log(v_log_id);
end
$$;

\echo 'favourite_radiologist.sql ended'
