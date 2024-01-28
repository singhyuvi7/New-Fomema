
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_item bigint;
begin
    insert into copy_logs (description, begin_at) values ('start index nios log process', clock_timestamp()) returning id into v_copy_log_id_process;


begin
    insert into copy_logs (description, begin_at) values ('start index BATCHLOG.USERCODE, idx_batchlog_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_batchlog_on_usercode on nios.BATCHLOG(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_OPTHOUR_CHANGELOG.USERCODE, idx_doctor_opthour_changelog_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_opthour_changelog_on_usercode on nios.DOCTOR_OPTHOUR_CHANGELOG(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWT_AUDIT_LOG.TRANS_ID, idx_fwt_audit_log_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_audit_log_on_trans_id on nios.FWT_AUDIT_LOG(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWT_AUDIT_LOG_HISTORY.TRANS_ID, idx_fwt_audit_log_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_audit_log_history_on_trans_id on nios.FWT_AUDIT_LOG_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;





begin
    insert into copy_logs (description, begin_at) values ('start index MYSTICS_LOG.BRANCH_CODE, idx_mystics_log_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_mystics_log_on_branch_code on nios.MYSTICS_LOG(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_HISTORY.RADIOLOGIST_CODE, idx_radiologist_history_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_history_on_radiologist_code on nios.RADIOLOGIST_HISTORY(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_HISTORY.DISTRICT_CODE, idx_radiologist_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_history_on_district_code on nios.RADIOLOGIST_HISTORY(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_HISTORY.COUNTRY_CODE, idx_radiologist_history_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_history_on_country_code on nios.RADIOLOGIST_HISTORY(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_HISTORY.STATE_CODE, idx_radiologist_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_history_on_state_code on nios.RADIOLOGIST_HISTORY(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_HISTORY.POST_CODE, idx_radiologist_history_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_history_on_post_code on nios.RADIOLOGIST_HISTORY(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_HISTORY.STATUS_CODE, idx_radiologist_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_history_on_status_code on nios.RADIOLOGIST_HISTORY(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_HISTORY.GST_CODE, idx_radiologist_history_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_history_on_gst_code on nios.RADIOLOGIST_HISTORY(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_HISTORY.BANK_CODE, idx_radiologist_history_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_history_on_bank_code on nios.RADIOLOGIST_HISTORY(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_REGISTRATION.POST_CODE, idx_radiologist_registration_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_registration_on_post_code on nios.RADIOLOGIST_REGISTRATION(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_REGISTRATION.DISTRICT_CODE, idx_radiologist_registration_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_registration_on_district_code on nios.RADIOLOGIST_REGISTRATION(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_REGISTRATION.STATE_CODE, idx_radiologist_registration_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_registration_on_state_code on nios.RADIOLOGIST_REGISTRATION(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_REGISTRATION.COUNTRY_CODE, idx_radiologist_registration_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_registration_on_country_code on nios.RADIOLOGIST_REGISTRATION(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_REGISTRATION.STATUS_CODE, idx_radiologist_registration_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_registration_on_status_code on nios.RADIOLOGIST_REGISTRATION(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;






begin
    insert into copy_logs (description, begin_at) values ('start index T_CNV_RADIOLOGISTH_DISTRICT.RADIOLOGIST_CODE, idx_t_cnv_radiologisth_district_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_cnv_radiologisth_district_on_radiologist_code on nios.T_CNV_RADIOLOGISTH_DISTRICT(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index T_CNV_RADIOLOGIST_DISTRICT.RADIOLOGIST_CODE, idx_t_cnv_radiologist_district_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_cnv_radiologist_district_on_radiologist_code on nios.T_CNV_RADIOLOGIST_DISTRICT(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index USERLOG.USERCODE, idx_userlog_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_userlog_on_usercode on nios.USERLOG(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index USERLOG_ARC.USERCODE, idx_userlog_arc_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_userlog_arc_on_usercode on nios.USERLOG_ARC(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index USERLOG_BROWSER.USERCODE, idx_userlog_browser_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_userlog_browser_on_usercode on nios.USERLOG_BROWSER(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



    update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_process;

end;
$$;
