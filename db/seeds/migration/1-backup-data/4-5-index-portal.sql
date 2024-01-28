
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_item bigint;
begin
    insert into copy_logs (description, begin_at) values ('start index portal process', clock_timestamp()) returning id into v_copy_log_id_process;


begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_REGISTRATION.STATE_CODE, idx_employer_registration_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_registration_on_state_code on portal.EMPLOYER_REGISTRATION(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_REGISTRATION.POST_CODE, idx_employer_registration_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_registration_on_post_code on portal.EMPLOYER_REGISTRATION(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_REGISTRATION.COUNTRY_CODE, idx_employer_registration_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_registration_on_country_code on portal.EMPLOYER_REGISTRATION(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_REGISTRATION.PREVIOUS_EMPLOYER_CODE, idx_employer_registration_on_previous_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_registration_on_previous_employer_code on portal.EMPLOYER_REGISTRATION(PREVIOUS_EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_REGISTRATION.EMPLOYER_CODE, idx_employer_registration_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_registration_on_employer_code on portal.EMPLOYER_REGISTRATION(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_REGISTRATION.DISTRICT_CODE, idx_employer_registration_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_registration_on_district_code on portal.EMPLOYER_REGISTRATION(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index FW_AMENDMENT.TRANS_ID, idx_fw_amendment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_amendment_on_trans_id on portal.FW_AMENDMENT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_AMENDMENT.COUNTRY_CODE, idx_fw_amendment_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_amendment_on_country_code on portal.FW_AMENDMENT(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_AMENDMENT.COUNTRY_CODE_NEW, idx_fw_amendment_on_country_code_new', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_amendment_on_country_code_new on portal.FW_AMENDMENT(COUNTRY_CODE_NEW);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_AMENDMENT.WORKER_CODE, idx_fw_amendment_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_amendment_on_worker_code on portal.FW_AMENDMENT(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index INSURANCE_PURCHASE.EMPLOYER_CODE, idx_insurance_purchase_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_insurance_purchase_on_employer_code on portal.INSURANCE_PURCHASE(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT.EMPCODE, idx_payment_on_empcode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_on_empcode on portal.PAYMENT(EMPCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT.BANK_CODE, idx_payment_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_on_bank_code on portal.PAYMENT(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT.ZONE_CODE, idx_payment_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_on_zone_code on portal.PAYMENT(ZONE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_LOG.EMPCODE, idx_payment_log_on_empcode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_log_on_empcode on portal.PAYMENT_LOG(EMPCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;





begin
    insert into copy_logs (description, begin_at) values ('start index USER_MASTER.USERCODE, idx_user_master_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_user_master_on_usercode on portal.USER_MASTER(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index USER_MASTER.STATE_CODE, idx_user_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_user_master_on_state_code on portal.USER_MASTER(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index USER_MASTER.POST_CODE, idx_user_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_user_master_on_post_code on portal.USER_MASTER(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index USER_MASTER.COUNTRY_CODE, idx_user_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_user_master_on_country_code on portal.USER_MASTER(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index USER_MASTER.DISTRICT_CODE, idx_user_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_user_master_on_district_code on portal.USER_MASTER(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_LIST.COUNTRY_CODE, idx_worker_list_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_list_on_country_code on portal.WORKER_LIST(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_LIST.EMPLOYER_CODE, idx_worker_list_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_list_on_employer_code on portal.WORKER_LIST(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_LIST.WORKER_CODE, idx_worker_list_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_list_on_worker_code on portal.WORKER_LIST(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_LIST.IMM_NERS_REASON_CODE, idx_worker_list_on_imm_ners_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_list_on_imm_ners_reason_code on portal.WORKER_LIST(IMM_NERS_REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_LIST.IMM_EMPLOYER_POSTCODE, idx_worker_list_on_imm_employer_postcode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_list_on_imm_employer_postcode on portal.WORKER_LIST(IMM_EMPLOYER_POSTCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_LOG.DOCTOR_CODE, idx_worker_log_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_log_on_doctor_code on portal.WORKER_LOG(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_REGISTRATION.TRANS_ID, idx_worker_registration_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_registration_on_trans_id on portal.WORKER_REGISTRATION(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_REGISTRATION.COUNTRY_CODE, idx_worker_registration_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_registration_on_country_code on portal.WORKER_REGISTRATION(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_REGISTRATION.EMPLOYER_CODE, idx_worker_registration_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_registration_on_employer_code on portal.WORKER_REGISTRATION(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_REGISTRATION.WORKER_CODE, idx_worker_registration_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_registration_on_worker_code on portal.WORKER_REGISTRATION(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_REGISTRATION.DOCTOR_CODE, idx_worker_registration_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_registration_on_doctor_code on portal.WORKER_REGISTRATION(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_REGISTRATION.PREVIOUS_WORKER_CODE, idx_worker_registration_on_previous_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_registration_on_previous_worker_code on portal.WORKER_REGISTRATION(PREVIOUS_WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_REGISTRATION.IMM_NERS_REASON_CODE, idx_worker_registration_on_imm_ners_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_registration_on_imm_ners_reason_code on portal.WORKER_REGISTRATION(IMM_NERS_REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_REGISTRATION.IMM_EMPLOYER_POSTCODE, idx_worker_registration_on_imm_employer_postcode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_registration_on_imm_employer_postcode on portal.WORKER_REGISTRATION(IMM_EMPLOYER_POSTCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_REGISTRATION_HDR.EMPLOYER_CODE, idx_worker_registration_hdr_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_registration_hdr_on_employer_code on portal.WORKER_REGISTRATION_HDR(EMPLOYER_CODE);

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
