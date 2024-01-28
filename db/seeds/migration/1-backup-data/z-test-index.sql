
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

    update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_process;

end;
$$;
