\echo "update_service_provider_status_details.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('update_service_provider_status_details.sql') into v_log_id; commit;

    update doctors set status_comment = (select sc.comments
    from fomema_backup_nios.suspension_comments sc
    where sc.bc_user_code = doctors.code and
        sc.modification_date = (select max(temp_sc.modification_date) from fomema_backup_nios.suspension_comments temp_sc where temp_sc.bc_user_code = sc.bc_user_code and ((temp_sc.suspend_start <= NOW() and temp_sc.suspend_end >= NOW()) or temp_sc.suspend_end is null) limit 1) limit 1);

    update xray_facilities set status_comment = (select sc.comments
    from fomema_backup_nios.suspension_comments sc
    where sc.bc_user_code = xray_facilities.code and
        sc.modification_date = (select max(temp_sc.modification_date) from fomema_backup_nios.suspension_comments temp_sc where temp_sc.bc_user_code = sc.bc_user_code and ((temp_sc.suspend_start <= NOW() and temp_sc.suspend_end >= NOW()) or temp_sc.suspend_end is null) limit 1) limit 1);

    update laboratories set status_comment = (select sc.comments
    from fomema_backup_nios.suspension_comments sc
    where sc.bc_user_code = laboratories.code and
        sc.modification_date = (select max(temp_sc.modification_date) from fomema_backup_nios.suspension_comments temp_sc where temp_sc.bc_user_code = sc.bc_user_code and ((temp_sc.suspend_start <= NOW() and temp_sc.suspend_end >= NOW()) or temp_sc.suspend_end is null) limit 1) limit 1);

    perform end_migration_log(v_log_id);
end
$$;

\echo "update_service_provider_status_details.sql ended"
