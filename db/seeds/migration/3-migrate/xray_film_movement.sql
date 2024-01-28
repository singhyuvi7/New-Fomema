\echo "xray_film_movement.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('xray_film_movement.sql') into v_log_id; commit;

    insert into digital_xray_movements (
        transaction_id,
        status,
        created_at,
        description,
        created_by,
        updated_by,
        updated_at
    ) 
    select 
        t.id as transaction_id,
        xfm.status as status,
        coalesce(xfm.status_date, clock_timestamp()) as created_at,
        xfm.comments as description,
        coalesce(nios_users.id, xray_users.id) as created_by,
        coalesce(nios_users.id, xray_users.id) as updated_by,
        coalesce(xfm.status_date, clock_timestamp()) as updated_at
    from fomema_backup_nios.xray_film_movement xfm join transactions t on xfm.trans_id = t.code
    left join users xray_users on xfm.user_id = xray_users.username and xray_users.userable_type = 'XrayFacility'
    left join fomema_backup_nios.v_user_master vum on xfm.user_id = vum.uuid::varchar
    left join users nios_users on vum.userid = nios_users.username
    order by xfm.status_date;

    perform end_migration_log(v_log_id);
end
$$;

\echo "xray_film_movement.sql ended"
