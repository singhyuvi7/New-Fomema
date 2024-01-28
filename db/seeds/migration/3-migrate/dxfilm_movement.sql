\echo "dxfilm_movement.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('dxfilm_movement.sql') into v_log_id; commit;

    insert into digital_xray_movements (
        description,
        status,
        created_at,
        transaction_id,
        created_by,
        updated_at,
        updated_by
    ) 
    select  
        dm.comments as description,
        dm.status as status,
        coalesce(dm.status_date, clock_timestamp()) as created_at,
        t.id as transaction_id,
        coalesce(doctor_users.id, radiologist_users.id, nios_users.id) as created_by,
        coalesce(dm.status_date, clock_timestamp()) as updated_at,
        coalesce(doctor_users.id, radiologist_users.id, nios_users.id) as updated_by
    from fomema_backup_nios.dxfilm_movement dm join transactions t on dm.trans_id = t.code
    left join users doctor_users on dm.uuid = doctor_users.username and doctor_users.userable_type = 'Doctor'
    left join users radiologist_users on dm.uuid = radiologist_users.username and radiologist_users.userable_type = 'Radiologist'
    left join fomema_backup_nios.v_user_master vum on dm.uuid = vum.uuid::varchar
    left join users nios_users on vum.userid = nios_users.username
    order by created_at;

    perform end_migration_log(v_log_id);
end
$$;

\echo "dxfilm_movement.sql ended"
