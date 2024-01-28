
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_item bigint;
begin
    insert into copy_logs (description, begin_at) values ('start index nios master process', clock_timestamp()) returning id into v_copy_log_id_process;

begin
    insert into copy_logs (description, begin_at) values ('start index AGENT_MASTER.POST_CODE, idx_agent_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_agent_master_on_post_code on nios.AGENT_MASTER(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index AGENT_MASTER.DISTRICT_CODE, idx_agent_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_agent_master_on_district_code on nios.AGENT_MASTER(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index AGENT_MASTER.STATE_CODE, idx_agent_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_agent_master_on_state_code on nios.AGENT_MASTER(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index AGENT_MASTER.COUNTRY_CODE, idx_agent_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_agent_master_on_country_code on nios.AGENT_MASTER(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index AGENT_MASTER.BRANCH_CODE, idx_agent_master_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_agent_master_on_branch_code on nios.AGENT_MASTER(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index AGENT_MASTER.STATUS_CODE, idx_agent_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_agent_master_on_status_code on nios.AGENT_MASTER(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index BANK_MASTER.BANK_CODE, idx_bank_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_bank_master_on_bank_code on nios.BANK_MASTER(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index BANK_MASTER.SWIFT_CODE, idx_bank_master_on_swift_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_bank_master_on_swift_code on nios.BANK_MASTER(SWIFT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index CODE_MASTER.STATE_CODE, idx_code_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_code_master_on_state_code on nios.CODE_MASTER(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index CODE_STATE_MASTER.STATE_CODE, idx_code_state_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_code_state_master_on_state_code on nios.CODE_STATE_MASTER(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index CODE_STATE_MASTER.MAP_CODE, idx_code_state_master_on_map_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_code_state_master_on_map_code on nios.CODE_STATE_MASTER(MAP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index CONDITION_MASTER.PARAMETER_CODE, idx_condition_master_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_condition_master_on_parameter_code on nios.CONDITION_MASTER(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index COUNTRY_MASTER.COUNTRY_CODE, idx_country_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_country_master_on_country_code on nios.COUNTRY_MASTER(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DISTRICT_MASTER.DISTRICT_CODE, idx_district_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_district_master_on_district_code on nios.DISTRICT_MASTER(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DISTRICT_MASTER.COUNTRY_CODE, idx_district_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_district_master_on_country_code on nios.DISTRICT_MASTER(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DISTRICT_MASTER.STATE_CODE, idx_district_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_district_master_on_state_code on nios.DISTRICT_MASTER(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_MASTER.DOCTOR_CODE, idx_doctor_master_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_master_on_doctor_code on nios.DOCTOR_MASTER(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_MASTER.POST_CODE, idx_doctor_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_master_on_post_code on nios.DOCTOR_MASTER(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_MASTER.STATE_CODE, idx_doctor_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_master_on_state_code on nios.DOCTOR_MASTER(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_MASTER.DISTRICT_CODE, idx_doctor_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_master_on_district_code on nios.DOCTOR_MASTER(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_MASTER.COUNTRY_CODE, idx_doctor_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_master_on_country_code on nios.DOCTOR_MASTER(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_MASTER.RADIOLOGIST_CODE, idx_doctor_master_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_master_on_radiologist_code on nios.DOCTOR_MASTER(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_MASTER.XRAY_CODE, idx_doctor_master_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_master_on_xray_code on nios.DOCTOR_MASTER(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_MASTER.LABORATORY_CODE, idx_doctor_master_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_master_on_laboratory_code on nios.DOCTOR_MASTER(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_MASTER.STATUS_CODE, idx_doctor_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_master_on_status_code on nios.DOCTOR_MASTER(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_MASTER.PREFER_XRAY_CODE, idx_doctor_master_on_prefer_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_master_on_prefer_xray_code on nios.DOCTOR_MASTER(PREFER_XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_MASTER.GST_CODE, idx_doctor_master_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_master_on_gst_code on nios.DOCTOR_MASTER(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_MASTER.BANK_CODE, idx_doctor_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_master_on_bank_code on nios.DOCTOR_MASTER(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_PARAMETER_MASTER.PARAMETER_CODE, idx_doctor_parameter_master_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_parameter_master_on_parameter_code on nios.DOCTOR_PARAMETER_MASTER(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DRAFT_MASTER.APPROVAL_CODE, idx_draft_master_on_approval_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_draft_master_on_approval_code on nios.DRAFT_MASTER(APPROVAL_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DRAFT_MASTER.BANK_CODE, idx_draft_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_draft_master_on_bank_code on nios.DRAFT_MASTER(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DRAFT_MASTER.BRANCH_CODE, idx_draft_master_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_draft_master_on_branch_code on nios.DRAFT_MASTER(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DRAFT_MASTER.CONTACT_DISTRICT_CODE, idx_draft_master_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_draft_master_on_contact_district_code on nios.DRAFT_MASTER(CONTACT_DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DRAFT_MASTER.CONTACT_POST_CODE, idx_draft_master_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_draft_master_on_contact_post_code on nios.DRAFT_MASTER(CONTACT_POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DRAFT_MASTER.CONTACT_STATE_CODE, idx_draft_master_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_draft_master_on_contact_state_code on nios.DRAFT_MASTER(CONTACT_STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DRAFT_MASTER.ZONE_CODE, idx_draft_master_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_draft_master_on_zone_code on nios.DRAFT_MASTER(ZONE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_ALLOC_MASTER.APPROVAL_CODE, idx_employer_alloc_master_on_approval_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_alloc_master_on_approval_code on nios.EMPLOYER_ALLOC_MASTER(APPROVAL_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_ALLOC_MASTER.BANK_CODE, idx_employer_alloc_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_alloc_master_on_bank_code on nios.EMPLOYER_ALLOC_MASTER(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_ALLOC_MASTER.BRANCH_CODE, idx_employer_alloc_master_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_alloc_master_on_branch_code on nios.EMPLOYER_ALLOC_MASTER(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_ALLOC_MASTER.CONTACT_DISTRICT_CODE, idx_employer_alloc_master_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_alloc_master_on_contact_district_code on nios.EMPLOYER_ALLOC_MASTER(CONTACT_DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_ALLOC_MASTER.CONTACT_POST_CODE, idx_employer_alloc_master_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_alloc_master_on_contact_post_code on nios.EMPLOYER_ALLOC_MASTER(CONTACT_POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_ALLOC_MASTER.CONTACT_STATE_CODE, idx_employer_alloc_master_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_alloc_master_on_contact_state_code on nios.EMPLOYER_ALLOC_MASTER(CONTACT_STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_ALLOC_MASTER.ZONE_CODE, idx_employer_alloc_master_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_alloc_master_on_zone_code on nios.EMPLOYER_ALLOC_MASTER(ZONE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_MASTER.COMPANY_REGNO, idx_employer_master_on_company_regno', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_master_on_company_regno on nios.EMPLOYER_MASTER(COMPANY_REGNO);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_MASTER.ICPASSPORT_NO, idx_employer_master_on_icpassport_no', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_master_on_icpassport_no on nios.EMPLOYER_MASTER(ICPASSPORT_NO);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_MASTER.EMPLOYER_CODE, idx_employer_master_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_master_on_employer_code on nios.EMPLOYER_MASTER(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_MASTER.BUSINESS_CODE, idx_employer_master_on_business_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_master_on_business_code on nios.EMPLOYER_MASTER(BUSINESS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_MASTER.COUNTRY_CODE, idx_employer_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_master_on_country_code on nios.EMPLOYER_MASTER(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_MASTER.STATE_CODE, idx_employer_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_master_on_state_code on nios.EMPLOYER_MASTER(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_MASTER.DISTRICT_CODE, idx_employer_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_master_on_district_code on nios.EMPLOYER_MASTER(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_MASTER.STATUS_CODE, idx_employer_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_master_on_status_code on nios.EMPLOYER_MASTER(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_MASTER.POST_CODE, idx_employer_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_master_on_post_code on nios.EMPLOYER_MASTER(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_MASTER.DOCTOR_CODE, idx_employer_master_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_master_on_doctor_code on nios.EMPLOYER_MASTER(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_MASTER.BRANCH_CODE, idx_employer_master_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_master_on_branch_code on nios.EMPLOYER_MASTER(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;





begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_CLINIC_MASTER.CLINIC_CODE, idx_foreign_clinic_master_on_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_clinic_master_on_clinic_code on nios.FOREIGN_CLINIC_MASTER(CLINIC_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_CLINIC_MASTER.COUNTRY_CODE, idx_foreign_clinic_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_clinic_master_on_country_code on nios.FOREIGN_CLINIC_MASTER(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_CLINIC_MASTER.STATUS_CODE, idx_foreign_clinic_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_clinic_master_on_status_code on nios.FOREIGN_CLINIC_MASTER(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_WORKER_MASTER_CANCEL.WORKER_CODE, idx_foreign_worker_master_cancel_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_worker_master_cancel_on_worker_code on nios.FOREIGN_WORKER_MASTER_CANCEL(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_WORKER_MASTER_CANCEL.COUNTRY_CODE, idx_foreign_worker_master_cancel_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_worker_master_cancel_on_country_code on nios.FOREIGN_WORKER_MASTER_CANCEL(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_WORKER_MASTER_CANCEL.EMPLOYER_CODE, idx_foreign_worker_master_cancel_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_worker_master_cancel_on_employer_code on nios.FOREIGN_WORKER_MASTER_CANCEL(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_WORKER_MASTER_CANCEL.STATUS_CODE, idx_foreign_worker_master_cancel_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_worker_master_cancel_on_status_code on nios.FOREIGN_WORKER_MASTER_CANCEL(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_WORKER_MASTER_CANCEL.CLINIC_CODE, idx_foreign_worker_master_cancel_on_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_worker_master_cancel_on_clinic_code on nios.FOREIGN_WORKER_MASTER_CANCEL(CLINIC_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_WORKER_MASTER_DELETE.WORKER_CODE, idx_foreign_worker_master_delete_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_worker_master_delete_on_worker_code on nios.FOREIGN_WORKER_MASTER_DELETE(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_WORKER_MASTER_DELETE.COUNTRY_CODE, idx_foreign_worker_master_delete_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_worker_master_delete_on_country_code on nios.FOREIGN_WORKER_MASTER_DELETE(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_WORKER_MASTER_DELETE.EMPLOYER_CODE, idx_foreign_worker_master_delete_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_worker_master_delete_on_employer_code on nios.FOREIGN_WORKER_MASTER_DELETE(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_WORKER_MASTER_DELETE.STATUS_CODE, idx_foreign_worker_master_delete_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_worker_master_delete_on_status_code on nios.FOREIGN_WORKER_MASTER_DELETE(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_WORKER_MASTER_DELETE.CLINIC_CODE, idx_foreign_worker_master_delete_on_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_worker_master_delete_on_clinic_code on nios.FOREIGN_WORKER_MASTER_DELETE(CLINIC_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index INVOICE_MASTER.SERVICE_PROVIDER_CODE, idx_invoice_master_on_service_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_invoice_master_on_service_provider_code on nios.INVOICE_MASTER(SERVICE_PROVIDER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index INVOICE_MASTER.GST_CODE, idx_invoice_master_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_invoice_master_on_gst_code on nios.INVOICE_MASTER(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index JOBTYPE_MASTER.STATUS_CODE, idx_jobtype_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_jobtype_master_on_status_code on nios.JOBTYPE_MASTER(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_MASTER.LABORATORY_CODE, idx_laboratory_master_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_master_on_laboratory_code on nios.LABORATORY_MASTER(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_MASTER.POST_CODE, idx_laboratory_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_master_on_post_code on nios.LABORATORY_MASTER(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_MASTER.STATE_CODE, idx_laboratory_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_master_on_state_code on nios.LABORATORY_MASTER(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_MASTER.DISTRICT_CODE, idx_laboratory_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_master_on_district_code on nios.LABORATORY_MASTER(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_MASTER.COUNTRY_CODE, idx_laboratory_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_master_on_country_code on nios.LABORATORY_MASTER(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_MASTER.STATUS_CODE, idx_laboratory_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_master_on_status_code on nios.LABORATORY_MASTER(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_MASTER.GST_CODE, idx_laboratory_master_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_master_on_gst_code on nios.LABORATORY_MASTER(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_MASTER.BANK_CODE, idx_laboratory_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_master_on_bank_code on nios.LABORATORY_MASTER(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index LAB_RATES_MASTER.LAB_CODE, idx_lab_rates_master_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_lab_rates_master_on_lab_code on nios.LAB_RATES_MASTER(LAB_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index MYIMMS_COUNTRY_MASTER.NIOS_COUNTRY_CODE, idx_myimms_country_master_on_nios_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_myimms_country_master_on_nios_country_code on nios.MYIMMS_COUNTRY_MASTER(NIOS_COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index MYIMMS_COUNTRY_MASTER.MYIMMS_COUNTRY_CODE, idx_myimms_country_master_on_myimms_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_myimms_country_master_on_myimms_country_code on nios.MYIMMS_COUNTRY_MASTER(MYIMMS_COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index POST_MASTER.POST_CODE, idx_post_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_post_master_on_post_code on nios.POST_MASTER(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_MASTER.RADIOLOGIST_CODE, idx_radiologist_master_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_master_on_radiologist_code on nios.RADIOLOGIST_MASTER(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_MASTER.POST_CODE, idx_radiologist_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_master_on_post_code on nios.RADIOLOGIST_MASTER(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_MASTER.DISTRICT_CODE, idx_radiologist_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_master_on_district_code on nios.RADIOLOGIST_MASTER(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_MASTER.STATE_CODE, idx_radiologist_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_master_on_state_code on nios.RADIOLOGIST_MASTER(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_MASTER.COUNTRY_CODE, idx_radiologist_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_master_on_country_code on nios.RADIOLOGIST_MASTER(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_MASTER.STATUS_CODE, idx_radiologist_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_master_on_status_code on nios.RADIOLOGIST_MASTER(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_MASTER.GST_CODE, idx_radiologist_master_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_master_on_gst_code on nios.RADIOLOGIST_MASTER(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RADIOLOGIST_MASTER.BANK_CODE, idx_radiologist_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_radiologist_master_on_bank_code on nios.RADIOLOGIST_MASTER(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index SCB_PAY_MASTER.WORKER_CODE, idx_scb_pay_master_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_pay_master_on_worker_code on nios.SCB_PAY_MASTER(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_PAY_MASTER.DOCTOR_CODE, idx_scb_pay_master_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_pay_master_on_doctor_code on nios.SCB_PAY_MASTER(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_PAY_MASTER.XRAY_CLINIC_CODE, idx_scb_pay_master_on_xray_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_pay_master_on_xray_clinic_code on nios.SCB_PAY_MASTER(XRAY_CLINIC_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SCB_PAY_MASTER_UPLOAD.WORKER_CODE, idx_scb_pay_master_upload_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_pay_master_upload_on_worker_code on nios.SCB_PAY_MASTER_UPLOAD(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_PAY_MASTER_UPLOAD.DOCTOR_CODE, idx_scb_pay_master_upload_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_pay_master_upload_on_doctor_code on nios.SCB_PAY_MASTER_UPLOAD(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_PAY_MASTER_UPLOAD.XRAY_CLINIC_CODE, idx_scb_pay_master_upload_on_xray_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_pay_master_upload_on_xray_clinic_code on nios.SCB_PAY_MASTER_UPLOAD(XRAY_CLINIC_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDERS_BANK_MASTER.BANK_CODE, idx_service_providers_bank_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_providers_bank_master_on_bank_code on nios.SERVICE_PROVIDERS_BANK_MASTER(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDERS_BANK_MASTER.SWIFT_CODE, idx_service_providers_bank_master_on_swift_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_providers_bank_master_on_swift_code on nios.SERVICE_PROVIDERS_BANK_MASTER(SWIFT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index STATE_MASTER.STATE_CODE, idx_state_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_state_master_on_state_code on nios.STATE_MASTER(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index STATE_MASTER_RPT.STATE_CODE, idx_state_master_rpt_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_state_master_rpt_on_state_code on nios.STATE_MASTER_RPT(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index STATE_POST_MASTER.STATE_CODE, idx_state_post_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_state_post_master_on_state_code on nios.STATE_POST_MASTER(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index STATE_POST_MASTER.POST_CODE, idx_state_post_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_state_post_master_on_post_code on nios.STATE_POST_MASTER(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;







begin
    insert into copy_logs (description, begin_at) values ('start index VISIT_RPT_LABMASTER.LABORATORY_CODE, idx_visit_rpt_labmaster_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_visit_rpt_labmaster_on_laboratory_code on nios.VISIT_RPT_LABMASTER(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index VISIT_RPT_LABMASTER.COV_DISTRICTCODE, idx_visit_rpt_labmaster_on_cov_districtcode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_visit_rpt_labmaster_on_cov_districtcode on nios.VISIT_RPT_LABMASTER(COV_DISTRICTCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index V_APPEAL_MASTER.TRANS_ID, idx_v_appeal_master_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_appeal_master_on_trans_id on nios.V_APPEAL_MASTER(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index V_APPEAL_MASTER.WORKER_CODE, idx_v_appeal_master_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_appeal_master_on_worker_code on nios.V_APPEAL_MASTER(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index V_FOREIGN_WORKER_MASTER.CREATION_DATE, idx_v_foreign_worker_master_on_creation_date', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_foreign_worker_master_on_creation_date on nios.V_FOREIGN_WORKER_MASTER(CREATION_DATE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index V_FOREIGN_WORKER_MASTER.WORKER_CODE, idx_v_foreign_worker_master_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_foreign_worker_master_on_worker_code on nios.V_FOREIGN_WORKER_MASTER(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index V_FOREIGN_WORKER_MASTER.COUNTRY_CODE, idx_v_foreign_worker_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_foreign_worker_master_on_country_code on nios.V_FOREIGN_WORKER_MASTER(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index V_FOREIGN_WORKER_MASTER.EMPLOYER_CODE, idx_v_foreign_worker_master_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_foreign_worker_master_on_employer_code on nios.V_FOREIGN_WORKER_MASTER(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index V_FOREIGN_WORKER_MASTER.STATUS_CODE, idx_v_foreign_worker_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_foreign_worker_master_on_status_code on nios.V_FOREIGN_WORKER_MASTER(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index V_FOREIGN_WORKER_MASTER.CLINIC_CODE, idx_v_foreign_worker_master_on_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_foreign_worker_master_on_clinic_code on nios.V_FOREIGN_WORKER_MASTER(CLINIC_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index V_USER_MASTER.BRANCH_CODE, idx_v_user_master_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_user_master_on_branch_code on nios.V_USER_MASTER(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_MASTER.XRAY_CODE, idx_xray_master_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_master_on_xray_code on nios.XRAY_MASTER(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_MASTER.POST_CODE, idx_xray_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_master_on_post_code on nios.XRAY_MASTER(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_MASTER.DISTRICT_CODE, idx_xray_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_master_on_district_code on nios.XRAY_MASTER(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_MASTER.STATE_CODE, idx_xray_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_master_on_state_code on nios.XRAY_MASTER(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_MASTER.COUNTRY_CODE, idx_xray_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_master_on_country_code on nios.XRAY_MASTER(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_MASTER.STATUS_CODE, idx_xray_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_master_on_status_code on nios.XRAY_MASTER(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_MASTER.GST_CODE, idx_xray_master_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_master_on_gst_code on nios.XRAY_MASTER(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_MASTER.BANK_CODE, idx_xray_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_master_on_bank_code on nios.XRAY_MASTER(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index ZONE_MASTER.ZONE_CODE, idx_zone_master_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_zone_master_on_zone_code on nios.ZONE_MASTER(ZONE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ZONE_MASTER.STATE_CODE, idx_zone_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_zone_master_on_state_code on nios.ZONE_MASTER(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ZONE_MASTER.DISTRICT_CODE, idx_zone_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_zone_master_on_district_code on nios.ZONE_MASTER(DISTRICT_CODE);

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
