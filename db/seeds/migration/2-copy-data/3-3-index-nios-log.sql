
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_item bigint;
begin
    insert into public.migration_logs (description, start_at) values ('start index nios log process', clock_timestamp()) returning id into v_copy_log_id_process;


insert into public.migration_logs (description, start_at) values ('start index batchlog.usercode, idx_batchlog_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_batchlog_on_usercode on fomema_backup_nios.batchlog(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index doctor_opthour_changelog.usercode, idx_doctor_opthour_changelog_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_opthour_changelog_on_usercode on fomema_backup_nios.doctor_opthour_changelog(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwt_audit_log.trans_id, idx_fwt_audit_log_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_audit_log_on_trans_id on fomema_backup_nios.fwt_audit_log(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwt_audit_log_history.trans_id, idx_fwt_audit_log_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_audit_log_history_on_trans_id on fomema_backup_nios.fwt_audit_log_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;





insert into public.migration_logs (description, start_at) values ('start index mystics_log.branch_code, idx_mystics_log_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_mystics_log_on_branch_code on fomema_backup_nios.mystics_log(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index radiologist_history.radiologist_code, idx_radiologist_history_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_history_on_radiologist_code on fomema_backup_nios.radiologist_history(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_history.district_code, idx_radiologist_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_history_on_district_code on fomema_backup_nios.radiologist_history(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_history.country_code, idx_radiologist_history_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_history_on_country_code on fomema_backup_nios.radiologist_history(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_history.state_code, idx_radiologist_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_history_on_state_code on fomema_backup_nios.radiologist_history(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_history.post_code, idx_radiologist_history_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_history_on_post_code on fomema_backup_nios.radiologist_history(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_history.status_code, idx_radiologist_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_history_on_status_code on fomema_backup_nios.radiologist_history(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_history.gst_code, idx_radiologist_history_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_history_on_gst_code on fomema_backup_nios.radiologist_history(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_history.bank_code, idx_radiologist_history_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_history_on_bank_code on fomema_backup_nios.radiologist_history(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;





insert into public.migration_logs (description, start_at) values ('start index t_cnv_radiologist_district.radiologist_code, idx_t_cnv_radiologist_district_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_cnv_radiologist_district_on_radiologist_code on fomema_backup_nios.t_cnv_radiologist_district(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index t_cnv_radiologisth_district.radiologist_code, idx_t_cnv_radiologisth_district_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_cnv_radiologisth_district_on_radiologist_code on fomema_backup_nios.t_cnv_radiologisth_district(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index userlog.usercode, idx_userlog_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_userlog_on_usercode on fomema_backup_nios.userlog(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index userlog_arc.usercode, idx_userlog_arc_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_userlog_arc_on_usercode on fomema_backup_nios.userlog_arc(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index userlog_browser.usercode, idx_userlog_browser_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_userlog_browser_on_usercode on fomema_backup_nios.userlog_browser(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_process;

end;
$$;
