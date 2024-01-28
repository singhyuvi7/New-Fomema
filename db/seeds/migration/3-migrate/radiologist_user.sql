\echo "radiologist_user.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('radiologist_user.sql') into v_log_id; commit;

    update radiologists set user_id = u.id 
    from fomema_backup_nios.radiologist_master rm join fomema_backup_nios.v_user_master um on rm.nios_uuid = um.uuid 
    join users u on um.userid = u.code where radiologists.code = rm.radiologist_code;

    perform end_migration_log(v_log_id);
end
$$;

\echo "radiologist_user.sql end"
