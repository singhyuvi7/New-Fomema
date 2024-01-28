
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_item bigint;
begin
    insert into copy_logs (description, begin_at) values ('start index nios history process', clock_timestamp()) returning id into v_copy_log_id_process;

begin
    insert into copy_logs (description, begin_at) values ('start index AGENT_HISTORY.POST_CODE, idx_agent_history_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_agent_history_on_post_code on nios.AGENT_HISTORY(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index AGENT_HISTORY.DISTRICT_CODE, idx_agent_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_agent_history_on_district_code on nios.AGENT_HISTORY(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index AGENT_HISTORY.STATE_CODE, idx_agent_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_agent_history_on_state_code on nios.AGENT_HISTORY(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index AGENT_HISTORY.COUNTRY_CODE, idx_agent_history_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_agent_history_on_country_code on nios.AGENT_HISTORY(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index AGENT_HISTORY.STATUS_CODE, idx_agent_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_agent_history_on_status_code on nios.AGENT_HISTORY(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index AGENT_HISTORY.BRANCH_CODE, idx_agent_history_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_agent_history_on_branch_code on nios.AGENT_HISTORY(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index BAD_PAYMENT_HISTORY.BANK_CODE, idx_bad_payment_history_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_bad_payment_history_on_bank_code on nios.BAD_PAYMENT_HISTORY(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index BAD_PAYMENT_HISTORY.CONTACT_POST_CODE, idx_bad_payment_history_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_bad_payment_history_on_contact_post_code on nios.BAD_PAYMENT_HISTORY(CONTACT_POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index BAD_PAYMENT_HISTORY.CONTACT_STATE_CODE, idx_bad_payment_history_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_bad_payment_history_on_contact_state_code on nios.BAD_PAYMENT_HISTORY(CONTACT_STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index BAD_PAYMENT_HISTORY.CONTACT_DISTRICT_CODE, idx_bad_payment_history_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_bad_payment_history_on_contact_district_code on nios.BAD_PAYMENT_HISTORY(CONTACT_DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index DISTRICT_OFFICE_HISTORY.OFFICE_CODE, idx_district_office_history_on_office_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_district_office_history_on_office_code on nios.DISTRICT_OFFICE_HISTORY(OFFICE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DISTRICT_OFFICE_HISTORY.POST_CODE, idx_district_office_history_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_district_office_history_on_post_code on nios.DISTRICT_OFFICE_HISTORY(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DISTRICT_OFFICE_HISTORY.DISTRICT_CODE, idx_district_office_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_district_office_history_on_district_code on nios.DISTRICT_OFFICE_HISTORY(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DISTRICT_OFFICE_HISTORY.STATE_CODE, idx_district_office_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_district_office_history_on_state_code on nios.DISTRICT_OFFICE_HISTORY(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DISTRICT_OFFICE_HISTORY.STATUS_CODE, idx_district_office_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_district_office_history_on_status_code on nios.DISTRICT_OFFICE_HISTORY(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_HISTORY.DOCTOR_CODE, idx_doctor_history_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_history_on_doctor_code on nios.DOCTOR_HISTORY(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_HISTORY.POST_CODE, idx_doctor_history_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_history_on_post_code on nios.DOCTOR_HISTORY(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_HISTORY.DISTRICT_CODE, idx_doctor_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_history_on_district_code on nios.DOCTOR_HISTORY(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_HISTORY.STATE_CODE, idx_doctor_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_history_on_state_code on nios.DOCTOR_HISTORY(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_HISTORY.COUNTRY_CODE, idx_doctor_history_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_history_on_country_code on nios.DOCTOR_HISTORY(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_HISTORY.XRAY_CODE, idx_doctor_history_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_history_on_xray_code on nios.DOCTOR_HISTORY(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_HISTORY.RADIOLOGIST_CODE, idx_doctor_history_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_history_on_radiologist_code on nios.DOCTOR_HISTORY(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_HISTORY.LABORATORY_CODE, idx_doctor_history_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_history_on_laboratory_code on nios.DOCTOR_HISTORY(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_HISTORY.STATUS_CODE, idx_doctor_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_history_on_status_code on nios.DOCTOR_HISTORY(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_HISTORY.PREFER_XRAY_CODE, idx_doctor_history_on_prefer_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_history_on_prefer_xray_code on nios.DOCTOR_HISTORY(PREFER_XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_HISTORY.GST_CODE, idx_doctor_history_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_history_on_gst_code on nios.DOCTOR_HISTORY(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_HISTORY.BANK_CODE, idx_doctor_history_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_history_on_bank_code on nios.DOCTOR_HISTORY(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_HISTORY.POST_CODE, idx_employer_history_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_history_on_post_code on nios.EMPLOYER_HISTORY(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_HISTORY.DISTRICT_CODE, idx_employer_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_history_on_district_code on nios.EMPLOYER_HISTORY(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_HISTORY.EMPLOYER_CODE, idx_employer_history_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_history_on_employer_code on nios.EMPLOYER_HISTORY(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_HISTORY.BUSINESS_CODE, idx_employer_history_on_business_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_history_on_business_code on nios.EMPLOYER_HISTORY(BUSINESS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_HISTORY.COUNTRY_CODE, idx_employer_history_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_history_on_country_code on nios.EMPLOYER_HISTORY(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_HISTORY.STATE_CODE, idx_employer_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_history_on_state_code on nios.EMPLOYER_HISTORY(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_HISTORY.DOCTOR_CODE, idx_employer_history_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_history_on_doctor_code on nios.EMPLOYER_HISTORY(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_HISTORY.STATUS_CODE, idx_employer_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_history_on_status_code on nios.EMPLOYER_HISTORY(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_HISTORY.BRANCH_CODE, idx_employer_history_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_history_on_branch_code on nios.EMPLOYER_HISTORY(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index FW_APPEAL_HISTORY.TRANS_ID, idx_fw_appeal_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_appeal_history_on_trans_id on nios.FW_APPEAL_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_APPEAL_HISTORY.APPEAL_DOCTOR_CODE, idx_fw_appeal_history_on_appeal_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_appeal_history_on_appeal_doctor_code on nios.FW_APPEAL_HISTORY(APPEAL_DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_COMMENT_HISTORY.TRANS_ID, idx_fw_comment_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_comment_history_on_trans_id on nios.FW_COMMENT_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_COMMENT_HISTORY.PARAMETER_CODE, idx_fw_comment_history_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_comment_history_on_parameter_code on nios.FW_COMMENT_HISTORY(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_DETAIL_HISTORY.TRANS_ID, idx_fw_detail_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_detail_history_on_trans_id on nios.FW_DETAIL_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_DETAIL_HISTORY.PARAMETER_CODE, idx_fw_detail_history_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_detail_history_on_parameter_code on nios.FW_DETAIL_HISTORY(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_EXTRA_COMMENTS_HISTORY.TRANS_ID, idx_fw_extra_comments_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_extra_comments_history_on_trans_id on nios.FW_EXTRA_COMMENTS_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_QUARANTINE_REASON_HISTORY.TRANS_ID, idx_fw_quarantine_reason_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_quarantine_reason_history_on_trans_id on nios.FW_QUARANTINE_REASON_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_QUARANTINE_REASON_HISTORY.REASON_CODE, idx_fw_quarantine_reason_history_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_quarantine_reason_history_on_reason_code on nios.FW_QUARANTINE_REASON_HISTORY(REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_HISTORY.TRANS_ID, idx_fw_transaction_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_history_on_trans_id on nios.FW_TRANSACTION_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_HISTORY.WORKER_CODE, idx_fw_transaction_history_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_history_on_worker_code on nios.FW_TRANSACTION_HISTORY(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_HISTORY.XRAY_CODE, idx_fw_transaction_history_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_history_on_xray_code on nios.FW_TRANSACTION_HISTORY(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_HISTORY.RADIOLOGIST_CODE, idx_fw_transaction_history_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_history_on_radiologist_code on nios.FW_TRANSACTION_HISTORY(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_HISTORY.DOCTOR_CODE, idx_fw_transaction_history_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_history_on_doctor_code on nios.FW_TRANSACTION_HISTORY(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_HISTORY.LABORATORY_CODE, idx_fw_transaction_history_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_history_on_laboratory_code on nios.FW_TRANSACTION_HISTORY(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_HISTORY.EMPLOYER_CODE, idx_fw_transaction_history_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_history_on_employer_code on nios.FW_TRANSACTION_HISTORY(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_HISTORY.DOCTOR_STATE_CODE, idx_fw_transaction_history_on_doctor_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_history_on_doctor_state_code on nios.FW_TRANSACTION_HISTORY(DOCTOR_STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_HISTORY.BLOOD_BARCODE_NO, idx_fw_transaction_history_on_blood_barcode_no', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_history_on_blood_barcode_no on nios.FW_TRANSACTION_HISTORY(BLOOD_BARCODE_NO);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_HISTORY.URINE_BARCODE_NO, idx_fw_transaction_history_on_urine_barcode_no', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_history_on_urine_barcode_no on nios.FW_TRANSACTION_HISTORY(URINE_BARCODE_NO);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index GROUP_DOCTOR_PAY_HISTORY.GROUP_CODE, idx_group_doctor_pay_history_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_group_doctor_pay_history_on_group_code on nios.GROUP_DOCTOR_PAY_HISTORY(GROUP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index GROUP_DOCTOR_PAY_HISTORY.DOCTOR_CODE, idx_group_doctor_pay_history_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_group_doctor_pay_history_on_doctor_code on nios.GROUP_DOCTOR_PAY_HISTORY(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index GROUP_XRAY_PAY_HISTORY.GROUP_CODE, idx_group_xray_pay_history_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_group_xray_pay_history_on_group_code on nios.GROUP_XRAY_PAY_HISTORY(GROUP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index GROUP_XRAY_PAY_HISTORY.XRAY_CODE, idx_group_xray_pay_history_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_group_xray_pay_history_on_xray_code on nios.GROUP_XRAY_PAY_HISTORY(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_HISTORY.LABORATORY_CODE, idx_laboratory_history_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_history_on_laboratory_code on nios.LABORATORY_HISTORY(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_HISTORY.POST_CODE, idx_laboratory_history_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_history_on_post_code on nios.LABORATORY_HISTORY(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_HISTORY.STATE_CODE, idx_laboratory_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_history_on_state_code on nios.LABORATORY_HISTORY(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_HISTORY.DISTRICT_CODE, idx_laboratory_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_history_on_district_code on nios.LABORATORY_HISTORY(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_HISTORY.COUNTRY_CODE, idx_laboratory_history_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_history_on_country_code on nios.LABORATORY_HISTORY(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_HISTORY.STATUS_CODE, idx_laboratory_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_history_on_status_code on nios.LABORATORY_HISTORY(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_HISTORY.GST_CODE, idx_laboratory_history_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_history_on_gst_code on nios.LABORATORY_HISTORY(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_HISTORY.BANK_CODE, idx_laboratory_history_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_history_on_bank_code on nios.LABORATORY_HISTORY(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REQ_HISTORY.BRANCH_CODE, idx_payment_req_history_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_req_history_on_branch_code on nios.PAYMENT_REQ_HISTORY(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REQ_HISTORY.GST_CODE, idx_payment_req_history_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_req_history_on_gst_code on nios.PAYMENT_REQ_HISTORY(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REQ_HISTORY.SERVICE_PROVIDER_CODE, idx_payment_req_history_on_service_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_req_history_on_service_provider_code on nios.PAYMENT_REQ_HISTORY(SERVICE_PROVIDER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REQ_HISTORY.SP_CODE, idx_payment_req_history_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_req_history_on_sp_code on nios.PAYMENT_REQ_HISTORY(SP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REQ_HISTORY.WORKER_CODE, idx_payment_req_history_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_req_history_on_worker_code on nios.PAYMENT_REQ_HISTORY(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_RELEASE_REQ_HISTORY.TRANS_ID, idx_quarantine_release_req_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_release_req_history_on_trans_id on nios.QUARANTINE_RELEASE_REQ_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_DETAIL_HISTORY.BANK_CODE, idx_receipt_detail_history_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_detail_history_on_bank_code on nios.RECEIPT_DETAIL_HISTORY(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_DETAIL_HISTORY.ZONE_CODE, idx_receipt_detail_history_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_detail_history_on_zone_code on nios.RECEIPT_DETAIL_HISTORY(ZONE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_DETAIL_HISTORY.APPROVAL_CODE, idx_receipt_detail_history_on_approval_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_detail_history_on_approval_code on nios.RECEIPT_DETAIL_HISTORY(APPROVAL_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_HISTORY.CONTACT_POST_CODE, idx_receipt_history_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_history_on_contact_post_code on nios.RECEIPT_HISTORY(CONTACT_POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_HISTORY.CONTACT_STATE_CODE, idx_receipt_history_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_history_on_contact_state_code on nios.RECEIPT_HISTORY(CONTACT_STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_HISTORY.CONTACT_DISTRICT_CODE, idx_receipt_history_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_history_on_contact_district_code on nios.RECEIPT_HISTORY(CONTACT_DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_HISTORY.BRANCH_CODE, idx_receipt_history_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_history_on_branch_code on nios.RECEIPT_HISTORY(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_USAGE_HISTORY.TRANS_ID, idx_receipt_usage_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_usage_history_on_trans_id on nios.RECEIPT_USAGE_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_USAGE_HISTORY.STATUS_CODE, idx_receipt_usage_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_usage_history_on_status_code on nios.RECEIPT_USAGE_HISTORY(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index REFUND_DETAIL_HISTORY.TRANS_ID, idx_refund_detail_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_refund_detail_history_on_trans_id on nios.REFUND_DETAIL_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index REFUND_DETAIL_HISTORY.STATUS_CODE, idx_refund_detail_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_refund_detail_history_on_status_code on nios.REFUND_DETAIL_HISTORY(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index REFUND_HISTORY.STATUS_CODE, idx_refund_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_refund_history_on_status_code on nios.REFUND_HISTORY(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index REFUND_HISTORY.BRANCH_CODE, idx_refund_history_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_refund_history_on_branch_code on nios.REFUND_HISTORY(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index RFW_BATCH_TRANSACTION_HISTORY.LABORATORY_CODE_A, idx_rfw_batch_transaction_history_on_laboratory_code_a', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_batch_transaction_history_on_laboratory_code_a on nios.RFW_BATCH_TRANSACTION_HISTORY(LABORATORY_CODE_A);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RFW_BATCH_TRANSACTION_HISTORY.LABORATORY_CODE_B, idx_rfw_batch_transaction_history_on_laboratory_code_b', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_batch_transaction_history_on_laboratory_code_b on nios.RFW_BATCH_TRANSACTION_HISTORY(LABORATORY_CODE_B);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RFW_BATCH_TRANSACTION_HISTORY.STATUS_CODE, idx_rfw_batch_transaction_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_batch_transaction_history_on_status_code on nios.RFW_BATCH_TRANSACTION_HISTORY(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RFW_BATCH_TRANSACTION_HISTORY.LABORATORY_CODE_ORI, idx_rfw_batch_transaction_history_on_laboratory_code_ori', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_batch_transaction_history_on_laboratory_code_ori on nios.RFW_BATCH_TRANSACTION_HISTORY(LABORATORY_CODE_ORI);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index RFW_CASE_TRANSACTION_HISTORY.TRANS_ID, idx_rfw_case_transaction_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_case_transaction_history_on_trans_id on nios.RFW_CASE_TRANSACTION_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RFW_CASE_TRANSACTION_HISTORY.WORKER_CODE, idx_rfw_case_transaction_history_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_case_transaction_history_on_worker_code on nios.RFW_CASE_TRANSACTION_HISTORY(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RFW_CASE_TRANSACTION_HISTORY.STATUS_CODE, idx_rfw_case_transaction_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_case_transaction_history_on_status_code on nios.RFW_CASE_TRANSACTION_HISTORY(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index RFW_COMMENT_HISTORY.PARAMETER_CODE, idx_rfw_comment_history_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_comment_history_on_parameter_code on nios.RFW_COMMENT_HISTORY(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index RFW_DETAIL_HISTORY.PARAMETER_CODE, idx_rfw_detail_history_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_detail_history_on_parameter_code on nios.RFW_DETAIL_HISTORY(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index RFW_FW_TRANSACTION_HISTORY.LABORATORY_CODE, idx_rfw_fw_transaction_history_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_fw_transaction_history_on_laboratory_code on nios.RFW_FW_TRANSACTION_HISTORY(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDER_GROUP_HISTORY.DISTRICT_CODE, idx_service_provider_group_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_provider_group_history_on_district_code on nios.SERVICE_PROVIDER_GROUP_HISTORY(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDER_GROUP_HISTORY.GROUP_CODE, idx_service_provider_group_history_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_provider_group_history_on_group_code on nios.SERVICE_PROVIDER_GROUP_HISTORY(GROUP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDER_GROUP_HISTORY.POSTCODE, idx_service_provider_group_history_on_postcode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_provider_group_history_on_postcode on nios.SERVICE_PROVIDER_GROUP_HISTORY(POSTCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDER_GROUP_HISTORY.STATE_CODE, idx_service_provider_group_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_provider_group_history_on_state_code on nios.SERVICE_PROVIDER_GROUP_HISTORY(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDER_GROUP_HISTORY.GST_CODE, idx_service_provider_group_history_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_provider_group_history_on_gst_code on nios.SERVICE_PROVIDER_GROUP_HISTORY(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDER_GROUP_HISTORY.BANK_CODE, idx_service_provider_group_history_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_provider_group_history_on_bank_code on nios.SERVICE_PROVIDER_GROUP_HISTORY(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDER_GROUP_HISTORY.SERVICE_PROVIDER_MASTER_CODE, idx_service_provider_group_history_on_service_provider_master_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_provider_group_history_on_service_provider_master_code on nios.SERVICE_PROVIDER_GROUP_HISTORY(SERVICE_PROVIDER_MASTER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index STATUS_CHANGE_HISTORY.TRANS_ID, idx_status_change_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_status_change_history_on_trans_id on nios.STATUS_CHANGE_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index STATUS_CHANGE_HISTORY.WORKER_CODE, idx_status_change_history_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_status_change_history_on_worker_code on nios.STATUS_CHANGE_HISTORY(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index V_FOREIGN_WORKER_HISTORY.STATUS_CODE, idx_v_foreign_worker_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_foreign_worker_history_on_status_code on nios.V_FOREIGN_WORKER_HISTORY(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index V_FOREIGN_WORKER_HISTORY.WORKER_CODE, idx_v_foreign_worker_history_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_foreign_worker_history_on_worker_code on nios.V_FOREIGN_WORKER_HISTORY(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index V_FOREIGN_WORKER_HISTORY.EMPLOYER_CODE, idx_v_foreign_worker_history_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_foreign_worker_history_on_employer_code on nios.V_FOREIGN_WORKER_HISTORY(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index V_FOREIGN_WORKER_HISTORY.COUNTRY_CODE, idx_v_foreign_worker_history_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_foreign_worker_history_on_country_code on nios.V_FOREIGN_WORKER_HISTORY(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index V_FOREIGN_WORKER_HISTORY.CLINIC_CODE, idx_v_foreign_worker_history_on_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_foreign_worker_history_on_clinic_code on nios.V_FOREIGN_WORKER_HISTORY(CLINIC_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index WRONG_TRANSMISSION_HISTORY.TRANS_ID, idx_wrong_transmission_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_wrong_transmission_history_on_trans_id on nios.WRONG_TRANSMISSION_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index WRONG_TRANSMISSION_HISTORY.PROVIDER_CODE, idx_wrong_transmission_history_on_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_wrong_transmission_history_on_provider_code on nios.WRONG_TRANSMISSION_HISTORY(PROVIDER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index XQUA_RELEASE_REQ_HISTORY.TRANS_ID, idx_xqua_release_req_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqua_release_req_history_on_trans_id on nios.XQUA_RELEASE_REQ_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_ADHOC_SUBMIT_HISTORY.TRANS_ID, idx_xray_adhoc_submit_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_adhoc_submit_history_on_trans_id on nios.XRAY_ADHOC_SUBMIT_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_ADHOC_SUBMIT_HISTORY.XRAY_CODE, idx_xray_adhoc_submit_history_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_adhoc_submit_history_on_xray_code on nios.XRAY_ADHOC_SUBMIT_HISTORY(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_ADHOC_SUBMIT_HISTORY.WORKER_CODE, idx_xray_adhoc_submit_history_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_adhoc_submit_history_on_worker_code on nios.XRAY_ADHOC_SUBMIT_HISTORY(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_HISTORY.XRAY_CODE, idx_xray_history_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_history_on_xray_code on nios.XRAY_HISTORY(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_HISTORY.POST_CODE, idx_xray_history_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_history_on_post_code on nios.XRAY_HISTORY(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_HISTORY.DISTRICT_CODE, idx_xray_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_history_on_district_code on nios.XRAY_HISTORY(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_HISTORY.STATE_CODE, idx_xray_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_history_on_state_code on nios.XRAY_HISTORY(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_HISTORY.COUNTRY_CODE, idx_xray_history_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_history_on_country_code on nios.XRAY_HISTORY(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_HISTORY.STATUS_CODE, idx_xray_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_history_on_status_code on nios.XRAY_HISTORY(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_HISTORY.GST_CODE, idx_xray_history_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_history_on_gst_code on nios.XRAY_HISTORY(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_HISTORY.BANK_CODE, idx_xray_history_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_history_on_bank_code on nios.XRAY_HISTORY(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_HISTORY.TRANS_ID, idx_xray_submit_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_history_on_trans_id on nios.XRAY_SUBMIT_HISTORY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_HISTORY.XRAY_CODE, idx_xray_submit_history_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_history_on_xray_code on nios.XRAY_SUBMIT_HISTORY(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_HISTORY.WORKER_CODE, idx_xray_submit_history_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_history_on_worker_code on nios.XRAY_SUBMIT_HISTORY(WORKER_CODE);

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
