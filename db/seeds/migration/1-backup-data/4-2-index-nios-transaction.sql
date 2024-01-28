
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_item bigint;
begin
    insert into copy_logs (description, begin_at) values ('start index nios transaction process', clock_timestamp()) returning id into v_copy_log_id_process;

begin
    insert into copy_logs (description, begin_at) values ('start index ADMINUSERS.USERCODE, idx_adminusers_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_adminusers_on_usercode on nios.ADMINUSERS(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index ADVANCE_PAYMENT.BANK_CODE, idx_advance_payment_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_advance_payment_on_bank_code on nios.ADVANCE_PAYMENT(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ADVANCE_PAYMENT.CONTACT_DISTRICT_CODE, idx_advance_payment_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_advance_payment_on_contact_district_code on nios.ADVANCE_PAYMENT(CONTACT_DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ADVANCE_PAYMENT.CONTACT_POST_CODE, idx_advance_payment_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_advance_payment_on_contact_post_code on nios.ADVANCE_PAYMENT(CONTACT_POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ADVANCE_PAYMENT.CONTACT_STATE_CODE, idx_advance_payment_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_advance_payment_on_contact_state_code on nios.ADVANCE_PAYMENT(CONTACT_STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ADVANCE_PAYMENT.ZONE_CODE, idx_advance_payment_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_advance_payment_on_zone_code on nios.ADVANCE_PAYMENT(ZONE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ADVANCE_PAYMENT.BRANCH_CODE, idx_advance_payment_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_advance_payment_on_branch_code on nios.ADVANCE_PAYMENT(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index ADVANCE_PAYMENT_ACCOUNT.BRANCH_CODE, idx_advance_payment_account_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_advance_payment_account_on_branch_code on nios.ADVANCE_PAYMENT_ACCOUNT(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ADVANCE_PAYMENT_ACCOUNT.EMPLOYER_CODE, idx_advance_payment_account_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_advance_payment_account_on_employer_code on nios.ADVANCE_PAYMENT_ACCOUNT(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index ADVANCE_PAYMENT_GROUP.DISTRICT_CODE, idx_advance_payment_group_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_advance_payment_group_on_district_code on nios.ADVANCE_PAYMENT_GROUP(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ADVANCE_PAYMENT_GROUP.GROUP_CODE, idx_advance_payment_group_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_advance_payment_group_on_group_code on nios.ADVANCE_PAYMENT_GROUP(GROUP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ADVANCE_PAYMENT_GROUP.POSTCODE, idx_advance_payment_group_on_postcode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_advance_payment_group_on_postcode on nios.ADVANCE_PAYMENT_GROUP(POSTCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ADVANCE_PAYMENT_GROUP.STATE_CODE, idx_advance_payment_group_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_advance_payment_group_on_state_code on nios.ADVANCE_PAYMENT_GROUP(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index APPEAL_FW_APPEAL.TRANS_ID, idx_appeal_fw_appeal_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_appeal_fw_appeal_on_trans_id on nios.APPEAL_FW_APPEAL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index APPEAL_FW_APPEAL.APPEAL_DOCTOR_CODE, idx_appeal_fw_appeal_on_appeal_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_appeal_fw_appeal_on_appeal_doctor_code on nios.APPEAL_FW_APPEAL(APPEAL_DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index APPEAL_PAYMENT.WORKER_CODE, idx_appeal_payment_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_appeal_payment_on_worker_code on nios.APPEAL_PAYMENT(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index APPEAL_PAYMENT.LAB_CODE, idx_appeal_payment_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_appeal_payment_on_lab_code on nios.APPEAL_PAYMENT(LAB_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index APPEAL_TODOLIST_MAP.PARAMETER_CODE, idx_appeal_todolist_map_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_appeal_todolist_map_on_parameter_code on nios.APPEAL_TODOLIST_MAP(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index AP_INVOICE_GENERATED.TRANS_ID, idx_ap_invoice_generated_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_ap_invoice_generated_on_trans_id on nios.AP_INVOICE_GENERATED(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index AP_INVOICE_GENERATED.CREDITOR_CODE, idx_ap_invoice_generated_on_creditor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_ap_invoice_generated_on_creditor_code on nios.AP_INVOICE_GENERATED(CREDITOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index ARCH_FW_COMMENT.TRANS_ID, idx_arch_fw_comment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_arch_fw_comment_on_trans_id on nios.ARCH_FW_COMMENT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ARCH_FW_COMMENT.PARAMETER_CODE, idx_arch_fw_comment_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_arch_fw_comment_on_parameter_code on nios.ARCH_FW_COMMENT(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index ARCH_FW_DETAIL.TRANS_ID, idx_arch_fw_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_arch_fw_detail_on_trans_id on nios.ARCH_FW_DETAIL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ARCH_FW_DETAIL.PARAMETER_CODE, idx_arch_fw_detail_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_arch_fw_detail_on_parameter_code on nios.ARCH_FW_DETAIL(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index ARCH_FW_EXTRA_COMMENTS.TRANS_ID, idx_arch_fw_extra_comments_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_arch_fw_extra_comments_on_trans_id on nios.ARCH_FW_EXTRA_COMMENTS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index ARCH_FW_QUARANTINE_REASON.TRANS_ID, idx_arch_fw_quarantine_reason_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_arch_fw_quarantine_reason_on_trans_id on nios.ARCH_FW_QUARANTINE_REASON(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ARCH_FW_QUARANTINE_REASON.REASON_CODE, idx_arch_fw_quarantine_reason_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_arch_fw_quarantine_reason_on_reason_code on nios.ARCH_FW_QUARANTINE_REASON(REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index ARCH_FW_TRANSACTION.TRANS_ID, idx_arch_fw_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_arch_fw_transaction_on_trans_id on nios.ARCH_FW_TRANSACTION(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ARCH_FW_TRANSACTION.DOCTOR_CODE, idx_arch_fw_transaction_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_arch_fw_transaction_on_doctor_code on nios.ARCH_FW_TRANSACTION(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ARCH_FW_TRANSACTION.EMPLOYER_CODE, idx_arch_fw_transaction_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_arch_fw_transaction_on_employer_code on nios.ARCH_FW_TRANSACTION(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ARCH_FW_TRANSACTION.LABORATORY_CODE, idx_arch_fw_transaction_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_arch_fw_transaction_on_laboratory_code on nios.ARCH_FW_TRANSACTION(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ARCH_FW_TRANSACTION.RADIOLOGIST_CODE, idx_arch_fw_transaction_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_arch_fw_transaction_on_radiologist_code on nios.ARCH_FW_TRANSACTION(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ARCH_FW_TRANSACTION.XRAY_CODE, idx_arch_fw_transaction_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_arch_fw_transaction_on_xray_code on nios.ARCH_FW_TRANSACTION(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index ARCH_FW_TRANSACTION.WORKER_CODE, idx_arch_fw_transaction_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_arch_fw_transaction_on_worker_code on nios.ARCH_FW_TRANSACTION(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index BAD_PAYMENT.BANK_CODE, idx_bad_payment_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_bad_payment_on_bank_code on nios.BAD_PAYMENT(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index BAD_PAYMENT.CONTACT_POST_CODE, idx_bad_payment_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_bad_payment_on_contact_post_code on nios.BAD_PAYMENT(CONTACT_POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index BAD_PAYMENT.CONTACT_STATE_CODE, idx_bad_payment_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_bad_payment_on_contact_state_code on nios.BAD_PAYMENT(CONTACT_STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index BAD_PAYMENT.CONTACT_DISTRICT_CODE, idx_bad_payment_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_bad_payment_on_contact_district_code on nios.BAD_PAYMENT(CONTACT_DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index BANK_DRAFT_EXPIRY.BANK_CODE, idx_bank_draft_expiry_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_bank_draft_expiry_on_bank_code on nios.BANK_DRAFT_EXPIRY(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index BARCODE_TRANSACTION.TRANS_ID, idx_barcode_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_barcode_transaction_on_trans_id on nios.BARCODE_TRANSACTION(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index BARCODE_TRANSACTION.EMPLOYER_CODE, idx_barcode_transaction_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_barcode_transaction_on_employer_code on nios.BARCODE_TRANSACTION(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index BATCHUSERS.USERCODE, idx_batchusers_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_batchusers_on_usercode on nios.BATCHUSERS(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index BRANCHES.BRANCH_CODE, idx_branches_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_branches_on_branch_code on nios.BRANCHES(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index BRANCHES.POST_CODE, idx_branches_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_branches_on_post_code on nios.BRANCHES(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index BRANCHES.BANK_CODE, idx_branches_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_branches_on_bank_code on nios.BRANCHES(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index BRANCH_PRINTERS.BRANCH_CODE, idx_branch_printers_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_branch_printers_on_branch_code on nios.BRANCH_PRINTERS(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index BULLETIN_ACKNOWLEDGE.USERCODE, idx_bulletin_acknowledge_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_bulletin_acknowledge_on_usercode on nios.BULLETIN_ACKNOWLEDGE(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index BULLETIN_TARGET.USERCODE, idx_bulletin_target_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_bulletin_target_on_usercode on nios.BULLETIN_TARGET(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index CNG_WORKER_CLINIC.WORKER_CODE, idx_cng_worker_clinic_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_cng_worker_clinic_on_worker_code on nios.CNG_WORKER_CLINIC(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index CNG_WORKER_CLINIC.COUNTRY_CODE, idx_cng_worker_clinic_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_cng_worker_clinic_on_country_code on nios.CNG_WORKER_CLINIC(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index CNG_WORKER_CLINIC.CLINIC_CODE, idx_cng_worker_clinic_on_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_cng_worker_clinic_on_clinic_code on nios.CNG_WORKER_CLINIC(CLINIC_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index CODE_M.STATE_CODE, idx_code_m_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_code_m_on_state_code on nios.CODE_M(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index CONDITION_MAP.PARAMETER_CODE, idx_condition_map_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_condition_map_on_parameter_code on nios.CONDITION_MAP(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index CONDITION_MAP.OLD_PARAMETER_CODE, idx_condition_map_on_old_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_condition_map_on_old_parameter_code on nios.CONDITION_MAP(OLD_PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index CUSTOMER_COMPLAINT.COMPLAINT_CODE, idx_customer_complaint_on_complaint_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_customer_complaint_on_complaint_code on nios.CUSTOMER_COMPLAINT(COMPLAINT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index CUSTOMER_COMPLAINT.COMPLAINT_AGAINST_CODE, idx_customer_complaint_on_complaint_against_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_customer_complaint_on_complaint_against_code on nios.CUSTOMER_COMPLAINT(COMPLAINT_AGAINST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DELAY_TRANS.DOCTOR_CODE, idx_delay_trans_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_delay_trans_on_doctor_code on nios.DELAY_TRANS(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DELAY_TRANS.WORKER_CODE, idx_delay_trans_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_delay_trans_on_worker_code on nios.DELAY_TRANS(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DIFF_RH.BRANCH_CODE, idx_diff_rh_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_diff_rh_on_branch_code on nios.DIFF_RH(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DISCRP_TAB.FCODE, idx_discrp_tab_on_fcode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_discrp_tab_on_fcode on nios.DISCRP_TAB(FCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DISCRP_TAB.ECODE, idx_discrp_tab_on_ecode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_discrp_tab_on_ecode on nios.DISCRP_TAB(ECODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DISCRP_TAB.A_FCODE, idx_discrp_tab_on_a_fcode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_discrp_tab_on_a_fcode on nios.DISCRP_TAB(A_FCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DISTRICT_MAP.DISTRICT_MAP_CODE, idx_district_map_on_district_map_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_district_map_on_district_map_code on nios.DISTRICT_MAP(DISTRICT_MAP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DISTRICT_OFFICE.OFFICE_CODE, idx_district_office_on_office_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_district_office_on_office_code on nios.DISTRICT_OFFICE(OFFICE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DISTRICT_OFFICE.POST_CODE, idx_district_office_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_district_office_on_post_code on nios.DISTRICT_OFFICE(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DISTRICT_OFFICE.DISTRICT_CODE, idx_district_office_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_district_office_on_district_code on nios.DISTRICT_OFFICE(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DISTRICT_OFFICE.STATE_CODE, idx_district_office_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_district_office_on_state_code on nios.DISTRICT_OFFICE(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DISTRICT_OFFICE.STATUS_CODE, idx_district_office_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_district_office_on_status_code on nios.DISTRICT_OFFICE(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_CHANGE_REQUEST.DOCTOR_CODE, idx_doctor_change_request_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_change_request_on_doctor_code on nios.DOCTOR_CHANGE_REQUEST(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_LOAD_6P.DOCTOR_CODE, idx_doctor_load_6p_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_load_6p_on_doctor_code on nios.DOCTOR_LOAD_6P(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_LOAD_6P.DIST_CODE, idx_doctor_load_6p_on_dist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_load_6p_on_dist_code on nios.DOCTOR_LOAD_6P(DIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_LOAD_6P.STATE_CODE, idx_doctor_load_6p_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_load_6p_on_state_code on nios.DOCTOR_LOAD_6P(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_OPTHOUR.USERCODE, idx_doctor_opthour_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_opthour_on_usercode on nios.DOCTOR_OPTHOUR(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_QUOTA_TRANS.DOCTOR_CODE, idx_doctor_quota_trans_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_quota_trans_on_doctor_code on nios.DOCTOR_QUOTA_TRANS(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_REGISTRATION.POST_CODE, idx_doctor_registration_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_registration_on_post_code on nios.DOCTOR_REGISTRATION(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_REGISTRATION.STATE_CODE, idx_doctor_registration_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_registration_on_state_code on nios.DOCTOR_REGISTRATION(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_REGISTRATION.DISTRICT_CODE, idx_doctor_registration_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_registration_on_district_code on nios.DOCTOR_REGISTRATION(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_REGISTRATION.COUNTRY_CODE, idx_doctor_registration_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_registration_on_country_code on nios.DOCTOR_REGISTRATION(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_REGISTRATION.STATUS_CODE, idx_doctor_registration_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_registration_on_status_code on nios.DOCTOR_REGISTRATION(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_REGISTRATION.PREFER_XRAY_CODE, idx_doctor_registration_on_prefer_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_registration_on_prefer_xray_code on nios.DOCTOR_REGISTRATION(PREFER_XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_REGISTRATION.RCM_XRAY_CODE1, idx_doctor_registration_on_rcm_xray_code1', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_registration_on_rcm_xray_code1 on nios.DOCTOR_REGISTRATION(RCM_XRAY_CODE1);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_REGISTRATION.RCM_XRAY_CODE2, idx_doctor_registration_on_rcm_xray_code2', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_registration_on_rcm_xray_code2 on nios.DOCTOR_REGISTRATION(RCM_XRAY_CODE2);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOCTOR_REGISTRATION.RCM_XRAY_CODE3, idx_doctor_registration_on_rcm_xray_code3', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doctor_registration_on_rcm_xray_code3 on nios.DOCTOR_REGISTRATION(RCM_XRAY_CODE3);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index DOC_COMPARE.DOCTOR_CODE, idx_doc_compare_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doc_compare_on_doctor_code on nios.DOC_COMPARE(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOC_COMPARE.OLD_RADIOLOGIST_CODE, idx_doc_compare_on_old_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doc_compare_on_old_radiologist_code on nios.DOC_COMPARE(OLD_RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOC_COMPARE.OLD_XRAY_CODE, idx_doc_compare_on_old_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doc_compare_on_old_xray_code on nios.DOC_COMPARE(OLD_XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOC_COMPARE.OLD_LABORATORY_CODE, idx_doc_compare_on_old_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doc_compare_on_old_laboratory_code on nios.DOC_COMPARE(OLD_LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOC_COMPARE.NEW_RADIOLOGIST_CODE, idx_doc_compare_on_new_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doc_compare_on_new_radiologist_code on nios.DOC_COMPARE(NEW_RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOC_COMPARE.NEW_XRAY_CODE, idx_doc_compare_on_new_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doc_compare_on_new_xray_code on nios.DOC_COMPARE(NEW_XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DOC_COMPARE.NEW_LABORATORY_CODE, idx_doc_compare_on_new_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doc_compare_on_new_laboratory_code on nios.DOC_COMPARE(NEW_LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DOC_LAB_ALLOCATION.DOCTOR_CODE, idx_doc_lab_allocation_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doc_lab_allocation_on_doctor_code on nios.DOC_LAB_ALLOCATION(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DOC_QUOTA_ALLOCATION.DOCTOR_CODE, idx_doc_quota_allocation_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doc_quota_allocation_on_doctor_code on nios.DOC_QUOTA_ALLOCATION(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DOC_STATUS.DOCTOR_CODE, idx_doc_status_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doc_status_on_doctor_code on nios.DOC_STATUS(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DOC_XRAY_ALLOCATION.DOCTOR_CODE, idx_doc_xray_allocation_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_doc_xray_allocation_on_doctor_code on nios.DOC_XRAY_ALLOCATION(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DRAFT_ALLOCATION.EMPLOYER_CODE, idx_draft_allocation_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_draft_allocation_on_employer_code on nios.DRAFT_ALLOCATION(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DRAFT_USAGE.TRANS_ID, idx_draft_usage_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_draft_usage_on_trans_id on nios.DRAFT_USAGE(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DRAFT_USAGE.EMPLOYER_CODE, idx_draft_usage_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_draft_usage_on_employer_code on nios.DRAFT_USAGE(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DRAFT_USAGE.WORKER_CODE, idx_draft_usage_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_draft_usage_on_worker_code on nios.DRAFT_USAGE(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DRAFT_USAGE.BRANCH_CODE, idx_draft_usage_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_draft_usage_on_branch_code on nios.DRAFT_USAGE(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index DXBASKET.TRANS_ID, idx_dxbasket_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxbasket_on_trans_id on nios.DXBASKET(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DXBASKET.XRAY_CODE, idx_dxbasket_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxbasket_on_xray_code on nios.DXBASKET(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DXFILM_AUDIT.TRANS_ID, idx_dxfilm_audit_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxfilm_audit_on_trans_id on nios.DXFILM_AUDIT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DXFILM_AUDIT.WORKER_CODE, idx_dxfilm_audit_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxfilm_audit_on_worker_code on nios.DXFILM_AUDIT(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DXFILM_MOVEMENT.TRANS_ID, idx_dxfilm_movement_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxfilm_movement_on_trans_id on nios.DXFILM_MOVEMENT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DXPCR_AUDIT_COMMENT.PARAMETER_CODE, idx_dxpcr_audit_comment_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxpcr_audit_comment_on_parameter_code on nios.DXPCR_AUDIT_COMMENT(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DXPCR_AUDIT_DETAIL.PARAMETER_CODE, idx_dxpcr_audit_detail_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxpcr_audit_detail_on_parameter_code on nios.DXPCR_AUDIT_DETAIL(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DXPCR_AUDIT_FILM.TRANS_ID, idx_dxpcr_audit_film_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxpcr_audit_film_on_trans_id on nios.DXPCR_AUDIT_FILM(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DXPCR_AUDIT_FILM.PCR_CODE, idx_dxpcr_audit_film_on_pcr_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxpcr_audit_film_on_pcr_code on nios.DXPCR_AUDIT_FILM(PCR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DXPCR_AUDIT_FILM.WORKER_CODE, idx_dxpcr_audit_film_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxpcr_audit_film_on_worker_code on nios.DXPCR_AUDIT_FILM(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DXPCR_AUDIT_FILM.XRAY_CODE, idx_dxpcr_audit_film_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxpcr_audit_film_on_xray_code on nios.DXPCR_AUDIT_FILM(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DXPCR_POOL.TRANS_ID, idx_dxpcr_pool_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxpcr_pool_on_trans_id on nios.DXPCR_POOL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DXPCR_POOL.PCR_CODE, idx_dxpcr_pool_on_pcr_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxpcr_pool_on_pcr_code on nios.DXPCR_POOL(PCR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DXPCR_POOL.RADIOLOGIST_CODE, idx_dxpcr_pool_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxpcr_pool_on_radiologist_code on nios.DXPCR_POOL(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index DXREVIEW_FILM.TRANS_ID, idx_dxreview_film_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxreview_film_on_trans_id on nios.DXREVIEW_FILM(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DXREVIEW_FILM.WORKER_CODE, idx_dxreview_film_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxreview_film_on_worker_code on nios.DXREVIEW_FILM(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DXREVIEW_FILM.XRAY_CODE, idx_dxreview_film_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxreview_film_on_xray_code on nios.DXREVIEW_FILM(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index DXREVIEW_FILM_DETAIL.PARAMETER_CODE, idx_dxreview_film_detail_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxreview_film_detail_on_parameter_code on nios.DXREVIEW_FILM_DETAIL(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DXREVIEW_FILM_IDENTICAL.TRANS_ID, idx_dxreview_film_identical_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxreview_film_identical_on_trans_id on nios.DXREVIEW_FILM_IDENTICAL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DXREVIEW_FILM_IDENTICAL.WORKER_CODE, idx_dxreview_film_identical_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxreview_film_identical_on_worker_code on nios.DXREVIEW_FILM_IDENTICAL(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DXXRAY_AUDIT.TRANS_ID, idx_dxxray_audit_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxxray_audit_on_trans_id on nios.DXXRAY_AUDIT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index DXXRAY_AUDIT.WORKER_CODE, idx_dxxray_audit_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dxxray_audit_on_worker_code on nios.DXXRAY_AUDIT(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index DX_PAYBLOCK.DOC_XRAY_CODE, idx_dx_payblock_on_doc_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_dx_payblock_on_doc_xray_code on nios.DX_PAYBLOCK(DOC_XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_ACCOUNT.TRANS_ID, idx_employer_account_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_account_on_trans_id on nios.EMPLOYER_ACCOUNT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_ACCOUNT.EMPLOYER_CODE, idx_employer_account_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_account_on_employer_code on nios.EMPLOYER_ACCOUNT(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_ACCOUNT.WORKER_CODE, idx_employer_account_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_account_on_worker_code on nios.EMPLOYER_ACCOUNT(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_ACCOUNT.BRANCH_CODE, idx_employer_account_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_account_on_branch_code on nios.EMPLOYER_ACCOUNT(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_ALLOC_DETAIL.EMPLOYER_CODE, idx_employer_alloc_detail_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_alloc_detail_on_employer_code on nios.EMPLOYER_ALLOC_DETAIL(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_CN.BRANCH_CODE, idx_employer_cn_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_cn_on_branch_code on nios.EMPLOYER_CN(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_CN.EMPLOYER_CODE, idx_employer_cn_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_cn_on_employer_code on nios.EMPLOYER_CN(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_NOTIFICATION.TRANS_ID, idx_employer_notification_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_notification_on_trans_id on nios.EMPLOYER_NOTIFICATION(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_NOTIFICATION.WORKER_CODE, idx_employer_notification_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_notification_on_worker_code on nios.EMPLOYER_NOTIFICATION(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_NOTIFICATION.DOCTOR_CODE, idx_employer_notification_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_notification_on_doctor_code on nios.EMPLOYER_NOTIFICATION(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_NOTIFICATION.BRANCH_CODE, idx_employer_notification_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_notification_on_branch_code on nios.EMPLOYER_NOTIFICATION(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_NOTIFICATION.STATE_CODE, idx_employer_notification_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_notification_on_state_code on nios.EMPLOYER_NOTIFICATION(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_NOTIFICATION.EMPLOYER_CODE, idx_employer_notification_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_notification_on_employer_code on nios.EMPLOYER_NOTIFICATION(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index EMPLOYER_NOTIFICATION_COUNT.EMPLOYER_CODE, idx_employer_notification_count_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_employer_notification_count_on_employer_code on nios.EMPLOYER_NOTIFICATION_COUNT(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index FINANCE_PAYMENT.TRANS_ID, idx_finance_payment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_finance_payment_on_trans_id on nios.FINANCE_PAYMENT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FINANCE_PAYMENT.WORKER_CODE, idx_finance_payment_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_finance_payment_on_worker_code on nios.FINANCE_PAYMENT(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FIN_BATCH_TRANS.TRANS_ID, idx_fin_batch_trans_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fin_batch_trans_on_trans_id on nios.FIN_BATCH_TRANS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FOM_DOCTOR_QUOTA_BKP.DOCTOR_CODE, idx_fom_doctor_quota_bkp_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_doctor_quota_bkp_on_doctor_code on nios.FOM_DOCTOR_QUOTA_BKP(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_DOCTOR_QUOTA_BKP.LABORATORY_CODE, idx_fom_doctor_quota_bkp_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_doctor_quota_bkp_on_laboratory_code on nios.FOM_DOCTOR_QUOTA_BKP(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_DOCTOR_QUOTA_BKP.XRAY_CODE, idx_fom_doctor_quota_bkp_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_doctor_quota_bkp_on_xray_code on nios.FOM_DOCTOR_QUOTA_BKP(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_DOCTOR_QUOTA_BKP.STATUS_CODE, idx_fom_doctor_quota_bkp_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_doctor_quota_bkp_on_status_code on nios.FOM_DOCTOR_QUOTA_BKP(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FOM_LAB_PAYMENT_MISSED.TRANS_ID, idx_fom_lab_payment_missed_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_lab_payment_missed_on_trans_id on nios.FOM_LAB_PAYMENT_MISSED(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_LAB_PAYMENT_MISSED.LAB_CODE, idx_fom_lab_payment_missed_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_lab_payment_missed_on_lab_code on nios.FOM_LAB_PAYMENT_MISSED(LAB_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_LAB_PAYMENT_MISSED.WORKER_CODE, idx_fom_lab_payment_missed_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_lab_payment_missed_on_worker_code on nios.FOM_LAB_PAYMENT_MISSED(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FOM_LAB_UNPAID.L_LAB_CODE, idx_fom_lab_unpaid_on_l_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_lab_unpaid_on_l_lab_code on nios.FOM_LAB_UNPAID(L_LAB_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_LAB_UNPAID.L_WORKER_CODE, idx_fom_lab_unpaid_on_l_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_lab_unpaid_on_l_worker_code on nios.FOM_LAB_UNPAID(L_WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_LAB_UNPAID.F_LAB_CODE, idx_fom_lab_unpaid_on_f_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_lab_unpaid_on_f_lab_code on nios.FOM_LAB_UNPAID(F_LAB_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PARAMS.PARAM_CODE, idx_fom_params_on_param_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_params_on_param_code on nios.FOM_PARAMS(PARAM_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PAYMENT_STATUS_MISSED.TRANS_ID, idx_fom_payment_status_missed_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_payment_status_missed_on_trans_id on nios.FOM_PAYMENT_STATUS_MISSED(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PAYMENT_STATUS_MISSED.DOCTOR_CODE, idx_fom_payment_status_missed_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_payment_status_missed_on_doctor_code on nios.FOM_PAYMENT_STATUS_MISSED(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PAYMENT_STATUS_MISSED.XRAY_CODE, idx_fom_payment_status_missed_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_payment_status_missed_on_xray_code on nios.FOM_PAYMENT_STATUS_MISSED(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PAYMENT_STATUS_MISSED.LAB_CODE, idx_fom_payment_status_missed_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_payment_status_missed_on_lab_code on nios.FOM_PAYMENT_STATUS_MISSED(LAB_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PAY_TRANSACTION.TRANS_ID, idx_fom_pay_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_pay_transaction_on_trans_id on nios.FOM_PAY_TRANSACTION(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PAY_TRANSACTION.WORKER_CODE, idx_fom_pay_transaction_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_pay_transaction_on_worker_code on nios.FOM_PAY_TRANSACTION(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PAY_TRANSACTION.BRANCH_CODE, idx_fom_pay_transaction_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_pay_transaction_on_branch_code on nios.FOM_PAY_TRANSACTION(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PAY_TRANSACTION.SP_CODE, idx_fom_pay_transaction_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_pay_transaction_on_sp_code on nios.FOM_PAY_TRANSACTION(SP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PAY_TRANSACTION.SP_STATE_CODE, idx_fom_pay_transaction_on_sp_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_pay_transaction_on_sp_state_code on nios.FOM_PAY_TRANSACTION(SP_STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PAY_TRANSACTION.GST_CODE, idx_fom_pay_transaction_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_pay_transaction_on_gst_code on nios.FOM_PAY_TRANSACTION(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PAY_TRANSACTION_MISSED.TRANS_ID, idx_fom_pay_transaction_missed_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_pay_transaction_missed_on_trans_id on nios.FOM_PAY_TRANSACTION_MISSED(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PAY_TRANSACTION_MISSED.WORKER_CODE, idx_fom_pay_transaction_missed_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_pay_transaction_missed_on_worker_code on nios.FOM_PAY_TRANSACTION_MISSED(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PAY_TRANSACTION_MISSED.DOCTOR_CODE, idx_fom_pay_transaction_missed_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_pay_transaction_missed_on_doctor_code on nios.FOM_PAY_TRANSACTION_MISSED(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_PAY_TRANSACTION_MISSED.XRAY_CODE, idx_fom_pay_transaction_missed_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_pay_transaction_missed_on_xray_code on nios.FOM_PAY_TRANSACTION_MISSED(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FOM_SPECIAL_PAYMENT.TRANS_ID, idx_fom_special_payment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_special_payment_on_trans_id on nios.FOM_SPECIAL_PAYMENT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index FOM_TMP_JIM.TRANS_ID, idx_fom_tmp_jim_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_tmp_jim_on_trans_id on nios.FOM_TMP_JIM(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index FOM_XRAY_NOT_DONE_MISSED.TRANS_ID, idx_fom_xray_not_done_missed_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_xray_not_done_missed_on_trans_id on nios.FOM_XRAY_NOT_DONE_MISSED(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_XRAY_NOT_DONE_MISSED.XRAY_CODE, idx_fom_xray_not_done_missed_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_xray_not_done_missed_on_xray_code on nios.FOM_XRAY_NOT_DONE_MISSED(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_XRAY_NOT_DONE_MISSED.WORKER_CODE, idx_fom_xray_not_done_missed_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_xray_not_done_missed_on_worker_code on nios.FOM_XRAY_NOT_DONE_MISSED(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FOM_XRAY_NOT_RECEIVE.TRANS_ID, idx_fom_xray_not_receive_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_xray_not_receive_on_trans_id on nios.FOM_XRAY_NOT_RECEIVE(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_XRAY_NOT_RECEIVE.XRAY_CODE, idx_fom_xray_not_receive_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_xray_not_receive_on_xray_code on nios.FOM_XRAY_NOT_RECEIVE(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOM_XRAY_NOT_RECEIVE.WORKER_CODE, idx_fom_xray_not_receive_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_xray_not_receive_on_worker_code on nios.FOM_XRAY_NOT_RECEIVE(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FOM_XRAY_USE_SWAST.XRAY_CODE, idx_fom_xray_use_swast_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fom_xray_use_swast_on_xray_code on nios.FOM_XRAY_USE_SWAST(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_WORKER_BIODATA.TRANS_ID, idx_foreign_worker_biodata_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_worker_biodata_on_trans_id on nios.FOREIGN_WORKER_BIODATA(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_WORKER_BIODATA.WORKER_CODE, idx_foreign_worker_biodata_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_worker_biodata_on_worker_code on nios.FOREIGN_WORKER_BIODATA(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_WORKER_BIODATA.NERS_REASON_CODE, idx_foreign_worker_biodata_on_ners_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_worker_biodata_on_ners_reason_code on nios.FOREIGN_WORKER_BIODATA(NERS_REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FOREIGN_WORKER_BIODATA.EMPLOYER_POSTCODE, idx_foreign_worker_biodata_on_employer_postcode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_foreign_worker_biodata_on_employer_postcode on nios.FOREIGN_WORKER_BIODATA(EMPLOYER_POSTCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWM_CHANGE_TRANS.TRANS_ID, idx_fwm_change_trans_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwm_change_trans_on_trans_id on nios.FWM_CHANGE_TRANS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FWM_CHANGE_TRANS.REASON_CODE, idx_fwm_change_trans_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwm_change_trans_on_reason_code on nios.FWM_CHANGE_TRANS(REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWM_CHANGE_TRANS_ORG.TRANS_ID, idx_fwm_change_trans_org_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwm_change_trans_org_on_trans_id on nios.FWM_CHANGE_TRANS_ORG(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FWM_CHANGE_TRANS_ORG.REASON_CODE, idx_fwm_change_trans_org_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwm_change_trans_org_on_reason_code on nios.FWM_CHANGE_TRANS_ORG(REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWM_MODULECODE.MODULE_CODE, idx_fwm_modulecode_on_module_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwm_modulecode_on_module_code on nios.FWM_MODULECODE(MODULE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWM_MON.WORKER_CODE, idx_fwm_mon_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwm_mon_on_worker_code on nios.FWM_MON(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWT_CHANGE_CLINIC_APPROVAL.TRANS_ID, idx_fwt_change_clinic_approval_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_change_clinic_approval_on_trans_id on nios.FWT_CHANGE_CLINIC_APPROVAL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FWT_CHANGE_CLINIC_APPROVAL.WORKER_CODE, idx_fwt_change_clinic_approval_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_change_clinic_approval_on_worker_code on nios.FWT_CHANGE_CLINIC_APPROVAL(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FWT_CHANGE_CLINIC_APPROVAL.DOCTOR_CODE, idx_fwt_change_clinic_approval_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_change_clinic_approval_on_doctor_code on nios.FWT_CHANGE_CLINIC_APPROVAL(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FWT_CHANGE_CLINIC_APPROVAL.BRANCH_CODE, idx_fwt_change_clinic_approval_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_change_clinic_approval_on_branch_code on nios.FWT_CHANGE_CLINIC_APPROVAL(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWT_CHANGE_JOURNAL.TRANS_ID, idx_fwt_change_journal_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_change_journal_on_trans_id on nios.FWT_CHANGE_JOURNAL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWT_CHANGE_JOURNAL_DETAIL.OLD_CODE, idx_fwt_change_journal_detail_on_old_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_change_journal_detail_on_old_code on nios.FWT_CHANGE_JOURNAL_DETAIL(OLD_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FWT_CHANGE_JOURNAL_DETAIL.NEW_CODE, idx_fwt_change_journal_detail_on_new_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_change_journal_detail_on_new_code on nios.FWT_CHANGE_JOURNAL_DETAIL(NEW_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWT_DEFERRED.TRANS_ID, idx_fwt_deferred_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_deferred_on_trans_id on nios.FWT_DEFERRED(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWT_EXAMDATE_CHANGE_TRANS.TRANS_ID, idx_fwt_examdate_change_trans_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_examdate_change_trans_on_trans_id on nios.FWT_EXAMDATE_CHANGE_TRANS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWT_REGMED.TRANS_ID, idx_fwt_regmed_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_regmed_on_trans_id on nios.FWT_REGMED(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FWT_REGMED.WORKER_CODE, idx_fwt_regmed_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_regmed_on_worker_code on nios.FWT_REGMED(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWT_REGMED_DELTA.TRANS_ID, idx_fwt_regmed_delta_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_regmed_delta_on_trans_id on nios.FWT_REGMED_DELTA(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FWT_REGMED_DELTA.WORKER_CODE, idx_fwt_regmed_delta_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_regmed_delta_on_worker_code on nios.FWT_REGMED_DELTA(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWT_SHADOW.TRANS_ID, idx_fwt_shadow_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_shadow_on_trans_id on nios.FWT_SHADOW(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FWT_SHADOW.XRAY_CODE, idx_fwt_shadow_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_shadow_on_xray_code on nios.FWT_SHADOW(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FWT_SHADOW.RADIOLOGIST_CODE, idx_fwt_shadow_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_shadow_on_radiologist_code on nios.FWT_SHADOW(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWT_UPDATE_TCUPI.TRANS_ID, idx_fwt_update_tcupi_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_update_tcupi_on_trans_id on nios.FWT_UPDATE_TCUPI(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FWT_UPDATE_TCUPI.WORKER_CODE, idx_fwt_update_tcupi_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_update_tcupi_on_worker_code on nios.FWT_UPDATE_TCUPI(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FWT_XRAY_UNMATCH.TRANS_ID, idx_fwt_xray_unmatch_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_xray_unmatch_on_trans_id on nios.FWT_XRAY_UNMATCH(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FWT_XRAY_UNMATCH.XRAY_CODE, idx_fwt_xray_unmatch_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fwt_xray_unmatch_on_xray_code on nios.FWT_XRAY_UNMATCH(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_APPEAL.TRANS_ID, idx_fw_appeal_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_appeal_on_trans_id on nios.FW_APPEAL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_APPEAL.APPEAL_DOCTOR_CODE, idx_fw_appeal_on_appeal_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_appeal_on_appeal_doctor_code on nios.FW_APPEAL(APPEAL_DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index FW_APPEAL_DOC_CHANGE.OLD_DOCTOR_CODE, idx_fw_appeal_doc_change_on_old_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_appeal_doc_change_on_old_doctor_code on nios.FW_APPEAL_DOC_CHANGE(OLD_DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_APPEAL_DOC_CHANGE.NEW_DOCTOR_CODE, idx_fw_appeal_doc_change_on_new_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_appeal_doc_change_on_new_doctor_code on nios.FW_APPEAL_DOC_CHANGE(NEW_DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index FW_APPEAL_PASSFAIL_REASON.APPEAL_PARAM_CODE, idx_fw_appeal_passfail_reason_on_appeal_param_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_appeal_passfail_reason_on_appeal_param_code on nios.FW_APPEAL_PASSFAIL_REASON(APPEAL_PARAM_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_APPEAL_PASSFAIL_REASON.REASON_CODE, idx_fw_appeal_passfail_reason_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_appeal_passfail_reason_on_reason_code on nios.FW_APPEAL_PASSFAIL_REASON(REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_APPEAL_TODOLIST.PARAMETER_CODE, idx_fw_appeal_todolist_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_appeal_todolist_on_parameter_code on nios.FW_APPEAL_TODOLIST(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_APPEAL_UNFIT_DETAILS.MERTS_PARAM_CODE, idx_fw_appeal_unfit_details_on_merts_param_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_appeal_unfit_details_on_merts_param_code on nios.FW_APPEAL_UNFIT_DETAILS(MERTS_PARAM_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_APPEAL_UNFIT_DETAILS.APPEAL_PARAM_CODE, idx_fw_appeal_unfit_details_on_appeal_param_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_appeal_unfit_details_on_appeal_param_code on nios.FW_APPEAL_UNFIT_DETAILS(APPEAL_PARAM_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_APPEAL_UNFIT_DETAILS.REASON_CODE, idx_fw_appeal_unfit_details_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_appeal_unfit_details_on_reason_code on nios.FW_APPEAL_UNFIT_DETAILS(REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_BIODATA_REENROLMENT.WORKER_CODE, idx_fw_biodata_reenrolment_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_biodata_reenrolment_on_worker_code on nios.FW_BIODATA_REENROLMENT(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_BIODATA_REENROLMENT.SP_CODE, idx_fw_biodata_reenrolment_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_biodata_reenrolment_on_sp_code on nios.FW_BIODATA_REENROLMENT(SP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_BLOCK.WORKER_CODE, idx_fw_block_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_block_on_worker_code on nios.FW_BLOCK(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_BLOCK.EMPLOYER_CODE, idx_fw_block_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_block_on_employer_code on nios.FW_BLOCK(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_CHANGE_TRANS.TRANS_ID, idx_fw_change_trans_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_change_trans_on_trans_id on nios.FW_CHANGE_TRANS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_CHANGE_TRANS.WORKER_CODE, idx_fw_change_trans_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_change_trans_on_worker_code on nios.FW_CHANGE_TRANS(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_COMMENT.TRANS_ID, idx_fw_comment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_comment_on_trans_id on nios.FW_COMMENT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_COMMENT.PARAMETER_CODE, idx_fw_comment_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_comment_on_parameter_code on nios.FW_COMMENT(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_CRITICAL_INFO.WORKER_CODE, idx_fw_critical_info_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_critical_info_on_worker_code on nios.FW_CRITICAL_INFO(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_CRITICAL_INFO.BRANCH_CODE, idx_fw_critical_info_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_critical_info_on_branch_code on nios.FW_CRITICAL_INFO(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index FW_DETAIL.TRANS_ID, idx_fw_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_detail_on_trans_id on nios.FW_DETAIL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_DETAIL.PARAMETER_CODE, idx_fw_detail_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_detail_on_parameter_code on nios.FW_DETAIL(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_EXTRA_COMMENTS.TRANS_ID, idx_fw_extra_comments_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_extra_comments_on_trans_id on nios.FW_EXTRA_COMMENTS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index FW_MONITOR.TRANS_ID, idx_fw_monitor_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_monitor_on_trans_id on nios.FW_MONITOR(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_MONITOR.REASON_CODE, idx_fw_monitor_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_monitor_on_reason_code on nios.FW_MONITOR(REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_MONITOR_REASON.REASON_CODE, idx_fw_monitor_reason_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_monitor_reason_on_reason_code on nios.FW_MONITOR_REASON(REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_MOVEMENT.TRANS_ID, idx_fw_movement_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_movement_on_trans_id on nios.FW_MOVEMENT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_MOVEMENT.BRANCH_CODE, idx_fw_movement_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_movement_on_branch_code on nios.FW_MOVEMENT(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_MOVEMENT.MODULE_CODE, idx_fw_movement_on_module_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_movement_on_module_code on nios.FW_MOVEMENT(MODULE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_MOVEMENT.WORKER_CODE, idx_fw_movement_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_movement_on_worker_code on nios.FW_MOVEMENT(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_QUARANTINE_REASON.TRANS_ID, idx_fw_quarantine_reason_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_quarantine_reason_on_trans_id on nios.FW_QUARANTINE_REASON(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_QUARANTINE_REASON.REASON_CODE, idx_fw_quarantine_reason_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_quarantine_reason_on_reason_code on nios.FW_QUARANTINE_REASON(REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION.TRANSDATE, idx_fw_transaction_on_transdate', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_on_transdate on nios.FW_TRANSACTION(TRANSDATE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION.TRANS_ID, idx_fw_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_on_trans_id on nios.FW_TRANSACTION(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION.DOCTOR_CODE, idx_fw_transaction_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_on_doctor_code on nios.FW_TRANSACTION(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION.EMPLOYER_CODE, idx_fw_transaction_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_on_employer_code on nios.FW_TRANSACTION(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION.LABORATORY_CODE, idx_fw_transaction_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_on_laboratory_code on nios.FW_TRANSACTION(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION.RADIOLOGIST_CODE, idx_fw_transaction_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_on_radiologist_code on nios.FW_TRANSACTION(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION.XRAY_CODE, idx_fw_transaction_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_on_xray_code on nios.FW_TRANSACTION(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION.WORKER_CODE, idx_fw_transaction_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_on_worker_code on nios.FW_TRANSACTION(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_CANCEL.TRANS_ID, idx_fw_transaction_cancel_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_cancel_on_trans_id on nios.FW_TRANSACTION_CANCEL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_CANCEL.DOCTOR_CODE, idx_fw_transaction_cancel_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_cancel_on_doctor_code on nios.FW_TRANSACTION_CANCEL(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_CANCEL.EMPLOYER_CODE, idx_fw_transaction_cancel_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_cancel_on_employer_code on nios.FW_TRANSACTION_CANCEL(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_CANCEL.LABORATORY_CODE, idx_fw_transaction_cancel_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_cancel_on_laboratory_code on nios.FW_TRANSACTION_CANCEL(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_CANCEL.RADIOLOGIST_CODE, idx_fw_transaction_cancel_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_cancel_on_radiologist_code on nios.FW_TRANSACTION_CANCEL(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_CANCEL.XRAY_CODE, idx_fw_transaction_cancel_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_cancel_on_xray_code on nios.FW_TRANSACTION_CANCEL(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_CANCEL.WORKER_CODE, idx_fw_transaction_cancel_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_cancel_on_worker_code on nios.FW_TRANSACTION_CANCEL(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_CANCEL.DOCTOR_STATE_CODE, idx_fw_transaction_cancel_on_doctor_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_cancel_on_doctor_state_code on nios.FW_TRANSACTION_CANCEL(DOCTOR_STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_DELETE.TRANS_ID, idx_fw_transaction_delete_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_delete_on_trans_id on nios.FW_TRANSACTION_DELETE(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_DELETE.DOCTOR_CODE, idx_fw_transaction_delete_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_delete_on_doctor_code on nios.FW_TRANSACTION_DELETE(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_DELETE.EMPLOYER_CODE, idx_fw_transaction_delete_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_delete_on_employer_code on nios.FW_TRANSACTION_DELETE(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_DELETE.LABORATORY_CODE, idx_fw_transaction_delete_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_delete_on_laboratory_code on nios.FW_TRANSACTION_DELETE(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_DELETE.RADIOLOGIST_CODE, idx_fw_transaction_delete_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_delete_on_radiologist_code on nios.FW_TRANSACTION_DELETE(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_DELETE.XRAY_CODE, idx_fw_transaction_delete_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_delete_on_xray_code on nios.FW_TRANSACTION_DELETE(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_DELETE.WORKER_CODE, idx_fw_transaction_delete_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_delete_on_worker_code on nios.FW_TRANSACTION_DELETE(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_UPDATE.TRANS_ID, idx_fw_transaction_update_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_update_on_trans_id on nios.FW_TRANSACTION_UPDATE(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_UPDATE.DOCTOR_CODE, idx_fw_transaction_update_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_update_on_doctor_code on nios.FW_TRANSACTION_UPDATE(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_UPDATE.LABORATORY_CODE, idx_fw_transaction_update_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_update_on_laboratory_code on nios.FW_TRANSACTION_UPDATE(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_UPDATE.XRAY_CODE, idx_fw_transaction_update_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_update_on_xray_code on nios.FW_TRANSACTION_UPDATE(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_UPDATE.WORKER_CODE, idx_fw_transaction_update_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_update_on_worker_code on nios.FW_TRANSACTION_UPDATE(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index FW_TRANSACTION_UPDATE.EMPLOYER_CODE, idx_fw_transaction_update_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_transaction_update_on_employer_code on nios.FW_TRANSACTION_UPDATE(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_UNSUITABLE_REASONS.TRANS_ID, idx_fw_unsuitable_reasons_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_unsuitable_reasons_on_trans_id on nios.FW_UNSUITABLE_REASONS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index FW_WORKER_REPLACEMENT.WORKER_CODE, idx_fw_worker_replacement_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_fw_worker_replacement_on_worker_code on nios.FW_WORKER_REPLACEMENT(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index GROUP_DETAILS.GROUP_CODE, idx_group_details_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_group_details_on_group_code on nios.GROUP_DETAILS(GROUP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index GROUP_DETAILS.POST_CODE, idx_group_details_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_group_details_on_post_code on nios.GROUP_DETAILS(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index GROUP_DOCTOR_PAY.GROUP_CODE, idx_group_doctor_pay_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_group_doctor_pay_on_group_code on nios.GROUP_DOCTOR_PAY(GROUP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index GROUP_DOCTOR_PAY.DOCTOR_CODE, idx_group_doctor_pay_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_group_doctor_pay_on_doctor_code on nios.GROUP_DOCTOR_PAY(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index GROUP_XRAY_PAY.GROUP_CODE, idx_group_xray_pay_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_group_xray_pay_on_group_code on nios.GROUP_XRAY_PAY(GROUP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index GROUP_XRAY_PAY.XRAY_CODE, idx_group_xray_pay_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_group_xray_pay_on_xray_code on nios.GROUP_XRAY_PAY(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index IMM_BLOCK_WORKERS.WORKER_CODE, idx_imm_block_workers_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_imm_block_workers_on_worker_code on nios.IMM_BLOCK_WORKERS(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index INACTIVE_DOCTORS.DOCTOR_CODE, idx_inactive_doctors_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_inactive_doctors_on_doctor_code on nios.INACTIVE_DOCTORS(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index INVOICE_DETAIL.TRANS_ID, idx_invoice_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_invoice_detail_on_trans_id on nios.INVOICE_DETAIL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index INVOICE_DETAIL.SERVICE_PROVIDER_CODE, idx_invoice_detail_on_service_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_invoice_detail_on_service_provider_code on nios.INVOICE_DETAIL(SERVICE_PROVIDER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index INVOICE_DETAIL.MEMBER_CODE, idx_invoice_detail_on_member_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_invoice_detail_on_member_code on nios.INVOICE_DETAIL(MEMBER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_REGISTRATION.POST_CODE, idx_laboratory_registration_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_registration_on_post_code on nios.LABORATORY_REGISTRATION(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_REGISTRATION.STATE_CODE, idx_laboratory_registration_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_registration_on_state_code on nios.LABORATORY_REGISTRATION(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_REGISTRATION.DISTRICT_CODE, idx_laboratory_registration_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_registration_on_district_code on nios.LABORATORY_REGISTRATION(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_REGISTRATION.COUNTRY_CODE, idx_laboratory_registration_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_registration_on_country_code on nios.LABORATORY_REGISTRATION(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABORATORY_REGISTRATION.STATUS_CODE, idx_laboratory_registration_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_laboratory_registration_on_status_code on nios.LABORATORY_REGISTRATION(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index LABUAN_G_WORKERS.TRANS_ID, idx_labuan_g_workers_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_labuan_g_workers_on_trans_id on nios.LABUAN_G_WORKERS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LABUAN_G_WORKERS.WORKER_CODE, idx_labuan_g_workers_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_labuan_g_workers_on_worker_code on nios.LABUAN_G_WORKERS(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index LAB_CHANGE_REQUEST.LAB_CODE, idx_lab_change_request_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_lab_change_request_on_lab_code on nios.LAB_CHANGE_REQUEST(LAB_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index LAB_PAYMENT.TRANS_ID, idx_lab_payment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_lab_payment_on_trans_id on nios.LAB_PAYMENT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LAB_PAYMENT.LAB_CODE, idx_lab_payment_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_lab_payment_on_lab_code on nios.LAB_PAYMENT(LAB_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LAB_PAYMENT.WORKER_CODE, idx_lab_payment_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_lab_payment_on_worker_code on nios.LAB_PAYMENT(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;





begin
    insert into copy_logs (description, begin_at) values ('start index LETTER_MONITOR.SP_CODE, idx_letter_monitor_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_letter_monitor_on_sp_code on nios.LETTER_MONITOR(SP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LETTER_MONITOR.STATE_CODE, idx_letter_monitor_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_letter_monitor_on_state_code on nios.LETTER_MONITOR(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index LETTER_MONITOR.SP_CODE2, idx_letter_monitor_on_sp_code2', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_letter_monitor_on_sp_code2 on nios.LETTER_MONITOR(SP_CODE2);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;





begin
    insert into copy_logs (description, begin_at) values ('start index LQCC_REPORT.TRANS_ID, idx_lqcc_report_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_lqcc_report_on_trans_id on nios.LQCC_REPORT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index MAXIGRID.TRANS_ID, idx_maxigrid_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_maxigrid_on_trans_id on nios.MAXIGRID(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index MAXIGRID.BANK_CODE, idx_maxigrid_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_maxigrid_on_bank_code on nios.MAXIGRID(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index MERTS_DOC_STARTPAGE_STATS.DOCTOR_CODE, idx_merts_doc_startpage_stats_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_merts_doc_startpage_stats_on_doctor_code on nios.MERTS_DOC_STARTPAGE_STATS(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index MERTS_LAB_STARTPAGE_STATS.LAB_CODE, idx_merts_lab_startpage_stats_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_merts_lab_startpage_stats_on_lab_code on nios.MERTS_LAB_STARTPAGE_STATS(LAB_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index MERTS_XRAY_STARTPAGE_STATS.XRAY_CODE, idx_merts_xray_startpage_stats_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_merts_xray_startpage_stats_on_xray_code on nios.MERTS_XRAY_STARTPAGE_STATS(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index MISSING_PAYMENT.BANK_CODE, idx_missing_payment_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_missing_payment_on_bank_code on nios.MISSING_PAYMENT(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;





begin
    insert into copy_logs (description, begin_at) values ('start index MONITORING.WORKER_CODE, idx_monitoring_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_monitoring_on_worker_code on nios.MONITORING(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index MONITOR_EXAM.TRANS_ID, idx_monitor_exam_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_monitor_exam_on_trans_id on nios.MONITOR_EXAM(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index MONITOR_EXAM.WORKER_CODE, idx_monitor_exam_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_monitor_exam_on_worker_code on nios.MONITOR_EXAM(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index MYIMMS_MON_TCUPI.TRANS_ID, idx_myimms_mon_tcupi_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_myimms_mon_tcupi_on_trans_id on nios.MYIMMS_MON_TCUPI(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index MYIMMS_QUEUE.TRANS_ID, idx_myimms_queue_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_myimms_queue_on_trans_id on nios.MYIMMS_QUEUE(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index MYIMMS_QUEUE_HIST.TRANS_ID, idx_myimms_queue_hist_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_myimms_queue_hist_on_trans_id on nios.MYIMMS_QUEUE_HIST(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index NEW_ARRI.DOCTOR_CODE, idx_new_arri_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_new_arri_on_doctor_code on nios.NEW_ARRI(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index NEW_ARRI.WORKER_CODE, idx_new_arri_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_new_arri_on_worker_code on nios.NEW_ARRI(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index NIOS_LAB_PAYMENT.LABORATORY_CODE, idx_nios_lab_payment_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_nios_lab_payment_on_laboratory_code on nios.NIOS_LAB_PAYMENT(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index NIOS_LAB_PAYMENT.WORKER_CODE, idx_nios_lab_payment_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_nios_lab_payment_on_worker_code on nios.NIOS_LAB_PAYMENT(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index NON_TRANSMISSION.DOCTOR_CODE, idx_non_transmission_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_non_transmission_on_doctor_code on nios.NON_TRANSMISSION(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index NON_TRANSMISSION.WORKER_CODE, idx_non_transmission_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_non_transmission_on_worker_code on nios.NON_TRANSMISSION(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index NOTIFICATION.TRANS_ID, idx_notification_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_notification_on_trans_id on nios.NOTIFICATION(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index NOTIFICATION.WORKER_CODE, idx_notification_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_notification_on_worker_code on nios.NOTIFICATION(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index PATI_RENEW.TRANS_ID, idx_pati_renew_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pati_renew_on_trans_id on nios.PATI_RENEW(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PATI_RENEW.WORKER_CODE, idx_pati_renew_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pati_renew_on_worker_code on nios.PATI_RENEW(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT.BANK_CODE, idx_payment_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_on_bank_code on nios.PAYMENT(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT.SP_CODE, idx_payment_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_on_sp_code on nios.PAYMENT(SP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT.GST_CODE, idx_payment_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_on_gst_code on nios.PAYMENT(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REFUND.OLD_BANK_CODE, idx_payment_refund_on_old_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_refund_on_old_bank_code on nios.PAYMENT_REFUND(OLD_BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REFUND.BRANCH_CODE, idx_payment_refund_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_refund_on_branch_code on nios.PAYMENT_REFUND(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REFUND.EMPLOYER_CODE, idx_payment_refund_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_refund_on_employer_code on nios.PAYMENT_REFUND(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REFUND.NEW_BANK_CODE, idx_payment_refund_on_new_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_refund_on_new_bank_code on nios.PAYMENT_REFUND(NEW_BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REJECT.REJECT_CODE, idx_payment_reject_on_reject_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_reject_on_reject_code on nios.PAYMENT_REJECT(REJECT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REJECT.EMPLOYER_CODE, idx_payment_reject_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_reject_on_employer_code on nios.PAYMENT_REJECT(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REQ.BRANCH_CODE, idx_payment_req_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_req_on_branch_code on nios.PAYMENT_REQ(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REQ.SP_CODE, idx_payment_req_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_req_on_sp_code on nios.PAYMENT_REQ(SP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REQ.GST_CODE, idx_payment_req_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_req_on_gst_code on nios.PAYMENT_REQ(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REQ.SERVICE_PROVIDER_CODE, idx_payment_req_on_service_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_req_on_service_provider_code on nios.PAYMENT_REQ(SERVICE_PROVIDER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_REQ.WORKER_CODE, idx_payment_req_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_req_on_worker_code on nios.PAYMENT_REQ(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_STATUS.TRANS_ID, idx_payment_status_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_status_on_trans_id on nios.PAYMENT_STATUS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_STATUS.DOCTOR_CODE, idx_payment_status_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_status_on_doctor_code on nios.PAYMENT_STATUS(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_STATUS.XRAY_CODE, idx_payment_status_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_status_on_xray_code on nios.PAYMENT_STATUS(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAYMENT_STATUS.LAB_CODE, idx_payment_status_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_payment_status_on_lab_code on nios.PAYMENT_STATUS(LAB_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index PAY_TRANSACTION.TRANS_ID, idx_pay_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pay_transaction_on_trans_id on nios.PAY_TRANSACTION(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAY_TRANSACTION.WORKER_CODE, idx_pay_transaction_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pay_transaction_on_worker_code on nios.PAY_TRANSACTION(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAY_TRANSACTION.DOCTOR_CODE, idx_pay_transaction_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pay_transaction_on_doctor_code on nios.PAY_TRANSACTION(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAY_TRANSACTION.XRAY_CODE, idx_pay_transaction_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pay_transaction_on_xray_code on nios.PAY_TRANSACTION(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index PAY_TRANS_MANUAL.TRANS_ID, idx_pay_trans_manual_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pay_trans_manual_on_trans_id on nios.PAY_TRANS_MANUAL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAY_TRANS_MANUAL.SP_CODE, idx_pay_trans_manual_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pay_trans_manual_on_sp_code on nios.PAY_TRANS_MANUAL(SP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PAY_TRANS_MANUAL.WORKER_CODE, idx_pay_trans_manual_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pay_trans_manual_on_worker_code on nios.PAY_TRANS_MANUAL(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;







begin
    insert into copy_logs (description, begin_at) values ('start index PCR_TRANSACTION.TRANS_ID, idx_pcr_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pcr_transaction_on_trans_id on nios.PCR_TRANSACTION(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PCR_TRANSACTION.RADIOLOGIST_CODE, idx_pcr_transaction_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pcr_transaction_on_radiologist_code on nios.PCR_TRANSACTION(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PCR_TRANSACTION.XRAY_CODE, idx_pcr_transaction_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pcr_transaction_on_xray_code on nios.PCR_TRANSACTION(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PCR_TRANSACTION.WORKER_CODE, idx_pcr_transaction_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pcr_transaction_on_worker_code on nios.PCR_TRANSACTION(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index PCR_TRANS_COMMENTS.TRANS_ID, idx_pcr_trans_comments_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pcr_trans_comments_on_trans_id on nios.PCR_TRANS_COMMENTS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PCR_TRANS_COMMENTS.PARAMETER_CODE, idx_pcr_trans_comments_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pcr_trans_comments_on_parameter_code on nios.PCR_TRANS_COMMENTS(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index PCR_TRANS_DETAIL.TRANS_ID, idx_pcr_trans_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pcr_trans_detail_on_trans_id on nios.PCR_TRANS_DETAIL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PCR_TRANS_DETAIL.PARAMETER_CODE, idx_pcr_trans_detail_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pcr_trans_detail_on_parameter_code on nios.PCR_TRANS_DETAIL(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index PINCODE_REQ.BRANCH_CODE, idx_pincode_req_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pincode_req_on_branch_code on nios.PINCODE_REQ(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PINCODE_REQ.EMPLOYER_CODE, idx_pincode_req_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pincode_req_on_employer_code on nios.PINCODE_REQ(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PINCODE_REQ.PIN_CODE, idx_pincode_req_on_pin_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_pincode_req_on_pin_code on nios.PINCODE_REQ(PIN_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index PLY_TRANSACTION.TRANS_ID, idx_ply_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_ply_transaction_on_trans_id on nios.PLY_TRANSACTION(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index PLY_TRANSACTION.EMPLOYER_CODE, idx_ply_transaction_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_ply_transaction_on_employer_code on nios.PLY_TRANSACTION(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index PLY_TRANSACTION_HIST.TRANS_ID, idx_ply_transaction_hist_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_ply_transaction_hist_on_trans_id on nios.PLY_TRANSACTION_HIST(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC.TRANS_ID, idx_quarantine_fw_doc_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_on_trans_id on nios.QUARANTINE_FW_DOC(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC.FW_CODE, idx_quarantine_fw_doc_on_fw_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_on_fw_code on nios.QUARANTINE_FW_DOC(FW_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC.DOC_CODE, idx_quarantine_fw_doc_on_doc_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_on_doc_code on nios.QUARANTINE_FW_DOC(DOC_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC.EMPLOYER_CODE, idx_quarantine_fw_doc_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_on_employer_code on nios.QUARANTINE_FW_DOC(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC.LAB_CODE, idx_quarantine_fw_doc_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_on_lab_code on nios.QUARANTINE_FW_DOC(LAB_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC.RAD_CODE, idx_quarantine_fw_doc_on_rad_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_on_rad_code on nios.QUARANTINE_FW_DOC(RAD_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC.XRAY_CODE, idx_quarantine_fw_doc_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_on_xray_code on nios.QUARANTINE_FW_DOC(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC.L1_BLOOD_BARCODENO, idx_quarantine_fw_doc_on_l1_blood_barcodeno', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_on_l1_blood_barcodeno on nios.QUARANTINE_FW_DOC(L1_BLOOD_BARCODENO);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC.L1_URINE_BARCODENO, idx_quarantine_fw_doc_on_l1_urine_barcodeno', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_on_l1_urine_barcodeno on nios.QUARANTINE_FW_DOC(L1_URINE_BARCODENO);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC_HIST.TRANS_ID, idx_quarantine_fw_doc_hist_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_hist_on_trans_id on nios.QUARANTINE_FW_DOC_HIST(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC_HIST.FW_CODE, idx_quarantine_fw_doc_hist_on_fw_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_hist_on_fw_code on nios.QUARANTINE_FW_DOC_HIST(FW_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC_HIST.DOC_CODE, idx_quarantine_fw_doc_hist_on_doc_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_hist_on_doc_code on nios.QUARANTINE_FW_DOC_HIST(DOC_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC_HIST.EMPLOYER_CODE, idx_quarantine_fw_doc_hist_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_hist_on_employer_code on nios.QUARANTINE_FW_DOC_HIST(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC_HIST.LAB_CODE, idx_quarantine_fw_doc_hist_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_hist_on_lab_code on nios.QUARANTINE_FW_DOC_HIST(LAB_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC_HIST.RAD_CODE, idx_quarantine_fw_doc_hist_on_rad_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_hist_on_rad_code on nios.QUARANTINE_FW_DOC_HIST(RAD_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_DOC_HIST.XRAY_CODE, idx_quarantine_fw_doc_hist_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_doc_hist_on_xray_code on nios.QUARANTINE_FW_DOC_HIST(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_REASON.TRANS_ID, idx_quarantine_fw_reason_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_reason_on_trans_id on nios.QUARANTINE_FW_REASON(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_REASON.REASON_CODE, idx_quarantine_fw_reason_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_reason_on_reason_code on nios.QUARANTINE_FW_REASON(REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_REASON_HIST.TRANS_ID, idx_quarantine_fw_reason_hist_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_reason_hist_on_trans_id on nios.QUARANTINE_FW_REASON_HIST(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_FW_REASON_HIST.REASON_CODE, idx_quarantine_fw_reason_hist_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_fw_reason_hist_on_reason_code on nios.QUARANTINE_FW_REASON_HIST(REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_INSP_FINDINGS.TRANS_ID, idx_quarantine_insp_findings_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_insp_findings_on_trans_id on nios.QUARANTINE_INSP_FINDINGS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_INSP_FINDINGS.FW_CODE, idx_quarantine_insp_findings_on_fw_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_insp_findings_on_fw_code on nios.QUARANTINE_INSP_FINDINGS(FW_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_INSP_FINDINGS_HIST.TRANS_ID, idx_quarantine_insp_findings_hist_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_insp_findings_hist_on_trans_id on nios.QUARANTINE_INSP_FINDINGS_HIST(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_INSP_FINDINGS_HIST.FW_CODE, idx_quarantine_insp_findings_hist_on_fw_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_insp_findings_hist_on_fw_code on nios.QUARANTINE_INSP_FINDINGS_HIST(FW_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_REASON.REASON_CODE, idx_quarantine_reason_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_reason_on_reason_code on nios.QUARANTINE_REASON(REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_REASON_GROUP.REASON_CODE, idx_quarantine_reason_group_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_reason_group_on_reason_code on nios.QUARANTINE_REASON_GROUP(REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_RELEASE_REQUEST.TRANS_ID, idx_quarantine_release_request_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_release_request_on_trans_id on nios.QUARANTINE_RELEASE_REQUEST(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_TRANSFER.TRANS_ID, idx_quarantine_transfer_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_transfer_on_trans_id on nios.QUARANTINE_TRANSFER(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index QUARANTINE_TRANSFER.WORKER_CODE, idx_quarantine_transfer_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_quarantine_transfer_on_worker_code on nios.QUARANTINE_TRANSFER(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;







begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT.TRANNO, idx_receipt_on_tranno', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_on_tranno on nios.RECEIPT(TRANNO);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT.CONTACT_POST_CODE, idx_receipt_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_on_contact_post_code on nios.RECEIPT(CONTACT_POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT.CONTACT_STATE_CODE, idx_receipt_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_on_contact_state_code on nios.RECEIPT(CONTACT_STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT.CONTACT_DISTRICT_CODE, idx_receipt_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_on_contact_district_code on nios.RECEIPT(CONTACT_DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT.BRANCH_CODE, idx_receipt_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_on_branch_code on nios.RECEIPT(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_DETAIL.TRANNO, idx_receipt_detail_on_tranno', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_detail_on_tranno on nios.RECEIPT_DETAIL(TRANNO);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_DETAIL.BANK_CODE, idx_receipt_detail_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_detail_on_bank_code on nios.RECEIPT_DETAIL(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_DETAIL.ZONE_CODE, idx_receipt_detail_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_detail_on_zone_code on nios.RECEIPT_DETAIL(ZONE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_DETAIL.APPROVAL_CODE, idx_receipt_detail_on_approval_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_detail_on_approval_code on nios.RECEIPT_DETAIL(APPROVAL_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_DETAIL_SABAH.BANK_CODE, idx_receipt_detail_sabah_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_detail_sabah_on_bank_code on nios.RECEIPT_DETAIL_SABAH(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_DETAIL_SABAH.ZONE_CODE, idx_receipt_detail_sabah_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_detail_sabah_on_zone_code on nios.RECEIPT_DETAIL_SABAH(ZONE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_KIV_REQUEST.BRANCH_CODE, idx_receipt_kiv_request_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_kiv_request_on_branch_code on nios.RECEIPT_KIV_REQUEST(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_SABAH.CONTACT_POST_CODE, idx_receipt_sabah_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_sabah_on_contact_post_code on nios.RECEIPT_SABAH(CONTACT_POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_SABAH.CONTACT_STATE_CODE, idx_receipt_sabah_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_sabah_on_contact_state_code on nios.RECEIPT_SABAH(CONTACT_STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_SABAH.CONTACT_DISTRICT_CODE, idx_receipt_sabah_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_sabah_on_contact_district_code on nios.RECEIPT_SABAH(CONTACT_DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_SABAH.BRANCH_CODE, idx_receipt_sabah_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_sabah_on_branch_code on nios.RECEIPT_SABAH(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_USAGE.TRANS_ID, idx_receipt_usage_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_usage_on_trans_id on nios.RECEIPT_USAGE(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RECEIPT_USAGE.STATUS_CODE, idx_receipt_usage_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_receipt_usage_on_status_code on nios.RECEIPT_USAGE(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index REFUND.STATUS_CODE, idx_refund_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_refund_on_status_code on nios.REFUND(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index REFUND.BRANCH_CODE, idx_refund_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_refund_on_branch_code on nios.REFUND(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index REFUND_DETAIL.TRANS_ID, idx_refund_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_refund_detail_on_trans_id on nios.REFUND_DETAIL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index REFUND_DETAIL.STATUS_CODE, idx_refund_detail_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_refund_detail_on_status_code on nios.REFUND_DETAIL(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index REFUND_FOMIC.TRANS_ID, idx_refund_fomic_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_refund_fomic_on_trans_id on nios.REFUND_FOMIC(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index REFUND_FOMIC.WORKER_CODE, idx_refund_fomic_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_refund_fomic_on_worker_code on nios.REFUND_FOMIC(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index REFUND_FOMIC_FINAL.TRANS_ID, idx_refund_fomic_final_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_refund_fomic_final_on_trans_id on nios.REFUND_FOMIC_FINAL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index REFUND_FOMIC_FINAL.WORKER_CODE, idx_refund_fomic_final_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_refund_fomic_final_on_worker_code on nios.REFUND_FOMIC_FINAL(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index REF_DOUBLE.WORKER_CODE, idx_ref_double_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_ref_double_on_worker_code on nios.REF_DOUBLE(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index REL_QRTN.WORKER_CODE, idx_rel_qrtn_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rel_qrtn_on_worker_code on nios.REL_QRTN(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index RENEWAL_COMMENTS.TRANS_ID, idx_renewal_comments_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_renewal_comments_on_trans_id on nios.RENEWAL_COMMENTS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index RENEWAL_WORKER.WORKER_CODE, idx_renewal_worker_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_renewal_worker_on_worker_code on nios.RENEWAL_WORKER(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RENEWAL_WORKER.DOCTOR_CODE, idx_renewal_worker_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_renewal_worker_on_doctor_code on nios.RENEWAL_WORKER(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RENEWAL_WORKER.EMPLOYER_CODE, idx_renewal_worker_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_renewal_worker_on_employer_code on nios.RENEWAL_WORKER(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RENEWAL_WORKER.BRANCH_CODE, idx_renewal_worker_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_renewal_worker_on_branch_code on nios.RENEWAL_WORKER(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index REPLACE_TABLE.WORKER_CODE, idx_replace_table_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_replace_table_on_worker_code on nios.REPLACE_TABLE(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index REPLY_TABLE.ERROR_CODE, idx_reply_table_on_error_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_reply_table_on_error_code on nios.REPLY_TABLE(ERROR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index REPLY_TABLE_ARC.ERROR_CODE, idx_reply_table_arc_on_error_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_reply_table_arc_on_error_code on nios.REPLY_TABLE_ARC(ERROR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index REPLY_TABLE_OLD.ERROR_CODE, idx_reply_table_old_on_error_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_reply_table_old_on_error_code on nios.REPLY_TABLE_OLD(ERROR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index REPORT_DIFF_BLOODGROUP.REPORT_DOCCODE, idx_report_diff_bloodgroup_on_report_doccode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_report_diff_bloodgroup_on_report_doccode on nios.REPORT_DIFF_BLOODGROUP(REPORT_DOCCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index REPORT_DIFF_BLOODGROUP.DOCTOR_CODE_ME1, idx_report_diff_bloodgroup_on_doctor_code_me1', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_report_diff_bloodgroup_on_doctor_code_me1 on nios.REPORT_DIFF_BLOODGROUP(DOCTOR_CODE_ME1);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index REPORT_DIFF_BLOODGROUP.DOCTOR_CODE_ME2, idx_report_diff_bloodgroup_on_doctor_code_me2', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_report_diff_bloodgroup_on_doctor_code_me2 on nios.REPORT_DIFF_BLOODGROUP(DOCTOR_CODE_ME2);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index REPORT_DIFF_BLOODGROUP.DOCTOR_CODE_ME3, idx_report_diff_bloodgroup_on_doctor_code_me3', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_report_diff_bloodgroup_on_doctor_code_me3 on nios.REPORT_DIFF_BLOODGROUP(DOCTOR_CODE_ME3);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index REPORT_DIFF_BLOODGROUP.WORKER_CODE, idx_report_diff_bloodgroup_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_report_diff_bloodgroup_on_worker_code on nios.REPORT_DIFF_BLOODGROUP(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index REPORT_RECEIVE.TRANS_ID, idx_report_receive_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_report_receive_on_trans_id on nios.REPORT_RECEIVE(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index REPORT_RECEIVE.WORKER_CODE, idx_report_receive_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_report_receive_on_worker_code on nios.REPORT_RECEIVE(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;







begin
    insert into copy_logs (description, begin_at) values ('start index RFW_BATCH_TRANSACTION.LABORATORY_CODE_A, idx_rfw_batch_transaction_on_laboratory_code_a', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_batch_transaction_on_laboratory_code_a on nios.RFW_BATCH_TRANSACTION(LABORATORY_CODE_A);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RFW_BATCH_TRANSACTION.LABORATORY_CODE_B, idx_rfw_batch_transaction_on_laboratory_code_b', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_batch_transaction_on_laboratory_code_b on nios.RFW_BATCH_TRANSACTION(LABORATORY_CODE_B);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RFW_BATCH_TRANSACTION.STATUS_CODE, idx_rfw_batch_transaction_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_batch_transaction_on_status_code on nios.RFW_BATCH_TRANSACTION(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RFW_BATCH_TRANSACTION.LABORATORY_CODE_ORI, idx_rfw_batch_transaction_on_laboratory_code_ori', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_batch_transaction_on_laboratory_code_ori on nios.RFW_BATCH_TRANSACTION(LABORATORY_CODE_ORI);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index RFW_CASE_TRANSACTION.TRANS_ID, idx_rfw_case_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_case_transaction_on_trans_id on nios.RFW_CASE_TRANSACTION(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RFW_CASE_TRANSACTION.WORKER_CODE, idx_rfw_case_transaction_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_case_transaction_on_worker_code on nios.RFW_CASE_TRANSACTION(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index RFW_CASE_TRANSACTION.STATUS_CODE, idx_rfw_case_transaction_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_case_transaction_on_status_code on nios.RFW_CASE_TRANSACTION(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index RFW_COMMENT.PARAMETER_CODE, idx_rfw_comment_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_comment_on_parameter_code on nios.RFW_COMMENT(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index RFW_DETAIL.PARAMETER_CODE, idx_rfw_detail_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_detail_on_parameter_code on nios.RFW_DETAIL(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index RFW_FW_TRANSACTION.LABORATORY_CODE, idx_rfw_fw_transaction_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_rfw_fw_transaction_on_laboratory_code on nios.RFW_FW_TRANSACTION(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;





begin
    insert into copy_logs (description, begin_at) values ('start index R_DEL_DUP.WORKER_CODE, idx_r_del_dup_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_r_del_dup_on_worker_code on nios.R_DEL_DUP(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SABAH_DOC_POST.DOCTOR_CODE, idx_sabah_doc_post_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_sabah_doc_post_on_doctor_code on nios.SABAH_DOC_POST(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SABAH_DOC_POST.POST_CODE, idx_sabah_doc_post_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_sabah_doc_post_on_post_code on nios.SABAH_DOC_POST(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SABAH_DOC_POST.STATE_CODE, idx_sabah_doc_post_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_sabah_doc_post_on_state_code on nios.SABAH_DOC_POST(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SABAH_DOC_POST.DISTRICT_CODE, idx_sabah_doc_post_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_sabah_doc_post_on_district_code on nios.SABAH_DOC_POST(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SABAH_TRANSID.TRANS_ID, idx_sabah_transid_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_sabah_transid_on_trans_id on nios.SABAH_TRANSID(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SCB_HP_DX.DOC_XRAY_CODE, idx_scb_hp_dx_on_doc_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_hp_dx_on_doc_xray_code on nios.SCB_HP_DX(DOC_XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SCB_PAY_XRAY_NAMEANDADD.XRAY_CODE, idx_scb_pay_xray_nameandadd_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_pay_xray_nameandadd_on_xray_code on nios.SCB_PAY_XRAY_NAMEANDADD(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_PAY_XRAY_NAMEANDADD.POST_CODE, idx_scb_pay_xray_nameandadd_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_pay_xray_nameandadd_on_post_code on nios.SCB_PAY_XRAY_NAMEANDADD(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_PAY_XRAY_NAMEANDADD.DISTRICT_CODE, idx_scb_pay_xray_nameandadd_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_pay_xray_nameandadd_on_district_code on nios.SCB_PAY_XRAY_NAMEANDADD(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_PAY_XRAY_NAMEANDADD.STATE_CODE, idx_scb_pay_xray_nameandadd_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_pay_xray_nameandadd_on_state_code on nios.SCB_PAY_XRAY_NAMEANDADD(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SCB_SABAH_DOC_POST.DOCTOR_CODE, idx_scb_sabah_doc_post_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_sabah_doc_post_on_doctor_code on nios.SCB_SABAH_DOC_POST(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_SABAH_DOC_POST.POST_CODE, idx_scb_sabah_doc_post_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_sabah_doc_post_on_post_code on nios.SCB_SABAH_DOC_POST(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_SABAH_DOC_POST.STATE_CODE, idx_scb_sabah_doc_post_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_sabah_doc_post_on_state_code on nios.SCB_SABAH_DOC_POST(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_SABAH_DOC_POST.DISTRICT_CODE, idx_scb_sabah_doc_post_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_sabah_doc_post_on_district_code on nios.SCB_SABAH_DOC_POST(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SCB_XRAY_NOT_DONE.XRAY_CODE, idx_scb_xray_not_done_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_xray_not_done_on_xray_code on nios.SCB_XRAY_NOT_DONE(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_XRAY_NOT_DONE.WORKER_CODE, idx_scb_xray_not_done_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_xray_not_done_on_worker_code on nios.SCB_XRAY_NOT_DONE(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SCB_XRAY_PAYIN_LIST.XRAY_CODE, idx_scb_xray_payin_list_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_xray_payin_list_on_xray_code on nios.SCB_XRAY_PAYIN_LIST(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_XRAY_PAYIN_LIST.POST_CODE, idx_scb_xray_payin_list_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_xray_payin_list_on_post_code on nios.SCB_XRAY_PAYIN_LIST(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_XRAY_PAYIN_LIST.DISTRICT_CODE, idx_scb_xray_payin_list_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_xray_payin_list_on_district_code on nios.SCB_XRAY_PAYIN_LIST(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_XRAY_PAYIN_LIST.STATE_CODE, idx_scb_xray_payin_list_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_xray_payin_list_on_state_code on nios.SCB_XRAY_PAYIN_LIST(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SCB_XRAY_PAY_NEW_ADDRESS.XRAY_CODE, idx_scb_xray_pay_new_address_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_xray_pay_new_address_on_xray_code on nios.SCB_XRAY_PAY_NEW_ADDRESS(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_XRAY_PAY_NEW_ADDRESS.POST_CODE, idx_scb_xray_pay_new_address_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_xray_pay_new_address_on_post_code on nios.SCB_XRAY_PAY_NEW_ADDRESS(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_XRAY_PAY_NEW_ADDRESS.DISTRICT_CODE, idx_scb_xray_pay_new_address_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_xray_pay_new_address_on_district_code on nios.SCB_XRAY_PAY_NEW_ADDRESS(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SCB_XRAY_PAY_NEW_ADDRESS.STATE_CODE, idx_scb_xray_pay_new_address_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_scb_xray_pay_new_address_on_state_code on nios.SCB_XRAY_PAY_NEW_ADDRESS(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SEMINAR.STATE_CODE, idx_seminar_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_seminar_on_state_code on nios.SEMINAR(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SEMINAR_DETAIL.SP_CODE, idx_seminar_detail_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_seminar_detail_on_sp_code on nios.SEMINAR_DETAIL(SP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SEMINAR_DETAIL.DISTRICT_CODE, idx_seminar_detail_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_seminar_detail_on_district_code on nios.SEMINAR_DETAIL(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SEMINAR_DETAIL.STATE_CODE, idx_seminar_detail_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_seminar_detail_on_state_code on nios.SEMINAR_DETAIL(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SEMINAR_DETAIL.SP_CODE2, idx_seminar_detail_on_sp_code2', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_seminar_detail_on_sp_code2 on nios.SEMINAR_DETAIL(SP_CODE2);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SEND_MAIL_IND.TRANS_ID, idx_send_mail_ind_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_send_mail_ind_on_trans_id on nios.SEND_MAIL_IND(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDERS_GROUP.DISTRICT_CODE, idx_service_providers_group_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_providers_group_on_district_code on nios.SERVICE_PROVIDERS_GROUP(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDERS_GROUP.GROUP_CODE, idx_service_providers_group_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_providers_group_on_group_code on nios.SERVICE_PROVIDERS_GROUP(GROUP_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDERS_GROUP.POSTCODE, idx_service_providers_group_on_postcode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_providers_group_on_postcode on nios.SERVICE_PROVIDERS_GROUP(POSTCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDERS_GROUP.STATE_CODE, idx_service_providers_group_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_providers_group_on_state_code on nios.SERVICE_PROVIDERS_GROUP(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDERS_GROUP.GST_CODE, idx_service_providers_group_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_providers_group_on_gst_code on nios.SERVICE_PROVIDERS_GROUP(GST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDERS_GROUP.BANK_CODE, idx_service_providers_group_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_providers_group_on_bank_code on nios.SERVICE_PROVIDERS_GROUP(BANK_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SERVICE_PROVIDERS_GROUP.SERVICE_PROVIDER_MASTER_CODE, idx_service_providers_group_on_service_provider_master_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_service_providers_group_on_service_provider_master_code on nios.SERVICE_PROVIDERS_GROUP(SERVICE_PROVIDER_MASTER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index SHADOW_XRAY_RADIO_ASSIGNMENT.TRANS_ID, idx_shadow_xray_radio_assignment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_shadow_xray_radio_assignment_on_trans_id on nios.SHADOW_XRAY_RADIO_ASSIGNMENT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SPECIAL_RENEWAL_REQUEST.WORKER_CODE, idx_special_renewal_request_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_special_renewal_request_on_worker_code on nios.SPECIAL_RENEWAL_REQUEST(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SPECIAL_RENEWAL_REQUEST.EMPLOYER_CODE, idx_special_renewal_request_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_special_renewal_request_on_employer_code on nios.SPECIAL_RENEWAL_REQUEST(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SPECIAL_RENEWAL_REQUEST.DOCTOR_CODE, idx_special_renewal_request_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_special_renewal_request_on_doctor_code on nios.SPECIAL_RENEWAL_REQUEST(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SPECIAL_RENEWAL_REQUEST.POST_CODE, idx_special_renewal_request_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_special_renewal_request_on_post_code on nios.SPECIAL_RENEWAL_REQUEST(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SPECIAL_RENEWAL_REQUEST.COUNTRY_CODE, idx_special_renewal_request_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_special_renewal_request_on_country_code on nios.SPECIAL_RENEWAL_REQUEST(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SPECIAL_RENEWAL_REQUEST.BRANCH_CODE, idx_special_renewal_request_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_special_renewal_request_on_branch_code on nios.SPECIAL_RENEWAL_REQUEST(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index SPPAYMENT_REFERENCE.BRANCH_CODE, idx_sppayment_reference_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_sppayment_reference_on_branch_code on nios.SPPAYMENT_REFERENCE(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index SPPAYMENT_REFERENCE.SERVICE_PROVIDER_CODE, idx_sppayment_reference_on_service_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_sppayment_reference_on_service_provider_code on nios.SPPAYMENT_REFERENCE(SERVICE_PROVIDER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index STATUS_CHANGE_PENDING.TRANS_ID, idx_status_change_pending_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_status_change_pending_on_trans_id on nios.STATUS_CHANGE_PENDING(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index STATUS_CHANGE_PENDING.WORKER_CODE, idx_status_change_pending_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_status_change_pending_on_worker_code on nios.STATUS_CHANGE_PENDING(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;





begin
    insert into copy_logs (description, begin_at) values ('start index TEMP_PENDING_REVIEW_RESEND.TRANS_ID, idx_temp_pending_review_resend_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_temp_pending_review_resend_on_trans_id on nios.TEMP_PENDING_REVIEW_RESEND(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index TEMP_QUARANTINE_FW_DOC.TRANS_ID, idx_temp_quarantine_fw_doc_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_temp_quarantine_fw_doc_on_trans_id on nios.TEMP_QUARANTINE_FW_DOC(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index TEMP_QUARANTINE_FW_DOC.FW_CODE, idx_temp_quarantine_fw_doc_on_fw_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_temp_quarantine_fw_doc_on_fw_code on nios.TEMP_QUARANTINE_FW_DOC(FW_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index TEMP_QUARANTINE_FW_DOC.DOC_CODE, idx_temp_quarantine_fw_doc_on_doc_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_temp_quarantine_fw_doc_on_doc_code on nios.TEMP_QUARANTINE_FW_DOC(DOC_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index TEMP_QUARANTINE_FW_DOC.EMPLOYER_CODE, idx_temp_quarantine_fw_doc_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_temp_quarantine_fw_doc_on_employer_code on nios.TEMP_QUARANTINE_FW_DOC(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index TEMP_QUARANTINE_FW_DOC.LAB_CODE, idx_temp_quarantine_fw_doc_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_temp_quarantine_fw_doc_on_lab_code on nios.TEMP_QUARANTINE_FW_DOC(LAB_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index TEMP_QUARANTINE_FW_DOC.RAD_CODE, idx_temp_quarantine_fw_doc_on_rad_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_temp_quarantine_fw_doc_on_rad_code on nios.TEMP_QUARANTINE_FW_DOC(RAD_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index TEMP_QUARANTINE_FW_DOC.XRAY_CODE, idx_temp_quarantine_fw_doc_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_temp_quarantine_fw_doc_on_xray_code on nios.TEMP_QUARANTINE_FW_DOC(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index T_CNV_DOCTORH_DISTRICT.DOCTOR_CODE, idx_t_cnv_doctorh_district_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_cnv_doctorh_district_on_doctor_code on nios.T_CNV_DOCTORH_DISTRICT(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index T_CNV_DOCTOR_DISTRICT.DOCTOR_CODE, idx_t_cnv_doctor_district_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_cnv_doctor_district_on_doctor_code on nios.T_CNV_DOCTOR_DISTRICT(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index T_CNV_EMPLOYERH_DISTRICT.EMPLOYER_CODE, idx_t_cnv_employerh_district_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_cnv_employerh_district_on_employer_code on nios.T_CNV_EMPLOYERH_DISTRICT(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index T_CNV_EMPLOYER_DISTRICT.EMPLOYER_CODE, idx_t_cnv_employer_district_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_cnv_employer_district_on_employer_code on nios.T_CNV_EMPLOYER_DISTRICT(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index T_CNV_LABORATORYH_DISTRICT.LABORATORY_CODE, idx_t_cnv_laboratoryh_district_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_cnv_laboratoryh_district_on_laboratory_code on nios.T_CNV_LABORATORYH_DISTRICT(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index T_CNV_LABORATORY_DISTRICT.LABORATORY_CODE, idx_t_cnv_laboratory_district_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_cnv_laboratory_district_on_laboratory_code on nios.T_CNV_LABORATORY_DISTRICT(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index T_CNV_WORKER_DOCTOR.WORKER_CODE, idx_t_cnv_worker_doctor_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_cnv_worker_doctor_on_worker_code on nios.T_CNV_WORKER_DOCTOR(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index T_CNV_WORKER_DOCTOR.DOCTOR_CODE, idx_t_cnv_worker_doctor_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_cnv_worker_doctor_on_doctor_code on nios.T_CNV_WORKER_DOCTOR(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index T_CNV_WORKER_DOCTOR_A.WORKER_CODE, idx_t_cnv_worker_doctor_a_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_cnv_worker_doctor_a_on_worker_code on nios.T_CNV_WORKER_DOCTOR_A(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index T_CNV_WORKER_DOCTOR_A.DOCTOR_CODE, idx_t_cnv_worker_doctor_a_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_cnv_worker_doctor_a_on_doctor_code on nios.T_CNV_WORKER_DOCTOR_A(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index T_CNV_XRAYH_DISTRICT.XRAY_CODE, idx_t_cnv_xrayh_district_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_cnv_xrayh_district_on_xray_code on nios.T_CNV_XRAYH_DISTRICT(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index T_CNV_XRAY_DISTRICT.XRAY_CODE, idx_t_cnv_xray_district_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_cnv_xray_district_on_xray_code on nios.T_CNV_XRAY_DISTRICT(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index T_CONV_FIN_NONGROUP_DOCTOR.DOCTOR_CODE, idx_t_conv_fin_nongroup_doctor_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_conv_fin_nongroup_doctor_on_doctor_code on nios.T_CONV_FIN_NONGROUP_DOCTOR(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index T_CONV_FIN_NONGROUP_DOCTOR_DTL.DOCTOR_CODE, idx_t_conv_fin_nongroup_doctor_dtl_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_conv_fin_nongroup_doctor_dtl_on_doctor_code on nios.T_CONV_FIN_NONGROUP_DOCTOR_DTL(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index T_CONV_FIN_NONGROUP_XRAY.XRAY_CODE, idx_t_conv_fin_nongroup_xray_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_conv_fin_nongroup_xray_on_xray_code on nios.T_CONV_FIN_NONGROUP_XRAY(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index T_CONV_FIN_NONGROUP_XRAY_DTL.XRAY_CODE, idx_t_conv_fin_nongroup_xray_dtl_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_conv_fin_nongroup_xray_dtl_on_xray_code on nios.T_CONV_FIN_NONGROUP_XRAY_DTL(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index T_WPC.ERR_CODE, idx_t_wpc_on_err_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_wpc_on_err_code on nios.T_WPC(ERR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index T_WPC.WORKER_CODE, idx_t_wpc_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_wpc_on_worker_code on nios.T_WPC(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index T_WPC.OLD_WORKER_CODE, idx_t_wpc_on_old_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_wpc_on_old_worker_code on nios.T_WPC(OLD_WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index T_WPC.EMPLOYER_CODE, idx_t_wpc_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_wpc_on_employer_code on nios.T_WPC(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index T_WPC.OLD_EMPLOYER_CODE, idx_t_wpc_on_old_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_t_wpc_on_old_employer_code on nios.T_WPC(OLD_EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index UNDEFINE_DOCTOR.DOCTOR_CODE, idx_undefine_doctor_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_undefine_doctor_on_doctor_code on nios.UNDEFINE_DOCTOR(DOCTOR_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index UNDEFINE_DOCTOR.POST_CODE, idx_undefine_doctor_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_undefine_doctor_on_post_code on nios.UNDEFINE_DOCTOR(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index UNDEFINE_DOCTOR.STATE_CODE, idx_undefine_doctor_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_undefine_doctor_on_state_code on nios.UNDEFINE_DOCTOR(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index UNDEFINE_DOCTOR.DISTRICT_CODE, idx_undefine_doctor_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_undefine_doctor_on_district_code on nios.UNDEFINE_DOCTOR(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index UNDEFINE_DOCTOR.COUNTRY_CODE, idx_undefine_doctor_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_undefine_doctor_on_country_code on nios.UNDEFINE_DOCTOR(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index UNDEFINE_DOCTOR.RADIOLOGIST_CODE, idx_undefine_doctor_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_undefine_doctor_on_radiologist_code on nios.UNDEFINE_DOCTOR(RADIOLOGIST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index UNDEFINE_DOCTOR.XRAY_CODE, idx_undefine_doctor_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_undefine_doctor_on_xray_code on nios.UNDEFINE_DOCTOR(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index UNDEFINE_DOCTOR.LABORATORY_CODE, idx_undefine_doctor_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_undefine_doctor_on_laboratory_code on nios.UNDEFINE_DOCTOR(LABORATORY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index UNDEFINE_DOCTOR.STATUS_CODE, idx_undefine_doctor_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_undefine_doctor_on_status_code on nios.UNDEFINE_DOCTOR(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index UNSUITABLE_REASONS_MAP.PARAMETER_CODE, idx_unsuitable_reasons_map_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_unsuitable_reasons_map_on_parameter_code on nios.UNSUITABLE_REASONS_MAP(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index USEROLDPASS.USERCODE, idx_useroldpass_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_useroldpass_on_usercode on nios.USEROLDPASS(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index USERS.USERCODE, idx_users_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_users_on_usercode on nios.USERS(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index USER_BRANCHES.BRANCH_CODE, idx_user_branches_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_user_branches_on_branch_code on nios.USER_BRANCHES(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index USER_COMMENTS.USERCODE, idx_user_comments_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_user_comments_on_usercode on nios.USER_COMMENTS(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index USER_SESSION.BRANCH_CODE, idx_user_session_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_user_session_on_branch_code on nios.USER_SESSION(BRANCH_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index VISIT_PLAN_DETAIL.STATE_CODE, idx_visit_plan_detail_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_visit_plan_detail_on_state_code on nios.VISIT_PLAN_DETAIL(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index VISIT_PLAN_DETAIL.DISTRICT_CODE, idx_visit_plan_detail_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_visit_plan_detail_on_district_code on nios.VISIT_PLAN_DETAIL(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index VISIT_RPT_DOCXRAY.PROVIDER_CODE, idx_visit_rpt_docxray_on_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_visit_rpt_docxray_on_provider_code on nios.VISIT_RPT_DOCXRAY(PROVIDER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index VISIT_RPT_FOLLOWUP.SERVICE_PROVIDER_CODE, idx_visit_rpt_followup_on_service_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_visit_rpt_followup_on_service_provider_code on nios.VISIT_RPT_FOLLOWUP(SERVICE_PROVIDER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;





begin
    insert into copy_logs (description, begin_at) values ('start index VISIT_RPT_XQCC.PROVIDER_CODE, idx_visit_rpt_xqcc_on_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_visit_rpt_xqcc_on_provider_code on nios.VISIT_RPT_XQCC(PROVIDER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index V_APPEAL_STATUS.TRANS_ID, idx_v_appeal_status_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_appeal_status_on_trans_id on nios.V_APPEAL_STATUS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index V_APPEAL_STATUS.WORKER_CODE, idx_v_appeal_status_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_appeal_status_on_worker_code on nios.V_APPEAL_STATUS(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index V_WORKER_CLINIC.WORKER_CODE, idx_v_worker_clinic_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_worker_clinic_on_worker_code on nios.V_WORKER_CLINIC(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index V_WORKER_CLINIC.COUNTRY_CODE, idx_v_worker_clinic_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_worker_clinic_on_country_code on nios.V_WORKER_CLINIC(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index V_WORKER_CLINIC.CLINIC_CODE, idx_v_worker_clinic_on_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_v_worker_clinic_on_clinic_code on nios.V_WORKER_CLINIC(CLINIC_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_CANCEL_DETAIL.TRANS_ID, idx_worker_cancel_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_cancel_detail_on_trans_id on nios.WORKER_CANCEL_DETAIL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_CERTIFY_FITIND.TRANS_ID, idx_worker_certify_fitind_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_certify_fitind_on_trans_id on nios.WORKER_CERTIFY_FITIND(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_CERTIFY_FITIND.WORKER_CODE, idx_worker_certify_fitind_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_certify_fitind_on_worker_code on nios.WORKER_CERTIFY_FITIND(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_COUNTRY_DIST.COUNTRY_CODE, idx_worker_country_dist_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_country_dist_on_country_code on nios.WORKER_COUNTRY_DIST(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_DOCTOR_CHANGE.TRANS_ID, idx_worker_doctor_change_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_doctor_change_on_trans_id on nios.WORKER_DOCTOR_CHANGE(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_DOCTOR_CHANGE_HIST.TRANS_ID, idx_worker_doctor_change_hist_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_doctor_change_hist_on_trans_id on nios.WORKER_DOCTOR_CHANGE_HIST(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_FITIND_CHANGE.TRANS_ID, idx_worker_fitind_change_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_fitind_change_on_trans_id on nios.WORKER_FITIND_CHANGE(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index WORKER_UPD.WORKER_CODE, idx_worker_upd_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_worker_upd_on_worker_code on nios.WORKER_UPD(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index WRONG_TRANSMISSION.TRANS_ID, idx_wrong_transmission_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_wrong_transmission_on_trans_id on nios.WRONG_TRANSMISSION(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index WRONG_TRANSMISSION.PROVIDER_CODE, idx_wrong_transmission_on_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_wrong_transmission_on_provider_code on nios.WRONG_TRANSMISSION(PROVIDER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index WS_ACCESS_TOKEN.USERCODE, idx_ws_access_token_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_ws_access_token_on_usercode on nios.WS_ACCESS_TOKEN(USERCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_CALLLOG.XRAY_CODE, idx_xqcc_calllog_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_calllog_on_xray_code on nios.XQCC_CALLLOG(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_COMMENT.WORKER_CODE, idx_xqcc_comment_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_comment_on_worker_code on nios.XQCC_COMMENT(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_FW_EXTRA_COMMENTS.TRANS_ID, idx_xqcc_fw_extra_comments_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_fw_extra_comments_on_trans_id on nios.XQCC_FW_EXTRA_COMMENTS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_QUARANTINE_FW_DOC.TRANS_ID, idx_xqcc_quarantine_fw_doc_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_trans_id on nios.XQCC_QUARANTINE_FW_DOC(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_QUARANTINE_FW_DOC.FW_CODE, idx_xqcc_quarantine_fw_doc_on_fw_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_fw_code on nios.XQCC_QUARANTINE_FW_DOC(FW_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_QUARANTINE_FW_DOC.DOC_CODE, idx_xqcc_quarantine_fw_doc_on_doc_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_doc_code on nios.XQCC_QUARANTINE_FW_DOC(DOC_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_QUARANTINE_FW_DOC.EMPLOYER_CODE, idx_xqcc_quarantine_fw_doc_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_employer_code on nios.XQCC_QUARANTINE_FW_DOC(EMPLOYER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_QUARANTINE_FW_DOC.LAB_CODE, idx_xqcc_quarantine_fw_doc_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_lab_code on nios.XQCC_QUARANTINE_FW_DOC(LAB_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_QUARANTINE_FW_DOC.RAD_CODE, idx_xqcc_quarantine_fw_doc_on_rad_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_rad_code on nios.XQCC_QUARANTINE_FW_DOC(RAD_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_QUARANTINE_FW_DOC.XRAY_CODE, idx_xqcc_quarantine_fw_doc_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_xray_code on nios.XQCC_QUARANTINE_FW_DOC(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_QUARANTINE_FW_DOC.L1_BLOOD_BARCODENO, idx_xqcc_quarantine_fw_doc_on_l1_blood_barcodeno', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_l1_blood_barcodeno on nios.XQCC_QUARANTINE_FW_DOC(L1_BLOOD_BARCODENO);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_QUARANTINE_FW_DOC.L1_URINE_BARCODENO, idx_xqcc_quarantine_fw_doc_on_l1_urine_barcodeno', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_l1_urine_barcodeno on nios.XQCC_QUARANTINE_FW_DOC(L1_URINE_BARCODENO);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_QUARANTINE_FW_REASON.TRANS_ID, idx_xqcc_quarantine_fw_reason_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_quarantine_fw_reason_on_trans_id on nios.XQCC_QUARANTINE_FW_REASON(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_QUARANTINE_FW_REASON.REASON_CODE, idx_xqcc_quarantine_fw_reason_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_quarantine_fw_reason_on_reason_code on nios.XQCC_QUARANTINE_FW_REASON(REASON_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_REPORT.TRANS_ID, idx_xqcc_report_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_report_on_trans_id on nios.XQCC_REPORT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_STAT_CHANGE_REASONS.REASONCODE, idx_xqcc_stat_change_reasons_on_reasoncode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_stat_change_reasons_on_reasoncode on nios.XQCC_STAT_CHANGE_REASONS(REASONCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_STAT_CHANGE_REQUEST.REASONCODE, idx_xqcc_stat_change_request_on_reasoncode', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_stat_change_request_on_reasoncode on nios.XQCC_STAT_CHANGE_REQUEST(REASONCODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_TRANSID.TRANS_ID, idx_xqcc_transid_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_transid_on_trans_id on nios.XQCC_TRANSID(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XQCC_UNFIT.TRANS_ID, idx_xqcc_unfit_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xqcc_unfit_on_trans_id on nios.XQCC_UNFIT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index XQUARANTINE_RELEASE_REQUEST.TRANS_ID, idx_xquarantine_release_request_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xquarantine_release_request_on_trans_id on nios.XQUARANTINE_RELEASE_REQUEST(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_ADHOC_SUBMIT_ABNORMAL.TRANS_ID, idx_xray_adhoc_submit_abnormal_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_adhoc_submit_abnormal_on_trans_id on nios.XRAY_ADHOC_SUBMIT_ABNORMAL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_ADHOC_SUBMIT_ABNORMAL.XRAY_CODE, idx_xray_adhoc_submit_abnormal_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_adhoc_submit_abnormal_on_xray_code on nios.XRAY_ADHOC_SUBMIT_ABNORMAL(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_ADHOC_SUBMIT_ABNORMAL.WORKER_CODE, idx_xray_adhoc_submit_abnormal_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_adhoc_submit_abnormal_on_worker_code on nios.XRAY_ADHOC_SUBMIT_ABNORMAL(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_ADHOC_SUBMIT_DELAY.TRANS_ID, idx_xray_adhoc_submit_delay_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_adhoc_submit_delay_on_trans_id on nios.XRAY_ADHOC_SUBMIT_DELAY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_ADHOC_SUBMIT_DELAY.XRAY_CODE, idx_xray_adhoc_submit_delay_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_adhoc_submit_delay_on_xray_code on nios.XRAY_ADHOC_SUBMIT_DELAY(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_ADHOC_SUBMIT_DELAY.WORKER_CODE, idx_xray_adhoc_submit_delay_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_adhoc_submit_delay_on_worker_code on nios.XRAY_ADHOC_SUBMIT_DELAY(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_ADHOC_SUBMIT_NORMAL.TRANS_ID, idx_xray_adhoc_submit_normal_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_adhoc_submit_normal_on_trans_id on nios.XRAY_ADHOC_SUBMIT_NORMAL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_ADHOC_SUBMIT_NORMAL.XRAY_CODE, idx_xray_adhoc_submit_normal_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_adhoc_submit_normal_on_xray_code on nios.XRAY_ADHOC_SUBMIT_NORMAL(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_ADHOC_SUBMIT_NORMAL.WORKER_CODE, idx_xray_adhoc_submit_normal_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_adhoc_submit_normal_on_worker_code on nios.XRAY_ADHOC_SUBMIT_NORMAL(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_CHANGE_REQUEST.XRAY_CODE, idx_xray_change_request_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_change_request_on_xray_code on nios.XRAY_CHANGE_REQUEST(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_COMPARE.XRAY_CODE, idx_xray_compare_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_compare_on_xray_code on nios.XRAY_COMPARE(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;




begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_DISPATCH_LIST_DETAILS.TRANS_ID, idx_xray_dispatch_list_details_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_dispatch_list_details_on_trans_id on nios.XRAY_DISPATCH_LIST_DETAILS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_FILM_AUDIT.TRANS_ID, idx_xray_film_audit_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_film_audit_on_trans_id on nios.XRAY_FILM_AUDIT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_FILM_MOVEMENT.TRANS_ID, idx_xray_film_movement_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_film_movement_on_trans_id on nios.XRAY_FILM_MOVEMENT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_FILM_REMINDER.TRANS_ID, idx_xray_film_reminder_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_film_reminder_on_trans_id on nios.XRAY_FILM_REMINDER(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_FILM_STORAGE_DETAIL.TRANS_ID, idx_xray_film_storage_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_film_storage_detail_on_trans_id on nios.XRAY_FILM_STORAGE_DETAIL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_FOLLOW_UP.TRANS_ID, idx_xray_follow_up_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_follow_up_on_trans_id on nios.XRAY_FOLLOW_UP(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_NOT_DONE.TRANS_ID, idx_xray_not_done_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_not_done_on_trans_id on nios.XRAY_NOT_DONE(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_NOT_DONE.XRAY_CODE, idx_xray_not_done_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_not_done_on_xray_code on nios.XRAY_NOT_DONE(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_NOT_DONE.WORKER_CODE, idx_xray_not_done_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_not_done_on_worker_code on nios.XRAY_NOT_DONE(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_PAYIN_LIST.XRAY_CODE, idx_xray_payin_list_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_payin_list_on_xray_code on nios.XRAY_PAYIN_LIST(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_PAYIN_LIST.POST_CODE, idx_xray_payin_list_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_payin_list_on_post_code on nios.XRAY_PAYIN_LIST(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_PAYIN_LIST.DISTRICT_CODE, idx_xray_payin_list_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_payin_list_on_district_code on nios.XRAY_PAYIN_LIST(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_PAYIN_LIST.STATE_CODE, idx_xray_payin_list_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_payin_list_on_state_code on nios.XRAY_PAYIN_LIST(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_RADIO_ASSIGNMENT.TRANS_ID, idx_xray_radio_assignment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_radio_assignment_on_trans_id on nios.XRAY_RADIO_ASSIGNMENT(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_REGISTRATION.POST_CODE, idx_xray_registration_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_registration_on_post_code on nios.XRAY_REGISTRATION(POST_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_REGISTRATION.DISTRICT_CODE, idx_xray_registration_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_registration_on_district_code on nios.XRAY_REGISTRATION(DISTRICT_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_REGISTRATION.STATE_CODE, idx_xray_registration_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_registration_on_state_code on nios.XRAY_REGISTRATION(STATE_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_REGISTRATION.COUNTRY_CODE, idx_xray_registration_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_registration_on_country_code on nios.XRAY_REGISTRATION(COUNTRY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_REGISTRATION.STATUS_CODE, idx_xray_registration_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_registration_on_status_code on nios.XRAY_REGISTRATION(STATUS_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;



begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_REVIEW_FILM.TRANS_ID, idx_xray_review_film_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_review_film_on_trans_id on nios.XRAY_REVIEW_FILM(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_REVIEW_FILM.XRAY_CODE, idx_xray_review_film_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_review_film_on_xray_code on nios.XRAY_REVIEW_FILM(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_REVIEW_FILM.WORKER_CODE, idx_xray_review_film_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_review_film_on_worker_code on nios.XRAY_REVIEW_FILM(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_REVIEW_FILM_COMMENTS.TRANS_ID, idx_xray_review_film_comments_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_review_film_comments_on_trans_id on nios.XRAY_REVIEW_FILM_COMMENTS(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_REVIEW_FILM_DETAIL.TRANS_ID, idx_xray_review_film_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_review_film_detail_on_trans_id on nios.XRAY_REVIEW_FILM_DETAIL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_REVIEW_FILM_DETAIL.PARAMETER_CODE, idx_xray_review_film_detail_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_review_film_detail_on_parameter_code on nios.XRAY_REVIEW_FILM_DETAIL(PARAMETER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_REVIEW_FILM_IDENTICAL.TRANS_ID, idx_xray_review_film_identical_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_review_film_identical_on_trans_id on nios.XRAY_REVIEW_FILM_IDENTICAL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_REVIEW_FILM_IDENTICAL.WORKER_CODE, idx_xray_review_film_identical_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_review_film_identical_on_worker_code on nios.XRAY_REVIEW_FILM_IDENTICAL(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_DAILY.TRANS_ID, idx_xray_submit_daily_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_daily_on_trans_id on nios.XRAY_SUBMIT_DAILY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_DAILY.XRAY_CODE, idx_xray_submit_daily_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_daily_on_xray_code on nios.XRAY_SUBMIT_DAILY(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_DAILY.WORKER_CODE, idx_xray_submit_daily_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_daily_on_worker_code on nios.XRAY_SUBMIT_DAILY(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_DAILY_ABNORMAL.TRANS_ID, idx_xray_submit_daily_abnormal_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_daily_abnormal_on_trans_id on nios.XRAY_SUBMIT_DAILY_ABNORMAL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_DAILY_ABNORMAL.XRAY_CODE, idx_xray_submit_daily_abnormal_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_daily_abnormal_on_xray_code on nios.XRAY_SUBMIT_DAILY_ABNORMAL(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_DAILY_ABNORMAL.WORKER_CODE, idx_xray_submit_daily_abnormal_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_daily_abnormal_on_worker_code on nios.XRAY_SUBMIT_DAILY_ABNORMAL(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_DAILY_NORMAL.TRANS_ID, idx_xray_submit_daily_normal_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_daily_normal_on_trans_id on nios.XRAY_SUBMIT_DAILY_NORMAL(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_DAILY_NORMAL.XRAY_CODE, idx_xray_submit_daily_normal_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_daily_normal_on_xray_code on nios.XRAY_SUBMIT_DAILY_NORMAL(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_DAILY_NORMAL.WORKER_CODE, idx_xray_submit_daily_normal_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_daily_normal_on_worker_code on nios.XRAY_SUBMIT_DAILY_NORMAL(WORKER_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;


begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_DELAY.TRANS_ID, idx_xray_submit_delay_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_delay_on_trans_id on nios.XRAY_SUBMIT_DELAY(TRANS_ID);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_DELAY.XRAY_CODE, idx_xray_submit_delay_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_delay_on_xray_code on nios.XRAY_SUBMIT_DELAY(XRAY_CODE);

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

commit;

begin
    insert into copy_logs (description, begin_at) values ('start index XRAY_SUBMIT_DELAY.WORKER_CODE, idx_xray_submit_delay_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;

    create index if not exists idx_xray_submit_delay_on_worker_code on nios.XRAY_SUBMIT_DELAY(WORKER_CODE);

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
