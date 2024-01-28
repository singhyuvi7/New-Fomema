
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_item bigint;
begin
    insert into public.migration_logs (description, start_at) values ('start index nios transaction process', clock_timestamp()) returning id into v_copy_log_id_process;




insert into public.migration_logs (description, start_at) values ('start index adminusers.usercode, idx_adminusers_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_adminusers_on_usercode on fomema_backup_nios.adminusers(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index advance_payment.bank_code, idx_advance_payment_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_advance_payment_on_bank_code on fomema_backup_nios.advance_payment(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index advance_payment.contact_district_code, idx_advance_payment_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_advance_payment_on_contact_district_code on fomema_backup_nios.advance_payment(contact_district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index advance_payment.contact_post_code, idx_advance_payment_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_advance_payment_on_contact_post_code on fomema_backup_nios.advance_payment(contact_post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index advance_payment.contact_state_code, idx_advance_payment_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_advance_payment_on_contact_state_code on fomema_backup_nios.advance_payment(contact_state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index advance_payment.zone_code, idx_advance_payment_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_advance_payment_on_zone_code on fomema_backup_nios.advance_payment(zone_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index advance_payment.branch_code, idx_advance_payment_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_advance_payment_on_branch_code on fomema_backup_nios.advance_payment(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index advance_payment_account.branch_code, idx_advance_payment_account_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_advance_payment_account_on_branch_code on fomema_backup_nios.advance_payment_account(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index advance_payment_account.employer_code, idx_advance_payment_account_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_advance_payment_account_on_employer_code on fomema_backup_nios.advance_payment_account(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index advance_payment_group.district_code, idx_advance_payment_group_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_advance_payment_group_on_district_code on fomema_backup_nios.advance_payment_group(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index advance_payment_group.group_code, idx_advance_payment_group_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_advance_payment_group_on_group_code on fomema_backup_nios.advance_payment_group(group_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index advance_payment_group.postcode, idx_advance_payment_group_on_postcode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_advance_payment_group_on_postcode on fomema_backup_nios.advance_payment_group(postcode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index advance_payment_group.state_code, idx_advance_payment_group_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_advance_payment_group_on_state_code on fomema_backup_nios.advance_payment_group(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index ap_invoice_generated.trans_id, idx_ap_invoice_generated_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_ap_invoice_generated_on_trans_id on fomema_backup_nios.ap_invoice_generated(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index ap_invoice_generated.creditor_code, idx_ap_invoice_generated_on_creditor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_ap_invoice_generated_on_creditor_code on fomema_backup_nios.ap_invoice_generated(creditor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index appeal_fw_appeal.trans_id, idx_appeal_fw_appeal_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_appeal_fw_appeal_on_trans_id on fomema_backup_nios.appeal_fw_appeal(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index appeal_fw_appeal.appeal_doctor_code, idx_appeal_fw_appeal_on_appeal_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_appeal_fw_appeal_on_appeal_doctor_code on fomema_backup_nios.appeal_fw_appeal(appeal_doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index appeal_payment.worker_code, idx_appeal_payment_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_appeal_payment_on_worker_code on fomema_backup_nios.appeal_payment(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index appeal_payment.lab_code, idx_appeal_payment_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_appeal_payment_on_lab_code on fomema_backup_nios.appeal_payment(lab_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index appeal_todolist_map.parameter_code, idx_appeal_todolist_map_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_appeal_todolist_map_on_parameter_code on fomema_backup_nios.appeal_todolist_map(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index arch_fw_comment.trans_id, idx_arch_fw_comment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_arch_fw_comment_on_trans_id on fomema_backup_nios.arch_fw_comment(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index arch_fw_comment.parameter_code, idx_arch_fw_comment_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_arch_fw_comment_on_parameter_code on fomema_backup_nios.arch_fw_comment(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index arch_fw_detail.trans_id, idx_arch_fw_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_arch_fw_detail_on_trans_id on fomema_backup_nios.arch_fw_detail(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index arch_fw_detail.parameter_code, idx_arch_fw_detail_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_arch_fw_detail_on_parameter_code on fomema_backup_nios.arch_fw_detail(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index arch_fw_extra_comments.trans_id, idx_arch_fw_extra_comments_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_arch_fw_extra_comments_on_trans_id on fomema_backup_nios.arch_fw_extra_comments(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index arch_fw_quarantine_reason.trans_id, idx_arch_fw_quarantine_reason_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_arch_fw_quarantine_reason_on_trans_id on fomema_backup_nios.arch_fw_quarantine_reason(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index arch_fw_quarantine_reason.reason_code, idx_arch_fw_quarantine_reason_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_arch_fw_quarantine_reason_on_reason_code on fomema_backup_nios.arch_fw_quarantine_reason(reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index arch_fw_transaction.trans_id, idx_arch_fw_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_arch_fw_transaction_on_trans_id on fomema_backup_nios.arch_fw_transaction(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index arch_fw_transaction.doctor_code, idx_arch_fw_transaction_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_arch_fw_transaction_on_doctor_code on fomema_backup_nios.arch_fw_transaction(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index arch_fw_transaction.employer_code, idx_arch_fw_transaction_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_arch_fw_transaction_on_employer_code on fomema_backup_nios.arch_fw_transaction(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index arch_fw_transaction.laboratory_code, idx_arch_fw_transaction_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_arch_fw_transaction_on_laboratory_code on fomema_backup_nios.arch_fw_transaction(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index arch_fw_transaction.radiologist_code, idx_arch_fw_transaction_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_arch_fw_transaction_on_radiologist_code on fomema_backup_nios.arch_fw_transaction(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index arch_fw_transaction.xray_code, idx_arch_fw_transaction_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_arch_fw_transaction_on_xray_code on fomema_backup_nios.arch_fw_transaction(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index arch_fw_transaction.worker_code, idx_arch_fw_transaction_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_arch_fw_transaction_on_worker_code on fomema_backup_nios.arch_fw_transaction(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index bad_payment.bank_code, idx_bad_payment_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_bad_payment_on_bank_code on fomema_backup_nios.bad_payment(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index bad_payment.contact_post_code, idx_bad_payment_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_bad_payment_on_contact_post_code on fomema_backup_nios.bad_payment(contact_post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index bad_payment.contact_state_code, idx_bad_payment_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_bad_payment_on_contact_state_code on fomema_backup_nios.bad_payment(contact_state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index bad_payment.contact_district_code, idx_bad_payment_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_bad_payment_on_contact_district_code on fomema_backup_nios.bad_payment(contact_district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index bank_draft_expiry.bank_code, idx_bank_draft_expiry_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_bank_draft_expiry_on_bank_code on fomema_backup_nios.bank_draft_expiry(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index barcode_transaction.trans_id, idx_barcode_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_barcode_transaction_on_trans_id on fomema_backup_nios.barcode_transaction(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index barcode_transaction.employer_code, idx_barcode_transaction_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_barcode_transaction_on_employer_code on fomema_backup_nios.barcode_transaction(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;





insert into public.migration_logs (description, start_at) values ('start index batchusers.usercode, idx_batchusers_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_batchusers_on_usercode on fomema_backup_nios.batchusers(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index branches.branch_code, idx_branches_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_branches_on_branch_code on fomema_backup_nios.branches(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index branches.post_code, idx_branches_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_branches_on_post_code on fomema_backup_nios.branches(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index branches.bank_code, idx_branches_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_branches_on_bank_code on fomema_backup_nios.branches(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index branch_printers.branch_code, idx_branch_printers_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_branch_printers_on_branch_code on fomema_backup_nios.branch_printers(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index bulletin_acknowledge.usercode, idx_bulletin_acknowledge_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_bulletin_acknowledge_on_usercode on fomema_backup_nios.bulletin_acknowledge(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index bulletin_target.usercode, idx_bulletin_target_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_bulletin_target_on_usercode on fomema_backup_nios.bulletin_target(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index cng_worker_clinic.worker_code, idx_cng_worker_clinic_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_cng_worker_clinic_on_worker_code on fomema_backup_nios.cng_worker_clinic(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index cng_worker_clinic.country_code, idx_cng_worker_clinic_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_cng_worker_clinic_on_country_code on fomema_backup_nios.cng_worker_clinic(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index cng_worker_clinic.clinic_code, idx_cng_worker_clinic_on_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_cng_worker_clinic_on_clinic_code on fomema_backup_nios.cng_worker_clinic(clinic_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index code_m.state_code, idx_code_m_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_code_m_on_state_code on fomema_backup_nios.code_m(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index condition_map.parameter_code, idx_condition_map_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_condition_map_on_parameter_code on fomema_backup_nios.condition_map(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index condition_map.old_parameter_code, idx_condition_map_on_old_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_condition_map_on_old_parameter_code on fomema_backup_nios.condition_map(old_parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index customer_complaint.complaint_code, idx_customer_complaint_on_complaint_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_customer_complaint_on_complaint_code on fomema_backup_nios.customer_complaint(complaint_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index customer_complaint.complaint_against_code, idx_customer_complaint_on_complaint_against_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_customer_complaint_on_complaint_against_code on fomema_backup_nios.customer_complaint(complaint_against_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index delay_trans.doctor_code, idx_delay_trans_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_delay_trans_on_doctor_code on fomema_backup_nios.delay_trans(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index delay_trans.worker_code, idx_delay_trans_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_delay_trans_on_worker_code on fomema_backup_nios.delay_trans(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index diff_rh.branch_code, idx_diff_rh_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_diff_rh_on_branch_code on fomema_backup_nios.diff_rh(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index discrp_tab.fcode, idx_discrp_tab_on_fcode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_discrp_tab_on_fcode on fomema_backup_nios.discrp_tab(fcode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index discrp_tab.ecode, idx_discrp_tab_on_ecode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_discrp_tab_on_ecode on fomema_backup_nios.discrp_tab(ecode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index discrp_tab.a_fcode, idx_discrp_tab_on_a_fcode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_discrp_tab_on_a_fcode on fomema_backup_nios.discrp_tab(a_fcode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index district_map.district_map_code, idx_district_map_on_district_map_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_district_map_on_district_map_code on fomema_backup_nios.district_map(district_map_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index district_office.office_code, idx_district_office_on_office_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_district_office_on_office_code on fomema_backup_nios.district_office(office_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index district_office.post_code, idx_district_office_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_district_office_on_post_code on fomema_backup_nios.district_office(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index district_office.district_code, idx_district_office_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_district_office_on_district_code on fomema_backup_nios.district_office(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index district_office.state_code, idx_district_office_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_district_office_on_state_code on fomema_backup_nios.district_office(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index district_office.status_code, idx_district_office_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_district_office_on_status_code on fomema_backup_nios.district_office(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index doc_compare.doctor_code, idx_doc_compare_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doc_compare_on_doctor_code on fomema_backup_nios.doc_compare(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doc_compare.old_radiologist_code, idx_doc_compare_on_old_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doc_compare_on_old_radiologist_code on fomema_backup_nios.doc_compare(old_radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doc_compare.old_xray_code, idx_doc_compare_on_old_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doc_compare_on_old_xray_code on fomema_backup_nios.doc_compare(old_xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doc_compare.old_laboratory_code, idx_doc_compare_on_old_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doc_compare_on_old_laboratory_code on fomema_backup_nios.doc_compare(old_laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doc_compare.new_radiologist_code, idx_doc_compare_on_new_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doc_compare_on_new_radiologist_code on fomema_backup_nios.doc_compare(new_radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doc_compare.new_xray_code, idx_doc_compare_on_new_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doc_compare_on_new_xray_code on fomema_backup_nios.doc_compare(new_xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doc_compare.new_laboratory_code, idx_doc_compare_on_new_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doc_compare_on_new_laboratory_code on fomema_backup_nios.doc_compare(new_laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index doc_lab_allocation.doctor_code, idx_doc_lab_allocation_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doc_lab_allocation_on_doctor_code on fomema_backup_nios.doc_lab_allocation(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index doc_quota_allocation.doctor_code, idx_doc_quota_allocation_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doc_quota_allocation_on_doctor_code on fomema_backup_nios.doc_quota_allocation(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index doc_status.doctor_code, idx_doc_status_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doc_status_on_doctor_code on fomema_backup_nios.doc_status(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index doctor_change_request.doctor_code, idx_doctor_change_request_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_change_request_on_doctor_code on fomema_backup_nios.doctor_change_request(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index doctor_load_6p.doctor_code, idx_doctor_load_6p_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_load_6p_on_doctor_code on fomema_backup_nios.doctor_load_6p(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_load_6p.dist_code, idx_doctor_load_6p_on_dist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_load_6p_on_dist_code on fomema_backup_nios.doctor_load_6p(dist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_load_6p.state_code, idx_doctor_load_6p_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_load_6p_on_state_code on fomema_backup_nios.doctor_load_6p(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index doctor_opthour.usercode, idx_doctor_opthour_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_opthour_on_usercode on fomema_backup_nios.doctor_opthour(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index doctor_quota_trans.doctor_code, idx_doctor_quota_trans_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_quota_trans_on_doctor_code on fomema_backup_nios.doctor_quota_trans(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index doctor_registration.post_code, idx_doctor_registration_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_registration_on_post_code on fomema_backup_nios.doctor_registration(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_registration.state_code, idx_doctor_registration_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_registration_on_state_code on fomema_backup_nios.doctor_registration(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_registration.district_code, idx_doctor_registration_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_registration_on_district_code on fomema_backup_nios.doctor_registration(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_registration.country_code, idx_doctor_registration_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_registration_on_country_code on fomema_backup_nios.doctor_registration(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_registration.status_code, idx_doctor_registration_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_registration_on_status_code on fomema_backup_nios.doctor_registration(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_registration.prefer_xray_code, idx_doctor_registration_on_prefer_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_registration_on_prefer_xray_code on fomema_backup_nios.doctor_registration(prefer_xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_registration.rcm_xray_code1, idx_doctor_registration_on_rcm_xray_code1', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_registration_on_rcm_xray_code1 on fomema_backup_nios.doctor_registration(rcm_xray_code1);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_registration.rcm_xray_code2, idx_doctor_registration_on_rcm_xray_code2', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_registration_on_rcm_xray_code2 on fomema_backup_nios.doctor_registration(rcm_xray_code2);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_registration.rcm_xray_code3, idx_doctor_registration_on_rcm_xray_code3', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_registration_on_rcm_xray_code3 on fomema_backup_nios.doctor_registration(rcm_xray_code3);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index doc_xray_allocation.doctor_code, idx_doc_xray_allocation_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doc_xray_allocation_on_doctor_code on fomema_backup_nios.doc_xray_allocation(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index draft_allocation.employer_code, idx_draft_allocation_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_draft_allocation_on_employer_code on fomema_backup_nios.draft_allocation(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index draft_usage.trans_id, idx_draft_usage_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_draft_usage_on_trans_id on fomema_backup_nios.draft_usage(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index draft_usage.employer_code, idx_draft_usage_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_draft_usage_on_employer_code on fomema_backup_nios.draft_usage(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index draft_usage.worker_code, idx_draft_usage_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_draft_usage_on_worker_code on fomema_backup_nios.draft_usage(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index draft_usage.branch_code, idx_draft_usage_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_draft_usage_on_branch_code on fomema_backup_nios.draft_usage(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index dxbasket.trans_id, idx_dxbasket_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxbasket_on_trans_id on fomema_backup_nios.dxbasket(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index dxbasket.xray_code, idx_dxbasket_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxbasket_on_xray_code on fomema_backup_nios.dxbasket(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index dxfilm_audit.trans_id, idx_dxfilm_audit_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxfilm_audit_on_trans_id on fomema_backup_nios.dxfilm_audit(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index dxfilm_audit.worker_code, idx_dxfilm_audit_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxfilm_audit_on_worker_code on fomema_backup_nios.dxfilm_audit(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index dxfilm_movement.trans_id, idx_dxfilm_movement_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxfilm_movement_on_trans_id on fomema_backup_nios.dxfilm_movement(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index dx_payblock.doc_xray_code, idx_dx_payblock_on_doc_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dx_payblock_on_doc_xray_code on fomema_backup_nios.dx_payblock(doc_xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index dxpcr_audit_comment.parameter_code, idx_dxpcr_audit_comment_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxpcr_audit_comment_on_parameter_code on fomema_backup_nios.dxpcr_audit_comment(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index dxpcr_audit_detail.parameter_code, idx_dxpcr_audit_detail_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxpcr_audit_detail_on_parameter_code on fomema_backup_nios.dxpcr_audit_detail(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index dxpcr_audit_film.trans_id, idx_dxpcr_audit_film_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxpcr_audit_film_on_trans_id on fomema_backup_nios.dxpcr_audit_film(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index dxpcr_audit_film.pcr_code, idx_dxpcr_audit_film_on_pcr_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxpcr_audit_film_on_pcr_code on fomema_backup_nios.dxpcr_audit_film(pcr_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index dxpcr_audit_film.worker_code, idx_dxpcr_audit_film_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxpcr_audit_film_on_worker_code on fomema_backup_nios.dxpcr_audit_film(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index dxpcr_audit_film.xray_code, idx_dxpcr_audit_film_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxpcr_audit_film_on_xray_code on fomema_backup_nios.dxpcr_audit_film(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index dxpcr_pool.trans_id, idx_dxpcr_pool_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxpcr_pool_on_trans_id on fomema_backup_nios.dxpcr_pool(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index dxpcr_pool.pcr_code, idx_dxpcr_pool_on_pcr_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxpcr_pool_on_pcr_code on fomema_backup_nios.dxpcr_pool(pcr_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index dxpcr_pool.radiologist_code, idx_dxpcr_pool_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxpcr_pool_on_radiologist_code on fomema_backup_nios.dxpcr_pool(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index dxreview_film.trans_id, idx_dxreview_film_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxreview_film_on_trans_id on fomema_backup_nios.dxreview_film(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index dxreview_film.worker_code, idx_dxreview_film_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxreview_film_on_worker_code on fomema_backup_nios.dxreview_film(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index dxreview_film.xray_code, idx_dxreview_film_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxreview_film_on_xray_code on fomema_backup_nios.dxreview_film(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index dxreview_film.id, idx_dxreview_film_on_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxreview_film_on_id on fomema_backup_nios.dxreview_film(id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index dxreview_film_detail.parameter_code, idx_dxreview_film_detail_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxreview_film_detail_on_parameter_code on fomema_backup_nios.dxreview_film_detail(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index dxreview_film_identical.trans_id, idx_dxreview_film_identical_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxreview_film_identical_on_trans_id on fomema_backup_nios.dxreview_film_identical(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index dxreview_film_identical.worker_code, idx_dxreview_film_identical_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxreview_film_identical_on_worker_code on fomema_backup_nios.dxreview_film_identical(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index dxxray_audit.trans_id, idx_dxxray_audit_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxxray_audit_on_trans_id on fomema_backup_nios.dxxray_audit(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index dxxray_audit.worker_code, idx_dxxray_audit_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_dxxray_audit_on_worker_code on fomema_backup_nios.dxxray_audit(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index employer_account.trans_id, idx_employer_account_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_account_on_trans_id on fomema_backup_nios.employer_account(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_account.employer_code, idx_employer_account_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_account_on_employer_code on fomema_backup_nios.employer_account(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_account.worker_code, idx_employer_account_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_account_on_worker_code on fomema_backup_nios.employer_account(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_account.branch_code, idx_employer_account_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_account_on_branch_code on fomema_backup_nios.employer_account(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index employer_alloc_detail.employer_code, idx_employer_alloc_detail_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_alloc_detail_on_employer_code on fomema_backup_nios.employer_alloc_detail(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index employer_cn.branch_code, idx_employer_cn_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_cn_on_branch_code on fomema_backup_nios.employer_cn(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_cn.employer_code, idx_employer_cn_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_cn_on_employer_code on fomema_backup_nios.employer_cn(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index employer_notification.trans_id, idx_employer_notification_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_notification_on_trans_id on fomema_backup_nios.employer_notification(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_notification.worker_code, idx_employer_notification_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_notification_on_worker_code on fomema_backup_nios.employer_notification(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_notification.doctor_code, idx_employer_notification_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_notification_on_doctor_code on fomema_backup_nios.employer_notification(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_notification.branch_code, idx_employer_notification_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_notification_on_branch_code on fomema_backup_nios.employer_notification(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_notification.state_code, idx_employer_notification_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_notification_on_state_code on fomema_backup_nios.employer_notification(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_notification.employer_code, idx_employer_notification_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_notification_on_employer_code on fomema_backup_nios.employer_notification(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index employer_notification_count.employer_code, idx_employer_notification_count_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_notification_count_on_employer_code on fomema_backup_nios.employer_notification_count(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index finance_payment.trans_id, idx_finance_payment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_finance_payment_on_trans_id on fomema_backup_nios.finance_payment(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index finance_payment.worker_code, idx_finance_payment_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_finance_payment_on_worker_code on fomema_backup_nios.finance_payment(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fin_batch_trans.trans_id, idx_fin_batch_trans_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fin_batch_trans_on_trans_id on fomema_backup_nios.fin_batch_trans(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fom_doctor_quota_bkp.doctor_code, idx_fom_doctor_quota_bkp_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_doctor_quota_bkp_on_doctor_code on fomema_backup_nios.fom_doctor_quota_bkp(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_doctor_quota_bkp.laboratory_code, idx_fom_doctor_quota_bkp_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_doctor_quota_bkp_on_laboratory_code on fomema_backup_nios.fom_doctor_quota_bkp(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_doctor_quota_bkp.xray_code, idx_fom_doctor_quota_bkp_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_doctor_quota_bkp_on_xray_code on fomema_backup_nios.fom_doctor_quota_bkp(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_doctor_quota_bkp.status_code, idx_fom_doctor_quota_bkp_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_doctor_quota_bkp_on_status_code on fomema_backup_nios.fom_doctor_quota_bkp(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fom_lab_payment_missed.trans_id, idx_fom_lab_payment_missed_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_lab_payment_missed_on_trans_id on fomema_backup_nios.fom_lab_payment_missed(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_lab_payment_missed.lab_code, idx_fom_lab_payment_missed_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_lab_payment_missed_on_lab_code on fomema_backup_nios.fom_lab_payment_missed(lab_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_lab_payment_missed.worker_code, idx_fom_lab_payment_missed_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_lab_payment_missed_on_worker_code on fomema_backup_nios.fom_lab_payment_missed(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fom_lab_unpaid.l_lab_code, idx_fom_lab_unpaid_on_l_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_lab_unpaid_on_l_lab_code on fomema_backup_nios.fom_lab_unpaid(l_lab_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_lab_unpaid.l_worker_code, idx_fom_lab_unpaid_on_l_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_lab_unpaid_on_l_worker_code on fomema_backup_nios.fom_lab_unpaid(l_worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_lab_unpaid.f_lab_code, idx_fom_lab_unpaid_on_f_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_lab_unpaid_on_f_lab_code on fomema_backup_nios.fom_lab_unpaid(f_lab_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fom_params.param_code, idx_fom_params_on_param_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_params_on_param_code on fomema_backup_nios.fom_params(param_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fom_payment_status_missed.trans_id, idx_fom_payment_status_missed_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_payment_status_missed_on_trans_id on fomema_backup_nios.fom_payment_status_missed(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_payment_status_missed.doctor_code, idx_fom_payment_status_missed_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_payment_status_missed_on_doctor_code on fomema_backup_nios.fom_payment_status_missed(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_payment_status_missed.xray_code, idx_fom_payment_status_missed_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_payment_status_missed_on_xray_code on fomema_backup_nios.fom_payment_status_missed(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_payment_status_missed.lab_code, idx_fom_payment_status_missed_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_payment_status_missed_on_lab_code on fomema_backup_nios.fom_payment_status_missed(lab_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fom_pay_transaction.trans_id, idx_fom_pay_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_pay_transaction_on_trans_id on fomema_backup_nios.fom_pay_transaction(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_pay_transaction.worker_code, idx_fom_pay_transaction_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_pay_transaction_on_worker_code on fomema_backup_nios.fom_pay_transaction(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_pay_transaction.branch_code, idx_fom_pay_transaction_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_pay_transaction_on_branch_code on fomema_backup_nios.fom_pay_transaction(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_pay_transaction.sp_code, idx_fom_pay_transaction_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_pay_transaction_on_sp_code on fomema_backup_nios.fom_pay_transaction(sp_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_pay_transaction.sp_state_code, idx_fom_pay_transaction_on_sp_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_pay_transaction_on_sp_state_code on fomema_backup_nios.fom_pay_transaction(sp_state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_pay_transaction.gst_code, idx_fom_pay_transaction_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_pay_transaction_on_gst_code on fomema_backup_nios.fom_pay_transaction(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fom_pay_transaction_missed.trans_id, idx_fom_pay_transaction_missed_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_pay_transaction_missed_on_trans_id on fomema_backup_nios.fom_pay_transaction_missed(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_pay_transaction_missed.worker_code, idx_fom_pay_transaction_missed_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_pay_transaction_missed_on_worker_code on fomema_backup_nios.fom_pay_transaction_missed(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_pay_transaction_missed.doctor_code, idx_fom_pay_transaction_missed_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_pay_transaction_missed_on_doctor_code on fomema_backup_nios.fom_pay_transaction_missed(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_pay_transaction_missed.xray_code, idx_fom_pay_transaction_missed_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_pay_transaction_missed_on_xray_code on fomema_backup_nios.fom_pay_transaction_missed(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fom_special_payment.trans_id, idx_fom_special_payment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_special_payment_on_trans_id on fomema_backup_nios.fom_special_payment(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index fom_tmp_jim.trans_id, idx_fom_tmp_jim_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_tmp_jim_on_trans_id on fomema_backup_nios.fom_tmp_jim(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index fom_xray_not_done_missed.trans_id, idx_fom_xray_not_done_missed_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_xray_not_done_missed_on_trans_id on fomema_backup_nios.fom_xray_not_done_missed(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_xray_not_done_missed.xray_code, idx_fom_xray_not_done_missed_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_xray_not_done_missed_on_xray_code on fomema_backup_nios.fom_xray_not_done_missed(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_xray_not_done_missed.worker_code, idx_fom_xray_not_done_missed_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_xray_not_done_missed_on_worker_code on fomema_backup_nios.fom_xray_not_done_missed(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fom_xray_not_receive.trans_id, idx_fom_xray_not_receive_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_xray_not_receive_on_trans_id on fomema_backup_nios.fom_xray_not_receive(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_xray_not_receive.xray_code, idx_fom_xray_not_receive_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_xray_not_receive_on_xray_code on fomema_backup_nios.fom_xray_not_receive(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fom_xray_not_receive.worker_code, idx_fom_xray_not_receive_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_xray_not_receive_on_worker_code on fomema_backup_nios.fom_xray_not_receive(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fom_xray_use_swast.xray_code, idx_fom_xray_use_swast_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fom_xray_use_swast_on_xray_code on fomema_backup_nios.fom_xray_use_swast(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index foreign_worker_biodata.trans_id, idx_foreign_worker_biodata_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_worker_biodata_on_trans_id on fomema_backup_nios.foreign_worker_biodata(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index foreign_worker_biodata.worker_code, idx_foreign_worker_biodata_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_worker_biodata_on_worker_code on fomema_backup_nios.foreign_worker_biodata(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index foreign_worker_biodata.ners_reason_code, idx_foreign_worker_biodata_on_ners_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_worker_biodata_on_ners_reason_code on fomema_backup_nios.foreign_worker_biodata(ners_reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index foreign_worker_biodata.employer_postcode, idx_foreign_worker_biodata_on_employer_postcode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_worker_biodata_on_employer_postcode on fomema_backup_nios.foreign_worker_biodata(employer_postcode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_appeal.trans_id, idx_fw_appeal_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_appeal_on_trans_id on fomema_backup_nios.fw_appeal(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_appeal.appeal_doctor_code, idx_fw_appeal_on_appeal_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_appeal_on_appeal_doctor_code on fomema_backup_nios.fw_appeal(appeal_doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index fw_appeal_doc_change.old_doctor_code, idx_fw_appeal_doc_change_on_old_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_appeal_doc_change_on_old_doctor_code on fomema_backup_nios.fw_appeal_doc_change(old_doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_appeal_doc_change.new_doctor_code, idx_fw_appeal_doc_change_on_new_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_appeal_doc_change_on_new_doctor_code on fomema_backup_nios.fw_appeal_doc_change(new_doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index fw_appeal_passfail_reason.appeal_param_code, idx_fw_appeal_passfail_reason_on_appeal_param_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_appeal_passfail_reason_on_appeal_param_code on fomema_backup_nios.fw_appeal_passfail_reason(appeal_param_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_appeal_passfail_reason.reason_code, idx_fw_appeal_passfail_reason_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_appeal_passfail_reason_on_reason_code on fomema_backup_nios.fw_appeal_passfail_reason(reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_appeal_todolist.parameter_code, idx_fw_appeal_todolist_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_appeal_todolist_on_parameter_code on fomema_backup_nios.fw_appeal_todolist(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_appeal_unfit_details.merts_param_code, idx_fw_appeal_unfit_details_on_merts_param_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_appeal_unfit_details_on_merts_param_code on fomema_backup_nios.fw_appeal_unfit_details(merts_param_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_appeal_unfit_details.appeal_param_code, idx_fw_appeal_unfit_details_on_appeal_param_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_appeal_unfit_details_on_appeal_param_code on fomema_backup_nios.fw_appeal_unfit_details(appeal_param_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_appeal_unfit_details.reason_code, idx_fw_appeal_unfit_details_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_appeal_unfit_details_on_reason_code on fomema_backup_nios.fw_appeal_unfit_details(reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_biodata_reenrolment.worker_code, idx_fw_biodata_reenrolment_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_biodata_reenrolment_on_worker_code on fomema_backup_nios.fw_biodata_reenrolment(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_biodata_reenrolment.sp_code, idx_fw_biodata_reenrolment_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_biodata_reenrolment_on_sp_code on fomema_backup_nios.fw_biodata_reenrolment(sp_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_biodata_reenrolment.insertdate, idx_fw_biodata_reenrolment_on_insertdate', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_biodata_reenrolment_on_insertdate on fomema_backup_nios.fw_biodata_reenrolment(insertdate);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_block.worker_code, idx_fw_block_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_block_on_worker_code on fomema_backup_nios.fw_block(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_block.employer_code, idx_fw_block_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_block_on_employer_code on fomema_backup_nios.fw_block(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_change_trans.trans_id, idx_fw_change_trans_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_change_trans_on_trans_id on fomema_backup_nios.fw_change_trans(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_change_trans.worker_code, idx_fw_change_trans_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_change_trans_on_worker_code on fomema_backup_nios.fw_change_trans(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_comment.trans_id, idx_fw_comment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_comment_on_trans_id on fomema_backup_nios.fw_comment(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_comment.parameter_code, idx_fw_comment_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_comment_on_parameter_code on fomema_backup_nios.fw_comment(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_critical_info.worker_code, idx_fw_critical_info_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_critical_info_on_worker_code on fomema_backup_nios.fw_critical_info(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_critical_info.branch_code, idx_fw_critical_info_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_critical_info_on_branch_code on fomema_backup_nios.fw_critical_info(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index fw_detail.trans_id, idx_fw_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_detail_on_trans_id on fomema_backup_nios.fw_detail(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_detail.parameter_code, idx_fw_detail_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_detail_on_parameter_code on fomema_backup_nios.fw_detail(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_extra_comments.trans_id, idx_fw_extra_comments_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_extra_comments_on_trans_id on fomema_backup_nios.fw_extra_comments(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwm_change_trans.trans_id, idx_fwm_change_trans_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwm_change_trans_on_trans_id on fomema_backup_nios.fwm_change_trans(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fwm_change_trans.reason_code, idx_fwm_change_trans_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwm_change_trans_on_reason_code on fomema_backup_nios.fwm_change_trans(reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwm_change_trans_org.trans_id, idx_fwm_change_trans_org_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwm_change_trans_org_on_trans_id on fomema_backup_nios.fwm_change_trans_org(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fwm_change_trans_org.reason_code, idx_fwm_change_trans_org_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwm_change_trans_org_on_reason_code on fomema_backup_nios.fwm_change_trans_org(reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index fwm_modulecode.module_code, idx_fwm_modulecode_on_module_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwm_modulecode_on_module_code on fomema_backup_nios.fwm_modulecode(module_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwm_mon.worker_code, idx_fwm_mon_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwm_mon_on_worker_code on fomema_backup_nios.fwm_mon(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_monitor.trans_id, idx_fw_monitor_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_monitor_on_trans_id on fomema_backup_nios.fw_monitor(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_monitor.reason_code, idx_fw_monitor_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_monitor_on_reason_code on fomema_backup_nios.fw_monitor(reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_monitor_reason.reason_code, idx_fw_monitor_reason_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_monitor_reason_on_reason_code on fomema_backup_nios.fw_monitor_reason(reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_movement.trans_id, idx_fw_movement_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_movement_on_trans_id on fomema_backup_nios.fw_movement(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_movement.branch_code, idx_fw_movement_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_movement_on_branch_code on fomema_backup_nios.fw_movement(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_movement.module_code, idx_fw_movement_on_module_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_movement_on_module_code on fomema_backup_nios.fw_movement(module_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_movement.worker_code, idx_fw_movement_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_movement_on_worker_code on fomema_backup_nios.fw_movement(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_quarantine_reason.trans_id, idx_fw_quarantine_reason_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_quarantine_reason_on_trans_id on fomema_backup_nios.fw_quarantine_reason(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_quarantine_reason.reason_code, idx_fw_quarantine_reason_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_quarantine_reason_on_reason_code on fomema_backup_nios.fw_quarantine_reason(reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwt_change_clinic_approval.trans_id, idx_fwt_change_clinic_approval_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_change_clinic_approval_on_trans_id on fomema_backup_nios.fwt_change_clinic_approval(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fwt_change_clinic_approval.worker_code, idx_fwt_change_clinic_approval_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_change_clinic_approval_on_worker_code on fomema_backup_nios.fwt_change_clinic_approval(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fwt_change_clinic_approval.doctor_code, idx_fwt_change_clinic_approval_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_change_clinic_approval_on_doctor_code on fomema_backup_nios.fwt_change_clinic_approval(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fwt_change_clinic_approval.branch_code, idx_fwt_change_clinic_approval_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_change_clinic_approval_on_branch_code on fomema_backup_nios.fwt_change_clinic_approval(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwt_change_journal.trans_id, idx_fwt_change_journal_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_change_journal_on_trans_id on fomema_backup_nios.fwt_change_journal(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwt_change_journal_detail.old_code, idx_fwt_change_journal_detail_on_old_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_change_journal_detail_on_old_code on fomema_backup_nios.fwt_change_journal_detail(old_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fwt_change_journal_detail.new_code, idx_fwt_change_journal_detail_on_new_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_change_journal_detail_on_new_code on fomema_backup_nios.fwt_change_journal_detail(new_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwt_deferred.trans_id, idx_fwt_deferred_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_deferred_on_trans_id on fomema_backup_nios.fwt_deferred(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwt_examdate_change_trans.trans_id, idx_fwt_examdate_change_trans_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_examdate_change_trans_on_trans_id on fomema_backup_nios.fwt_examdate_change_trans(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_transaction.transdate, idx_fw_transaction_on_transdate', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_on_transdate on fomema_backup_nios.fw_transaction(transdate);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction.trans_id, idx_fw_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_on_trans_id on fomema_backup_nios.fw_transaction(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction.doctor_code, idx_fw_transaction_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_on_doctor_code on fomema_backup_nios.fw_transaction(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction.employer_code, idx_fw_transaction_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_on_employer_code on fomema_backup_nios.fw_transaction(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction.laboratory_code, idx_fw_transaction_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_on_laboratory_code on fomema_backup_nios.fw_transaction(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction.radiologist_code, idx_fw_transaction_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_on_radiologist_code on fomema_backup_nios.fw_transaction(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction.xray_code, idx_fw_transaction_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_on_xray_code on fomema_backup_nios.fw_transaction(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction.worker_code, idx_fw_transaction_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_on_worker_code on fomema_backup_nios.fw_transaction(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_transaction_cancel.trans_id, idx_fw_transaction_cancel_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_cancel_on_trans_id on fomema_backup_nios.fw_transaction_cancel(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_cancel.doctor_code, idx_fw_transaction_cancel_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_cancel_on_doctor_code on fomema_backup_nios.fw_transaction_cancel(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_cancel.employer_code, idx_fw_transaction_cancel_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_cancel_on_employer_code on fomema_backup_nios.fw_transaction_cancel(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_cancel.laboratory_code, idx_fw_transaction_cancel_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_cancel_on_laboratory_code on fomema_backup_nios.fw_transaction_cancel(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_cancel.radiologist_code, idx_fw_transaction_cancel_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_cancel_on_radiologist_code on fomema_backup_nios.fw_transaction_cancel(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_cancel.xray_code, idx_fw_transaction_cancel_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_cancel_on_xray_code on fomema_backup_nios.fw_transaction_cancel(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_cancel.worker_code, idx_fw_transaction_cancel_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_cancel_on_worker_code on fomema_backup_nios.fw_transaction_cancel(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_cancel.doctor_state_code, idx_fw_transaction_cancel_on_doctor_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_cancel_on_doctor_state_code on fomema_backup_nios.fw_transaction_cancel(doctor_state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_transaction_delete.trans_id, idx_fw_transaction_delete_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_delete_on_trans_id on fomema_backup_nios.fw_transaction_delete(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_delete.doctor_code, idx_fw_transaction_delete_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_delete_on_doctor_code on fomema_backup_nios.fw_transaction_delete(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_delete.employer_code, idx_fw_transaction_delete_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_delete_on_employer_code on fomema_backup_nios.fw_transaction_delete(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_delete.laboratory_code, idx_fw_transaction_delete_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_delete_on_laboratory_code on fomema_backup_nios.fw_transaction_delete(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_delete.radiologist_code, idx_fw_transaction_delete_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_delete_on_radiologist_code on fomema_backup_nios.fw_transaction_delete(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_delete.xray_code, idx_fw_transaction_delete_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_delete_on_xray_code on fomema_backup_nios.fw_transaction_delete(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_delete.worker_code, idx_fw_transaction_delete_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_delete_on_worker_code on fomema_backup_nios.fw_transaction_delete(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_transaction_update.trans_id, idx_fw_transaction_update_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_update_on_trans_id on fomema_backup_nios.fw_transaction_update(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_update.doctor_code, idx_fw_transaction_update_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_update_on_doctor_code on fomema_backup_nios.fw_transaction_update(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_update.laboratory_code, idx_fw_transaction_update_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_update_on_laboratory_code on fomema_backup_nios.fw_transaction_update(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_update.xray_code, idx_fw_transaction_update_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_update_on_xray_code on fomema_backup_nios.fw_transaction_update(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_update.worker_code, idx_fw_transaction_update_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_update_on_worker_code on fomema_backup_nios.fw_transaction_update(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_update.employer_code, idx_fw_transaction_update_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_update_on_employer_code on fomema_backup_nios.fw_transaction_update(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwt_regmed.trans_id, idx_fwt_regmed_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_regmed_on_trans_id on fomema_backup_nios.fwt_regmed(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fwt_regmed.worker_code, idx_fwt_regmed_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_regmed_on_worker_code on fomema_backup_nios.fwt_regmed(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwt_regmed_delta.trans_id, idx_fwt_regmed_delta_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_regmed_delta_on_trans_id on fomema_backup_nios.fwt_regmed_delta(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fwt_regmed_delta.worker_code, idx_fwt_regmed_delta_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_regmed_delta_on_worker_code on fomema_backup_nios.fwt_regmed_delta(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwt_shadow.trans_id, idx_fwt_shadow_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_shadow_on_trans_id on fomema_backup_nios.fwt_shadow(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fwt_shadow.xray_code, idx_fwt_shadow_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_shadow_on_xray_code on fomema_backup_nios.fwt_shadow(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fwt_shadow.radiologist_code, idx_fwt_shadow_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_shadow_on_radiologist_code on fomema_backup_nios.fwt_shadow(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwt_update_tcupi.trans_id, idx_fwt_update_tcupi_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_update_tcupi_on_trans_id on fomema_backup_nios.fwt_update_tcupi(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fwt_update_tcupi.worker_code, idx_fwt_update_tcupi_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_update_tcupi_on_worker_code on fomema_backup_nios.fwt_update_tcupi(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fwt_xray_unmatch.trans_id, idx_fwt_xray_unmatch_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_xray_unmatch_on_trans_id on fomema_backup_nios.fwt_xray_unmatch(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fwt_xray_unmatch.xray_code, idx_fwt_xray_unmatch_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fwt_xray_unmatch_on_xray_code on fomema_backup_nios.fwt_xray_unmatch(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_unsuitable_reasons.trans_id, idx_fw_unsuitable_reasons_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_unsuitable_reasons_on_trans_id on fomema_backup_nios.fw_unsuitable_reasons(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_worker_replacement.worker_code, idx_fw_worker_replacement_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_worker_replacement_on_worker_code on fomema_backup_nios.fw_worker_replacement(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index group_details.group_code, idx_group_details_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_group_details_on_group_code on fomema_backup_nios.group_details(group_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index group_details.post_code, idx_group_details_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_group_details_on_post_code on fomema_backup_nios.group_details(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index group_doctor_pay.group_code, idx_group_doctor_pay_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_group_doctor_pay_on_group_code on fomema_backup_nios.group_doctor_pay(group_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index group_doctor_pay.doctor_code, idx_group_doctor_pay_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_group_doctor_pay_on_doctor_code on fomema_backup_nios.group_doctor_pay(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index group_xray_pay.group_code, idx_group_xray_pay_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_group_xray_pay_on_group_code on fomema_backup_nios.group_xray_pay(group_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index group_xray_pay.xray_code, idx_group_xray_pay_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_group_xray_pay_on_xray_code on fomema_backup_nios.group_xray_pay(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index imm_block_workers.worker_code, idx_imm_block_workers_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_imm_block_workers_on_worker_code on fomema_backup_nios.imm_block_workers(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index inactive_doctors.doctor_code, idx_inactive_doctors_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_inactive_doctors_on_doctor_code on fomema_backup_nios.inactive_doctors(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index invoice_detail.trans_id, idx_invoice_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_invoice_detail_on_trans_id on fomema_backup_nios.invoice_detail(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index invoice_detail.service_provider_code, idx_invoice_detail_on_service_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_invoice_detail_on_service_provider_code on fomema_backup_nios.invoice_detail(service_provider_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index invoice_detail.member_code, idx_invoice_detail_on_member_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_invoice_detail_on_member_code on fomema_backup_nios.invoice_detail(member_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index lab_change_request.lab_code, idx_lab_change_request_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_lab_change_request_on_lab_code on fomema_backup_nios.lab_change_request(lab_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index laboratory_registration.post_code, idx_laboratory_registration_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_registration_on_post_code on fomema_backup_nios.laboratory_registration(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_registration.state_code, idx_laboratory_registration_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_registration_on_state_code on fomema_backup_nios.laboratory_registration(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_registration.district_code, idx_laboratory_registration_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_registration_on_district_code on fomema_backup_nios.laboratory_registration(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_registration.country_code, idx_laboratory_registration_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_registration_on_country_code on fomema_backup_nios.laboratory_registration(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_registration.status_code, idx_laboratory_registration_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_registration_on_status_code on fomema_backup_nios.laboratory_registration(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index lab_payment.trans_id, idx_lab_payment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_lab_payment_on_trans_id on fomema_backup_nios.lab_payment(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index lab_payment.lab_code, idx_lab_payment_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_lab_payment_on_lab_code on fomema_backup_nios.lab_payment(lab_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index lab_payment.worker_code, idx_lab_payment_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_lab_payment_on_worker_code on fomema_backup_nios.lab_payment(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index labuan_g_workers.trans_id, idx_labuan_g_workers_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_labuan_g_workers_on_trans_id on fomema_backup_nios.labuan_g_workers(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index labuan_g_workers.worker_code, idx_labuan_g_workers_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_labuan_g_workers_on_worker_code on fomema_backup_nios.labuan_g_workers(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;






insert into public.migration_logs (description, start_at) values ('start index letter_monitor.sp_code, idx_letter_monitor_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_letter_monitor_on_sp_code on fomema_backup_nios.letter_monitor(sp_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index letter_monitor.state_code, idx_letter_monitor_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_letter_monitor_on_state_code on fomema_backup_nios.letter_monitor(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index letter_monitor.sp_code2, idx_letter_monitor_on_sp_code2', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_letter_monitor_on_sp_code2 on fomema_backup_nios.letter_monitor(sp_code2);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;





insert into public.migration_logs (description, start_at) values ('start index lqcc_report.trans_id, idx_lqcc_report_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_lqcc_report_on_trans_id on fomema_backup_nios.lqcc_report(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index maxigrid.trans_id, idx_maxigrid_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_maxigrid_on_trans_id on fomema_backup_nios.maxigrid(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index maxigrid.bank_code, idx_maxigrid_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_maxigrid_on_bank_code on fomema_backup_nios.maxigrid(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index merts_doc_startpage_stats.doctor_code, idx_merts_doc_startpage_stats_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_merts_doc_startpage_stats_on_doctor_code on fomema_backup_nios.merts_doc_startpage_stats(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index merts_lab_startpage_stats.lab_code, idx_merts_lab_startpage_stats_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_merts_lab_startpage_stats_on_lab_code on fomema_backup_nios.merts_lab_startpage_stats(lab_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index merts_xray_startpage_stats.xray_code, idx_merts_xray_startpage_stats_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_merts_xray_startpage_stats_on_xray_code on fomema_backup_nios.merts_xray_startpage_stats(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index missing_payment.bank_code, idx_missing_payment_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_missing_payment_on_bank_code on fomema_backup_nios.missing_payment(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;





insert into public.migration_logs (description, start_at) values ('start index monitor_exam.trans_id, idx_monitor_exam_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_monitor_exam_on_trans_id on fomema_backup_nios.monitor_exam(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index monitor_exam.worker_code, idx_monitor_exam_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_monitor_exam_on_worker_code on fomema_backup_nios.monitor_exam(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index monitoring.worker_code, idx_monitoring_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_monitoring_on_worker_code on fomema_backup_nios.monitoring(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index myimms_mon_tcupi.trans_id, idx_myimms_mon_tcupi_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_myimms_mon_tcupi_on_trans_id on fomema_backup_nios.myimms_mon_tcupi(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index myimms_queue.trans_id, idx_myimms_queue_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_myimms_queue_on_trans_id on fomema_backup_nios.myimms_queue(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index myimms_queue_hist.trans_id, idx_myimms_queue_hist_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_myimms_queue_hist_on_trans_id on fomema_backup_nios.myimms_queue_hist(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index new_arri.doctor_code, idx_new_arri_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_new_arri_on_doctor_code on fomema_backup_nios.new_arri(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index new_arri.worker_code, idx_new_arri_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_new_arri_on_worker_code on fomema_backup_nios.new_arri(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index nios_lab_payment.laboratory_code, idx_nios_lab_payment_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_nios_lab_payment_on_laboratory_code on fomema_backup_nios.nios_lab_payment(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index nios_lab_payment.worker_code, idx_nios_lab_payment_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_nios_lab_payment_on_worker_code on fomema_backup_nios.nios_lab_payment(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index non_transmission.doctor_code, idx_non_transmission_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_non_transmission_on_doctor_code on fomema_backup_nios.non_transmission(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index non_transmission.worker_code, idx_non_transmission_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_non_transmission_on_worker_code on fomema_backup_nios.non_transmission(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index notification.trans_id, idx_notification_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_notification_on_trans_id on fomema_backup_nios.notification(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index notification.worker_code, idx_notification_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_notification_on_worker_code on fomema_backup_nios.notification(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index pati_renew.trans_id, idx_pati_renew_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pati_renew_on_trans_id on fomema_backup_nios.pati_renew(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index pati_renew.worker_code, idx_pati_renew_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pati_renew_on_worker_code on fomema_backup_nios.pati_renew(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index payment.bank_code, idx_payment_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_on_bank_code on fomema_backup_nios.payment(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment.sp_code, idx_payment_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_on_sp_code on fomema_backup_nios.payment(sp_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment.gst_code, idx_payment_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_on_gst_code on fomema_backup_nios.payment(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment.fin_batch_no, idx_payment_on_fin_batch_no', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_on_fin_batch_no on fomema_backup_nios.payment(fin_batch_no);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index payment_refund.old_bank_code, idx_payment_refund_on_old_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_refund_on_old_bank_code on fomema_backup_nios.payment_refund(old_bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_refund.branch_code, idx_payment_refund_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_refund_on_branch_code on fomema_backup_nios.payment_refund(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_refund.employer_code, idx_payment_refund_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_refund_on_employer_code on fomema_backup_nios.payment_refund(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_refund.new_bank_code, idx_payment_refund_on_new_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_refund_on_new_bank_code on fomema_backup_nios.payment_refund(new_bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index payment_reject.reject_code, idx_payment_reject_on_reject_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_reject_on_reject_code on fomema_backup_nios.payment_reject(reject_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_reject.employer_code, idx_payment_reject_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_reject_on_employer_code on fomema_backup_nios.payment_reject(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index payment_req.branch_code, idx_payment_req_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_req_on_branch_code on fomema_backup_nios.payment_req(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_req.sp_code, idx_payment_req_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_req_on_sp_code on fomema_backup_nios.payment_req(sp_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_req.gst_code, idx_payment_req_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_req_on_gst_code on fomema_backup_nios.payment_req(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_req.service_provider_code, idx_payment_req_on_service_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_req_on_service_provider_code on fomema_backup_nios.payment_req(service_provider_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_req.worker_code, idx_payment_req_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_req_on_worker_code on fomema_backup_nios.payment_req(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index payment_status.trans_id, idx_payment_status_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_status_on_trans_id on fomema_backup_nios.payment_status(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_status.doctor_code, idx_payment_status_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_status_on_doctor_code on fomema_backup_nios.payment_status(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_status.xray_code, idx_payment_status_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_status_on_xray_code on fomema_backup_nios.payment_status(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_status.lab_code, idx_payment_status_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_status_on_lab_code on fomema_backup_nios.payment_status(lab_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index pay_transaction.trans_id, idx_pay_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pay_transaction_on_trans_id on fomema_backup_nios.pay_transaction(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index pay_transaction.worker_code, idx_pay_transaction_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pay_transaction_on_worker_code on fomema_backup_nios.pay_transaction(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index pay_transaction.doctor_code, idx_pay_transaction_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pay_transaction_on_doctor_code on fomema_backup_nios.pay_transaction(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index pay_transaction.xray_code, idx_pay_transaction_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pay_transaction_on_xray_code on fomema_backup_nios.pay_transaction(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index pay_trans_manual.trans_id, idx_pay_trans_manual_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pay_trans_manual_on_trans_id on fomema_backup_nios.pay_trans_manual(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index pay_trans_manual.sp_code, idx_pay_trans_manual_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pay_trans_manual_on_sp_code on fomema_backup_nios.pay_trans_manual(sp_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index pay_trans_manual.worker_code, idx_pay_trans_manual_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pay_trans_manual_on_worker_code on fomema_backup_nios.pay_trans_manual(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;







insert into public.migration_logs (description, start_at) values ('start index pcr_transaction.trans_id, idx_pcr_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pcr_transaction_on_trans_id on fomema_backup_nios.pcr_transaction(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index pcr_transaction.radiologist_code, idx_pcr_transaction_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pcr_transaction_on_radiologist_code on fomema_backup_nios.pcr_transaction(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index pcr_transaction.xray_code, idx_pcr_transaction_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pcr_transaction_on_xray_code on fomema_backup_nios.pcr_transaction(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index pcr_transaction.worker_code, idx_pcr_transaction_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pcr_transaction_on_worker_code on fomema_backup_nios.pcr_transaction(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index pcr_trans_comments.trans_id, idx_pcr_trans_comments_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pcr_trans_comments_on_trans_id on fomema_backup_nios.pcr_trans_comments(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index pcr_trans_comments.parameter_code, idx_pcr_trans_comments_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pcr_trans_comments_on_parameter_code on fomema_backup_nios.pcr_trans_comments(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index pcr_trans_detail.trans_id, idx_pcr_trans_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pcr_trans_detail_on_trans_id on fomema_backup_nios.pcr_trans_detail(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index pcr_trans_detail.parameter_code, idx_pcr_trans_detail_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pcr_trans_detail_on_parameter_code on fomema_backup_nios.pcr_trans_detail(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index pincode_req.branch_code, idx_pincode_req_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pincode_req_on_branch_code on fomema_backup_nios.pincode_req(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index pincode_req.employer_code, idx_pincode_req_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pincode_req_on_employer_code on fomema_backup_nios.pincode_req(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index pincode_req.pin_code, idx_pincode_req_on_pin_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_pincode_req_on_pin_code on fomema_backup_nios.pincode_req(pin_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index ply_transaction.trans_id, idx_ply_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_ply_transaction_on_trans_id on fomema_backup_nios.ply_transaction(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index ply_transaction.employer_code, idx_ply_transaction_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_ply_transaction_on_employer_code on fomema_backup_nios.ply_transaction(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index ply_transaction_hist.trans_id, idx_ply_transaction_hist_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_ply_transaction_hist_on_trans_id on fomema_backup_nios.ply_transaction_hist(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc.trans_id, idx_quarantine_fw_doc_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_on_trans_id on fomema_backup_nios.quarantine_fw_doc(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc.fw_code, idx_quarantine_fw_doc_on_fw_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_on_fw_code on fomema_backup_nios.quarantine_fw_doc(fw_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc.doc_code, idx_quarantine_fw_doc_on_doc_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_on_doc_code on fomema_backup_nios.quarantine_fw_doc(doc_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc.employer_code, idx_quarantine_fw_doc_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_on_employer_code on fomema_backup_nios.quarantine_fw_doc(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc.lab_code, idx_quarantine_fw_doc_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_on_lab_code on fomema_backup_nios.quarantine_fw_doc(lab_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc.rad_code, idx_quarantine_fw_doc_on_rad_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_on_rad_code on fomema_backup_nios.quarantine_fw_doc(rad_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc.xray_code, idx_quarantine_fw_doc_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_on_xray_code on fomema_backup_nios.quarantine_fw_doc(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc.l1_blood_barcodeno, idx_quarantine_fw_doc_on_l1_blood_barcodeno', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_on_l1_blood_barcodeno on fomema_backup_nios.quarantine_fw_doc(l1_blood_barcodeno);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc.l1_urine_barcodeno, idx_quarantine_fw_doc_on_l1_urine_barcodeno', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_on_l1_urine_barcodeno on fomema_backup_nios.quarantine_fw_doc(l1_urine_barcodeno);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc_hist.trans_id, idx_quarantine_fw_doc_hist_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_hist_on_trans_id on fomema_backup_nios.quarantine_fw_doc_hist(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc_hist.fw_code, idx_quarantine_fw_doc_hist_on_fw_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_hist_on_fw_code on fomema_backup_nios.quarantine_fw_doc_hist(fw_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc_hist.doc_code, idx_quarantine_fw_doc_hist_on_doc_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_hist_on_doc_code on fomema_backup_nios.quarantine_fw_doc_hist(doc_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc_hist.employer_code, idx_quarantine_fw_doc_hist_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_hist_on_employer_code on fomema_backup_nios.quarantine_fw_doc_hist(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc_hist.lab_code, idx_quarantine_fw_doc_hist_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_hist_on_lab_code on fomema_backup_nios.quarantine_fw_doc_hist(lab_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc_hist.rad_code, idx_quarantine_fw_doc_hist_on_rad_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_hist_on_rad_code on fomema_backup_nios.quarantine_fw_doc_hist(rad_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_doc_hist.xray_code, idx_quarantine_fw_doc_hist_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_doc_hist_on_xray_code on fomema_backup_nios.quarantine_fw_doc_hist(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_reason.trans_id, idx_quarantine_fw_reason_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_reason_on_trans_id on fomema_backup_nios.quarantine_fw_reason(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_reason.reason_code, idx_quarantine_fw_reason_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_reason_on_reason_code on fomema_backup_nios.quarantine_fw_reason(reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_reason_hist.trans_id, idx_quarantine_fw_reason_hist_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_reason_hist_on_trans_id on fomema_backup_nios.quarantine_fw_reason_hist(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_fw_reason_hist.reason_code, idx_quarantine_fw_reason_hist_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_fw_reason_hist_on_reason_code on fomema_backup_nios.quarantine_fw_reason_hist(reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index quarantine_insp_findings.trans_id, idx_quarantine_insp_findings_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_insp_findings_on_trans_id on fomema_backup_nios.quarantine_insp_findings(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_insp_findings.fw_code, idx_quarantine_insp_findings_on_fw_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_insp_findings_on_fw_code on fomema_backup_nios.quarantine_insp_findings(fw_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index quarantine_insp_findings_hist.trans_id, idx_quarantine_insp_findings_hist_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_insp_findings_hist_on_trans_id on fomema_backup_nios.quarantine_insp_findings_hist(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_insp_findings_hist.fw_code, idx_quarantine_insp_findings_hist_on_fw_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_insp_findings_hist_on_fw_code on fomema_backup_nios.quarantine_insp_findings_hist(fw_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index quarantine_reason.reason_code, idx_quarantine_reason_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_reason_on_reason_code on fomema_backup_nios.quarantine_reason(reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index quarantine_reason_group.reason_code, idx_quarantine_reason_group_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_reason_group_on_reason_code on fomema_backup_nios.quarantine_reason_group(reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index quarantine_release_request.trans_id, idx_quarantine_release_request_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_release_request_on_trans_id on fomema_backup_nios.quarantine_release_request(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index quarantine_transfer.trans_id, idx_quarantine_transfer_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_transfer_on_trans_id on fomema_backup_nios.quarantine_transfer(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index quarantine_transfer.worker_code, idx_quarantine_transfer_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_transfer_on_worker_code on fomema_backup_nios.quarantine_transfer(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;







insert into public.migration_logs (description, start_at) values ('start index radiologist_registration.post_code, idx_radiologist_registration_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_registration_on_post_code on fomema_backup_nios.radiologist_registration(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_registration.district_code, idx_radiologist_registration_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_registration_on_district_code on fomema_backup_nios.radiologist_registration(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_registration.state_code, idx_radiologist_registration_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_registration_on_state_code on fomema_backup_nios.radiologist_registration(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_registration.country_code, idx_radiologist_registration_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_registration_on_country_code on fomema_backup_nios.radiologist_registration(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_registration.status_code, idx_radiologist_registration_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_registration_on_status_code on fomema_backup_nios.radiologist_registration(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index r_del_dup.worker_code, idx_r_del_dup_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_r_del_dup_on_worker_code on fomema_backup_nios.r_del_dup(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index receipt.tranno, idx_receipt_on_tranno', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_on_tranno on fomema_backup_nios.receipt(tranno);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt.contact_post_code, idx_receipt_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_on_contact_post_code on fomema_backup_nios.receipt(contact_post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt.contact_state_code, idx_receipt_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_on_contact_state_code on fomema_backup_nios.receipt(contact_state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt.contact_district_code, idx_receipt_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_on_contact_district_code on fomema_backup_nios.receipt(contact_district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt.branch_code, idx_receipt_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_on_branch_code on fomema_backup_nios.receipt(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index receipt_detail.tranno, idx_receipt_detail_on_tranno', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_detail_on_tranno on fomema_backup_nios.receipt_detail(tranno);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt_detail.bank_code, idx_receipt_detail_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_detail_on_bank_code on fomema_backup_nios.receipt_detail(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt_detail.zone_code, idx_receipt_detail_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_detail_on_zone_code on fomema_backup_nios.receipt_detail(zone_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt_detail.approval_code, idx_receipt_detail_on_approval_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_detail_on_approval_code on fomema_backup_nios.receipt_detail(approval_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index receipt_detail_sabah.bank_code, idx_receipt_detail_sabah_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_detail_sabah_on_bank_code on fomema_backup_nios.receipt_detail_sabah(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt_detail_sabah.zone_code, idx_receipt_detail_sabah_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_detail_sabah_on_zone_code on fomema_backup_nios.receipt_detail_sabah(zone_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index receipt_kiv_request.branch_code, idx_receipt_kiv_request_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_kiv_request_on_branch_code on fomema_backup_nios.receipt_kiv_request(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index receipt_sabah.contact_post_code, idx_receipt_sabah_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_sabah_on_contact_post_code on fomema_backup_nios.receipt_sabah(contact_post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt_sabah.contact_state_code, idx_receipt_sabah_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_sabah_on_contact_state_code on fomema_backup_nios.receipt_sabah(contact_state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt_sabah.contact_district_code, idx_receipt_sabah_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_sabah_on_contact_district_code on fomema_backup_nios.receipt_sabah(contact_district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt_sabah.branch_code, idx_receipt_sabah_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_sabah_on_branch_code on fomema_backup_nios.receipt_sabah(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index receipt_usage.trans_id, idx_receipt_usage_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_usage_on_trans_id on fomema_backup_nios.receipt_usage(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt_usage.status_code, idx_receipt_usage_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_usage_on_status_code on fomema_backup_nios.receipt_usage(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index ref_double.worker_code, idx_ref_double_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_ref_double_on_worker_code on fomema_backup_nios.ref_double(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index refund.status_code, idx_refund_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_refund_on_status_code on fomema_backup_nios.refund(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index refund.branch_code, idx_refund_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_refund_on_branch_code on fomema_backup_nios.refund(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index refund_detail.trans_id, idx_refund_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_refund_detail_on_trans_id on fomema_backup_nios.refund_detail(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index refund_detail.status_code, idx_refund_detail_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_refund_detail_on_status_code on fomema_backup_nios.refund_detail(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index refund_fomic.trans_id, idx_refund_fomic_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_refund_fomic_on_trans_id on fomema_backup_nios.refund_fomic(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index refund_fomic.worker_code, idx_refund_fomic_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_refund_fomic_on_worker_code on fomema_backup_nios.refund_fomic(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index refund_fomic_final.trans_id, idx_refund_fomic_final_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_refund_fomic_final_on_trans_id on fomema_backup_nios.refund_fomic_final(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index refund_fomic_final.worker_code, idx_refund_fomic_final_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_refund_fomic_final_on_worker_code on fomema_backup_nios.refund_fomic_final(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index rel_qrtn.worker_code, idx_rel_qrtn_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rel_qrtn_on_worker_code on fomema_backup_nios.rel_qrtn(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index renewal_comments.trans_id, idx_renewal_comments_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_renewal_comments_on_trans_id on fomema_backup_nios.renewal_comments(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index renewal_worker.worker_code, idx_renewal_worker_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_renewal_worker_on_worker_code on fomema_backup_nios.renewal_worker(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index renewal_worker.doctor_code, idx_renewal_worker_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_renewal_worker_on_doctor_code on fomema_backup_nios.renewal_worker(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index renewal_worker.employer_code, idx_renewal_worker_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_renewal_worker_on_employer_code on fomema_backup_nios.renewal_worker(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index renewal_worker.branch_code, idx_renewal_worker_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_renewal_worker_on_branch_code on fomema_backup_nios.renewal_worker(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index replace_table.worker_code, idx_replace_table_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_replace_table_on_worker_code on fomema_backup_nios.replace_table(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index reply_table.error_code, idx_reply_table_on_error_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_reply_table_on_error_code on fomema_backup_nios.reply_table(error_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index reply_table_arc.error_code, idx_reply_table_arc_on_error_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_reply_table_arc_on_error_code on fomema_backup_nios.reply_table_arc(error_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index reply_table_old.error_code, idx_reply_table_old_on_error_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_reply_table_old_on_error_code on fomema_backup_nios.reply_table_old(error_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index report_diff_bloodgroup.report_doccode, idx_report_diff_bloodgroup_on_report_doccode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_report_diff_bloodgroup_on_report_doccode on fomema_backup_nios.report_diff_bloodgroup(report_doccode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index report_diff_bloodgroup.doctor_code_me1, idx_report_diff_bloodgroup_on_doctor_code_me1', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_report_diff_bloodgroup_on_doctor_code_me1 on fomema_backup_nios.report_diff_bloodgroup(doctor_code_me1);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index report_diff_bloodgroup.doctor_code_me2, idx_report_diff_bloodgroup_on_doctor_code_me2', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_report_diff_bloodgroup_on_doctor_code_me2 on fomema_backup_nios.report_diff_bloodgroup(doctor_code_me2);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index report_diff_bloodgroup.doctor_code_me3, idx_report_diff_bloodgroup_on_doctor_code_me3', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_report_diff_bloodgroup_on_doctor_code_me3 on fomema_backup_nios.report_diff_bloodgroup(doctor_code_me3);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index report_diff_bloodgroup.worker_code, idx_report_diff_bloodgroup_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_report_diff_bloodgroup_on_worker_code on fomema_backup_nios.report_diff_bloodgroup(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index report_receive.trans_id, idx_report_receive_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_report_receive_on_trans_id on fomema_backup_nios.report_receive(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index report_receive.worker_code, idx_report_receive_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_report_receive_on_worker_code on fomema_backup_nios.report_receive(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;






insert into public.migration_logs (description, start_at) values ('start index rfw_batch_transaction.laboratory_code_a, idx_rfw_batch_transaction_on_laboratory_code_a', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_batch_transaction_on_laboratory_code_a on fomema_backup_nios.rfw_batch_transaction(laboratory_code_a);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index rfw_batch_transaction.laboratory_code_b, idx_rfw_batch_transaction_on_laboratory_code_b', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_batch_transaction_on_laboratory_code_b on fomema_backup_nios.rfw_batch_transaction(laboratory_code_b);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index rfw_batch_transaction.status_code, idx_rfw_batch_transaction_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_batch_transaction_on_status_code on fomema_backup_nios.rfw_batch_transaction(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index rfw_batch_transaction.laboratory_code_ori, idx_rfw_batch_transaction_on_laboratory_code_ori', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_batch_transaction_on_laboratory_code_ori on fomema_backup_nios.rfw_batch_transaction(laboratory_code_ori);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index rfw_case_transaction.trans_id, idx_rfw_case_transaction_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_case_transaction_on_trans_id on fomema_backup_nios.rfw_case_transaction(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index rfw_case_transaction.worker_code, idx_rfw_case_transaction_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_case_transaction_on_worker_code on fomema_backup_nios.rfw_case_transaction(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index rfw_case_transaction.status_code, idx_rfw_case_transaction_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_case_transaction_on_status_code on fomema_backup_nios.rfw_case_transaction(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index rfw_comment.parameter_code, idx_rfw_comment_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_comment_on_parameter_code on fomema_backup_nios.rfw_comment(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index rfw_detail.parameter_code, idx_rfw_detail_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_detail_on_parameter_code on fomema_backup_nios.rfw_detail(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index rfw_fw_transaction.laboratory_code, idx_rfw_fw_transaction_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_fw_transaction_on_laboratory_code on fomema_backup_nios.rfw_fw_transaction(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;





insert into public.migration_logs (description, start_at) values ('start index sabah_doc_post.doctor_code, idx_sabah_doc_post_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_sabah_doc_post_on_doctor_code on fomema_backup_nios.sabah_doc_post(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index sabah_doc_post.post_code, idx_sabah_doc_post_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_sabah_doc_post_on_post_code on fomema_backup_nios.sabah_doc_post(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index sabah_doc_post.state_code, idx_sabah_doc_post_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_sabah_doc_post_on_state_code on fomema_backup_nios.sabah_doc_post(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index sabah_doc_post.district_code, idx_sabah_doc_post_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_sabah_doc_post_on_district_code on fomema_backup_nios.sabah_doc_post(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index sabah_transid.trans_id, idx_sabah_transid_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_sabah_transid_on_trans_id on fomema_backup_nios.sabah_transid(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index scb_hp_dx.doc_xray_code, idx_scb_hp_dx_on_doc_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_hp_dx_on_doc_xray_code on fomema_backup_nios.scb_hp_dx(doc_xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index scb_pay_xray_nameandadd.xray_code, idx_scb_pay_xray_nameandadd_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_pay_xray_nameandadd_on_xray_code on fomema_backup_nios.scb_pay_xray_nameandadd(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_pay_xray_nameandadd.post_code, idx_scb_pay_xray_nameandadd_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_pay_xray_nameandadd_on_post_code on fomema_backup_nios.scb_pay_xray_nameandadd(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_pay_xray_nameandadd.district_code, idx_scb_pay_xray_nameandadd_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_pay_xray_nameandadd_on_district_code on fomema_backup_nios.scb_pay_xray_nameandadd(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_pay_xray_nameandadd.state_code, idx_scb_pay_xray_nameandadd_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_pay_xray_nameandadd_on_state_code on fomema_backup_nios.scb_pay_xray_nameandadd(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index scb_sabah_doc_post.doctor_code, idx_scb_sabah_doc_post_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_sabah_doc_post_on_doctor_code on fomema_backup_nios.scb_sabah_doc_post(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_sabah_doc_post.post_code, idx_scb_sabah_doc_post_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_sabah_doc_post_on_post_code on fomema_backup_nios.scb_sabah_doc_post(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_sabah_doc_post.state_code, idx_scb_sabah_doc_post_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_sabah_doc_post_on_state_code on fomema_backup_nios.scb_sabah_doc_post(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_sabah_doc_post.district_code, idx_scb_sabah_doc_post_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_sabah_doc_post_on_district_code on fomema_backup_nios.scb_sabah_doc_post(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index scb_xray_not_done.xray_code, idx_scb_xray_not_done_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_xray_not_done_on_xray_code on fomema_backup_nios.scb_xray_not_done(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_xray_not_done.worker_code, idx_scb_xray_not_done_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_xray_not_done_on_worker_code on fomema_backup_nios.scb_xray_not_done(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index scb_xray_payin_list.xray_code, idx_scb_xray_payin_list_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_xray_payin_list_on_xray_code on fomema_backup_nios.scb_xray_payin_list(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_xray_payin_list.post_code, idx_scb_xray_payin_list_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_xray_payin_list_on_post_code on fomema_backup_nios.scb_xray_payin_list(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_xray_payin_list.district_code, idx_scb_xray_payin_list_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_xray_payin_list_on_district_code on fomema_backup_nios.scb_xray_payin_list(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_xray_payin_list.state_code, idx_scb_xray_payin_list_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_xray_payin_list_on_state_code on fomema_backup_nios.scb_xray_payin_list(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index scb_xray_pay_new_address.xray_code, idx_scb_xray_pay_new_address_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_xray_pay_new_address_on_xray_code on fomema_backup_nios.scb_xray_pay_new_address(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_xray_pay_new_address.post_code, idx_scb_xray_pay_new_address_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_xray_pay_new_address_on_post_code on fomema_backup_nios.scb_xray_pay_new_address(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_xray_pay_new_address.district_code, idx_scb_xray_pay_new_address_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_xray_pay_new_address_on_district_code on fomema_backup_nios.scb_xray_pay_new_address(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_xray_pay_new_address.state_code, idx_scb_xray_pay_new_address_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_xray_pay_new_address_on_state_code on fomema_backup_nios.scb_xray_pay_new_address(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index seminar.state_code, idx_seminar_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_seminar_on_state_code on fomema_backup_nios.seminar(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index seminar_detail.sp_code, idx_seminar_detail_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_seminar_detail_on_sp_code on fomema_backup_nios.seminar_detail(sp_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index seminar_detail.district_code, idx_seminar_detail_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_seminar_detail_on_district_code on fomema_backup_nios.seminar_detail(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index seminar_detail.state_code, idx_seminar_detail_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_seminar_detail_on_state_code on fomema_backup_nios.seminar_detail(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index seminar_detail.sp_code2, idx_seminar_detail_on_sp_code2', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_seminar_detail_on_sp_code2 on fomema_backup_nios.seminar_detail(sp_code2);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index send_mail_ind.trans_id, idx_send_mail_ind_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_send_mail_ind_on_trans_id on fomema_backup_nios.send_mail_ind(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index service_providers_group.district_code, idx_service_providers_group_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_providers_group_on_district_code on fomema_backup_nios.service_providers_group(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index service_providers_group.group_code, idx_service_providers_group_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_providers_group_on_group_code on fomema_backup_nios.service_providers_group(group_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index service_providers_group.postcode, idx_service_providers_group_on_postcode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_providers_group_on_postcode on fomema_backup_nios.service_providers_group(postcode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index service_providers_group.state_code, idx_service_providers_group_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_providers_group_on_state_code on fomema_backup_nios.service_providers_group(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index service_providers_group.gst_code, idx_service_providers_group_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_providers_group_on_gst_code on fomema_backup_nios.service_providers_group(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index service_providers_group.bank_code, idx_service_providers_group_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_providers_group_on_bank_code on fomema_backup_nios.service_providers_group(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index service_providers_group.service_provider_master_code, idx_service_providers_group_on_service_provider_master_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_providers_group_on_service_provider_master_code on fomema_backup_nios.service_providers_group(service_provider_master_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index shadow_xray_radio_assignment.trans_id, idx_shadow_xray_radio_assignment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_shadow_xray_radio_assignment_on_trans_id on fomema_backup_nios.shadow_xray_radio_assignment(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index special_renewal_request.worker_code, idx_special_renewal_request_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_special_renewal_request_on_worker_code on fomema_backup_nios.special_renewal_request(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index special_renewal_request.employer_code, idx_special_renewal_request_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_special_renewal_request_on_employer_code on fomema_backup_nios.special_renewal_request(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index special_renewal_request.doctor_code, idx_special_renewal_request_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_special_renewal_request_on_doctor_code on fomema_backup_nios.special_renewal_request(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index special_renewal_request.post_code, idx_special_renewal_request_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_special_renewal_request_on_post_code on fomema_backup_nios.special_renewal_request(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index special_renewal_request.country_code, idx_special_renewal_request_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_special_renewal_request_on_country_code on fomema_backup_nios.special_renewal_request(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index special_renewal_request.branch_code, idx_special_renewal_request_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_special_renewal_request_on_branch_code on fomema_backup_nios.special_renewal_request(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index sppayment_reference.branch_code, idx_sppayment_reference_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_sppayment_reference_on_branch_code on fomema_backup_nios.sppayment_reference(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index sppayment_reference.service_provider_code, idx_sppayment_reference_on_service_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_sppayment_reference_on_service_provider_code on fomema_backup_nios.sppayment_reference(service_provider_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index sppayment_reference.creation_date, idx_sppayment_reference_on_creation_date', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_sppayment_reference_on_creation_date on fomema_backup_nios.sppayment_reference(creation_date);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index status_change_history.trans_id, idx_status_change_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_status_change_history_on_trans_id on fomema_backup_nios.status_change_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index status_change_history.worker_code, idx_status_change_history_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_status_change_history_on_worker_code on fomema_backup_nios.status_change_history(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index status_change_pending.trans_id, idx_status_change_pending_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_status_change_pending_on_trans_id on fomema_backup_nios.status_change_pending(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index status_change_pending.worker_code, idx_status_change_pending_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_status_change_pending_on_worker_code on fomema_backup_nios.status_change_pending(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;





insert into public.migration_logs (description, start_at) values ('start index t_cnv_doctor_district.doctor_code, idx_t_cnv_doctor_district_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_cnv_doctor_district_on_doctor_code on fomema_backup_nios.t_cnv_doctor_district(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index t_cnv_doctorh_district.doctor_code, idx_t_cnv_doctorh_district_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_cnv_doctorh_district_on_doctor_code on fomema_backup_nios.t_cnv_doctorh_district(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index t_cnv_employer_district.employer_code, idx_t_cnv_employer_district_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_cnv_employer_district_on_employer_code on fomema_backup_nios.t_cnv_employer_district(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index t_cnv_employerh_district.employer_code, idx_t_cnv_employerh_district_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_cnv_employerh_district_on_employer_code on fomema_backup_nios.t_cnv_employerh_district(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index t_cnv_laboratory_district.laboratory_code, idx_t_cnv_laboratory_district_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_cnv_laboratory_district_on_laboratory_code on fomema_backup_nios.t_cnv_laboratory_district(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index t_cnv_laboratoryh_district.laboratory_code, idx_t_cnv_laboratoryh_district_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_cnv_laboratoryh_district_on_laboratory_code on fomema_backup_nios.t_cnv_laboratoryh_district(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index t_cnv_worker_doctor.worker_code, idx_t_cnv_worker_doctor_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_cnv_worker_doctor_on_worker_code on fomema_backup_nios.t_cnv_worker_doctor(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index t_cnv_worker_doctor.doctor_code, idx_t_cnv_worker_doctor_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_cnv_worker_doctor_on_doctor_code on fomema_backup_nios.t_cnv_worker_doctor(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index t_cnv_worker_doctor_a.worker_code, idx_t_cnv_worker_doctor_a_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_cnv_worker_doctor_a_on_worker_code on fomema_backup_nios.t_cnv_worker_doctor_a(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index t_cnv_worker_doctor_a.doctor_code, idx_t_cnv_worker_doctor_a_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_cnv_worker_doctor_a_on_doctor_code on fomema_backup_nios.t_cnv_worker_doctor_a(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index t_cnv_xray_district.xray_code, idx_t_cnv_xray_district_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_cnv_xray_district_on_xray_code on fomema_backup_nios.t_cnv_xray_district(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index t_cnv_xrayh_district.xray_code, idx_t_cnv_xrayh_district_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_cnv_xrayh_district_on_xray_code on fomema_backup_nios.t_cnv_xrayh_district(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index t_conv_fin_nongroup_doctor.doctor_code, idx_t_conv_fin_nongroup_doctor_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_conv_fin_nongroup_doctor_on_doctor_code on fomema_backup_nios.t_conv_fin_nongroup_doctor(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index t_conv_fin_nongroup_doctor_dtl.doctor_code, idx_t_conv_fin_nongroup_doctor_dtl_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_conv_fin_nongroup_doctor_dtl_on_doctor_code on fomema_backup_nios.t_conv_fin_nongroup_doctor_dtl(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index t_conv_fin_nongroup_xray.xray_code, idx_t_conv_fin_nongroup_xray_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_conv_fin_nongroup_xray_on_xray_code on fomema_backup_nios.t_conv_fin_nongroup_xray(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index t_conv_fin_nongroup_xray_dtl.xray_code, idx_t_conv_fin_nongroup_xray_dtl_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_conv_fin_nongroup_xray_dtl_on_xray_code on fomema_backup_nios.t_conv_fin_nongroup_xray_dtl(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index temp_pending_review_resend.trans_id, idx_temp_pending_review_resend_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_temp_pending_review_resend_on_trans_id on fomema_backup_nios.temp_pending_review_resend(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index temp_quarantine_fw_doc.trans_id, idx_temp_quarantine_fw_doc_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_temp_quarantine_fw_doc_on_trans_id on fomema_backup_nios.temp_quarantine_fw_doc(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index temp_quarantine_fw_doc.fw_code, idx_temp_quarantine_fw_doc_on_fw_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_temp_quarantine_fw_doc_on_fw_code on fomema_backup_nios.temp_quarantine_fw_doc(fw_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index temp_quarantine_fw_doc.doc_code, idx_temp_quarantine_fw_doc_on_doc_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_temp_quarantine_fw_doc_on_doc_code on fomema_backup_nios.temp_quarantine_fw_doc(doc_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index temp_quarantine_fw_doc.employer_code, idx_temp_quarantine_fw_doc_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_temp_quarantine_fw_doc_on_employer_code on fomema_backup_nios.temp_quarantine_fw_doc(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index temp_quarantine_fw_doc.lab_code, idx_temp_quarantine_fw_doc_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_temp_quarantine_fw_doc_on_lab_code on fomema_backup_nios.temp_quarantine_fw_doc(lab_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index temp_quarantine_fw_doc.rad_code, idx_temp_quarantine_fw_doc_on_rad_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_temp_quarantine_fw_doc_on_rad_code on fomema_backup_nios.temp_quarantine_fw_doc(rad_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index temp_quarantine_fw_doc.xray_code, idx_temp_quarantine_fw_doc_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_temp_quarantine_fw_doc_on_xray_code on fomema_backup_nios.temp_quarantine_fw_doc(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index t_wpc.err_code, idx_t_wpc_on_err_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_wpc_on_err_code on fomema_backup_nios.t_wpc(err_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index t_wpc.worker_code, idx_t_wpc_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_wpc_on_worker_code on fomema_backup_nios.t_wpc(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index t_wpc.old_worker_code, idx_t_wpc_on_old_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_wpc_on_old_worker_code on fomema_backup_nios.t_wpc(old_worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index t_wpc.employer_code, idx_t_wpc_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_wpc_on_employer_code on fomema_backup_nios.t_wpc(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index t_wpc.old_employer_code, idx_t_wpc_on_old_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_t_wpc_on_old_employer_code on fomema_backup_nios.t_wpc(old_employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index undefine_doctor.doctor_code, idx_undefine_doctor_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_undefine_doctor_on_doctor_code on fomema_backup_nios.undefine_doctor(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index undefine_doctor.post_code, idx_undefine_doctor_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_undefine_doctor_on_post_code on fomema_backup_nios.undefine_doctor(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index undefine_doctor.state_code, idx_undefine_doctor_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_undefine_doctor_on_state_code on fomema_backup_nios.undefine_doctor(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index undefine_doctor.district_code, idx_undefine_doctor_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_undefine_doctor_on_district_code on fomema_backup_nios.undefine_doctor(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index undefine_doctor.country_code, idx_undefine_doctor_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_undefine_doctor_on_country_code on fomema_backup_nios.undefine_doctor(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index undefine_doctor.radiologist_code, idx_undefine_doctor_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_undefine_doctor_on_radiologist_code on fomema_backup_nios.undefine_doctor(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index undefine_doctor.xray_code, idx_undefine_doctor_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_undefine_doctor_on_xray_code on fomema_backup_nios.undefine_doctor(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index undefine_doctor.laboratory_code, idx_undefine_doctor_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_undefine_doctor_on_laboratory_code on fomema_backup_nios.undefine_doctor(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index undefine_doctor.status_code, idx_undefine_doctor_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_undefine_doctor_on_status_code on fomema_backup_nios.undefine_doctor(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index unsuitable_reasons_map.parameter_code, idx_unsuitable_reasons_map_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_unsuitable_reasons_map_on_parameter_code on fomema_backup_nios.unsuitable_reasons_map(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index user_branches.branch_code, idx_user_branches_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_user_branches_on_branch_code on fomema_backup_nios.user_branches(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index user_comments.usercode, idx_user_comments_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_user_comments_on_usercode on fomema_backup_nios.user_comments(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index useroldpass.usercode, idx_useroldpass_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_useroldpass_on_usercode on fomema_backup_nios.useroldpass(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index users.usercode, idx_users_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_users_on_usercode on fomema_backup_nios.users(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index user_session.branch_code, idx_user_session_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_user_session_on_branch_code on fomema_backup_nios.user_session(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index v_appeal_status.trans_id, idx_v_appeal_status_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_appeal_status_on_trans_id on fomema_backup_nios.v_appeal_status(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index v_appeal_status.worker_code, idx_v_appeal_status_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_appeal_status_on_worker_code on fomema_backup_nios.v_appeal_status(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index visit_plan_detail.state_code, idx_visit_plan_detail_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_visit_plan_detail_on_state_code on fomema_backup_nios.visit_plan_detail(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index visit_plan_detail.district_code, idx_visit_plan_detail_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_visit_plan_detail_on_district_code on fomema_backup_nios.visit_plan_detail(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index visit_rpt_docxray.provider_code, idx_visit_rpt_docxray_on_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_visit_rpt_docxray_on_provider_code on fomema_backup_nios.visit_rpt_docxray(provider_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index visit_rpt_followup.service_provider_code, idx_visit_rpt_followup_on_service_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_visit_rpt_followup_on_service_provider_code on fomema_backup_nios.visit_rpt_followup(service_provider_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;





insert into public.migration_logs (description, start_at) values ('start index visit_rpt_xqcc.provider_code, idx_visit_rpt_xqcc_on_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_visit_rpt_xqcc_on_provider_code on fomema_backup_nios.visit_rpt_xqcc(provider_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index v_worker_clinic.worker_code, idx_v_worker_clinic_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_worker_clinic_on_worker_code on fomema_backup_nios.v_worker_clinic(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index v_worker_clinic.country_code, idx_v_worker_clinic_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_worker_clinic_on_country_code on fomema_backup_nios.v_worker_clinic(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index v_worker_clinic.clinic_code, idx_v_worker_clinic_on_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_worker_clinic_on_clinic_code on fomema_backup_nios.v_worker_clinic(clinic_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index worker_cancel_detail.trans_id, idx_worker_cancel_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_cancel_detail_on_trans_id on fomema_backup_nios.worker_cancel_detail(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index worker_certify_fitind.trans_id, idx_worker_certify_fitind_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_certify_fitind_on_trans_id on fomema_backup_nios.worker_certify_fitind(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index worker_certify_fitind.worker_code, idx_worker_certify_fitind_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_certify_fitind_on_worker_code on fomema_backup_nios.worker_certify_fitind(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index worker_country_dist.country_code, idx_worker_country_dist_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_country_dist_on_country_code on fomema_backup_nios.worker_country_dist(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index worker_doctor_change.trans_id, idx_worker_doctor_change_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_doctor_change_on_trans_id on fomema_backup_nios.worker_doctor_change(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index worker_doctor_change_hist.trans_id, idx_worker_doctor_change_hist_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_doctor_change_hist_on_trans_id on fomema_backup_nios.worker_doctor_change_hist(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index worker_fitind_change.trans_id, idx_worker_fitind_change_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_fitind_change_on_trans_id on fomema_backup_nios.worker_fitind_change(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index worker_upd.worker_code, idx_worker_upd_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_upd_on_worker_code on fomema_backup_nios.worker_upd(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index wrong_transmission.trans_id, idx_wrong_transmission_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_wrong_transmission_on_trans_id on fomema_backup_nios.wrong_transmission(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index wrong_transmission.provider_code, idx_wrong_transmission_on_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_wrong_transmission_on_provider_code on fomema_backup_nios.wrong_transmission(provider_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index ws_access_token.usercode, idx_ws_access_token_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_ws_access_token_on_usercode on fomema_backup_nios.ws_access_token(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xqcc_calllog.xray_code, idx_xqcc_calllog_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_calllog_on_xray_code on fomema_backup_nios.xqcc_calllog(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index xqcc_comment.worker_code, idx_xqcc_comment_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_comment_on_worker_code on fomema_backup_nios.xqcc_comment(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index xqcc_fw_extra_comments.trans_id, idx_xqcc_fw_extra_comments_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_fw_extra_comments_on_trans_id on fomema_backup_nios.xqcc_fw_extra_comments(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index xqcc_quarantine_fw_doc.trans_id, idx_xqcc_quarantine_fw_doc_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_trans_id on fomema_backup_nios.xqcc_quarantine_fw_doc(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xqcc_quarantine_fw_doc.fw_code, idx_xqcc_quarantine_fw_doc_on_fw_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_fw_code on fomema_backup_nios.xqcc_quarantine_fw_doc(fw_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xqcc_quarantine_fw_doc.doc_code, idx_xqcc_quarantine_fw_doc_on_doc_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_doc_code on fomema_backup_nios.xqcc_quarantine_fw_doc(doc_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xqcc_quarantine_fw_doc.employer_code, idx_xqcc_quarantine_fw_doc_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_employer_code on fomema_backup_nios.xqcc_quarantine_fw_doc(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xqcc_quarantine_fw_doc.lab_code, idx_xqcc_quarantine_fw_doc_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_lab_code on fomema_backup_nios.xqcc_quarantine_fw_doc(lab_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xqcc_quarantine_fw_doc.rad_code, idx_xqcc_quarantine_fw_doc_on_rad_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_rad_code on fomema_backup_nios.xqcc_quarantine_fw_doc(rad_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xqcc_quarantine_fw_doc.xray_code, idx_xqcc_quarantine_fw_doc_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_xray_code on fomema_backup_nios.xqcc_quarantine_fw_doc(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xqcc_quarantine_fw_doc.l1_blood_barcodeno, idx_xqcc_quarantine_fw_doc_on_l1_blood_barcodeno', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_l1_blood_barcodeno on fomema_backup_nios.xqcc_quarantine_fw_doc(l1_blood_barcodeno);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xqcc_quarantine_fw_doc.l1_urine_barcodeno, idx_xqcc_quarantine_fw_doc_on_l1_urine_barcodeno', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_quarantine_fw_doc_on_l1_urine_barcodeno on fomema_backup_nios.xqcc_quarantine_fw_doc(l1_urine_barcodeno);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xqcc_quarantine_fw_reason.trans_id, idx_xqcc_quarantine_fw_reason_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_quarantine_fw_reason_on_trans_id on fomema_backup_nios.xqcc_quarantine_fw_reason(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xqcc_quarantine_fw_reason.reason_code, idx_xqcc_quarantine_fw_reason_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_quarantine_fw_reason_on_reason_code on fomema_backup_nios.xqcc_quarantine_fw_reason(reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xqcc_report.trans_id, idx_xqcc_report_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_report_on_trans_id on fomema_backup_nios.xqcc_report(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index xqcc_stat_change_reasons.reasoncode, idx_xqcc_stat_change_reasons_on_reasoncode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_stat_change_reasons_on_reasoncode on fomema_backup_nios.xqcc_stat_change_reasons(reasoncode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xqcc_stat_change_request.reasoncode, idx_xqcc_stat_change_request_on_reasoncode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_stat_change_request_on_reasoncode on fomema_backup_nios.xqcc_stat_change_request(reasoncode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xqcc_transid.trans_id, idx_xqcc_transid_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_transid_on_trans_id on fomema_backup_nios.xqcc_transid(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xqcc_unfit.trans_id, idx_xqcc_unfit_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqcc_unfit_on_trans_id on fomema_backup_nios.xqcc_unfit(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index xquarantine_release_request.trans_id, idx_xquarantine_release_request_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xquarantine_release_request_on_trans_id on fomema_backup_nios.xquarantine_release_request(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_adhoc_submit_abnormal.trans_id, idx_xray_adhoc_submit_abnormal_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_adhoc_submit_abnormal_on_trans_id on fomema_backup_nios.xray_adhoc_submit_abnormal(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_adhoc_submit_abnormal.xray_code, idx_xray_adhoc_submit_abnormal_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_adhoc_submit_abnormal_on_xray_code on fomema_backup_nios.xray_adhoc_submit_abnormal(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_adhoc_submit_abnormal.worker_code, idx_xray_adhoc_submit_abnormal_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_adhoc_submit_abnormal_on_worker_code on fomema_backup_nios.xray_adhoc_submit_abnormal(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_adhoc_submit_delay.trans_id, idx_xray_adhoc_submit_delay_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_adhoc_submit_delay_on_trans_id on fomema_backup_nios.xray_adhoc_submit_delay(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_adhoc_submit_delay.xray_code, idx_xray_adhoc_submit_delay_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_adhoc_submit_delay_on_xray_code on fomema_backup_nios.xray_adhoc_submit_delay(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_adhoc_submit_delay.worker_code, idx_xray_adhoc_submit_delay_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_adhoc_submit_delay_on_worker_code on fomema_backup_nios.xray_adhoc_submit_delay(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_adhoc_submit_normal.trans_id, idx_xray_adhoc_submit_normal_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_adhoc_submit_normal_on_trans_id on fomema_backup_nios.xray_adhoc_submit_normal(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_adhoc_submit_normal.xray_code, idx_xray_adhoc_submit_normal_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_adhoc_submit_normal_on_xray_code on fomema_backup_nios.xray_adhoc_submit_normal(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_adhoc_submit_normal.worker_code, idx_xray_adhoc_submit_normal_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_adhoc_submit_normal_on_worker_code on fomema_backup_nios.xray_adhoc_submit_normal(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_change_request.xray_code, idx_xray_change_request_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_change_request_on_xray_code on fomema_backup_nios.xray_change_request(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index xray_compare.xray_code, idx_xray_compare_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_compare_on_xray_code on fomema_backup_nios.xray_compare(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index xray_dispatch_list_details.trans_id, idx_xray_dispatch_list_details_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_dispatch_list_details_on_trans_id on fomema_backup_nios.xray_dispatch_list_details(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_film_audit.trans_id, idx_xray_film_audit_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_film_audit_on_trans_id on fomema_backup_nios.xray_film_audit(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_film_movement.trans_id, idx_xray_film_movement_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_film_movement_on_trans_id on fomema_backup_nios.xray_film_movement(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_film_reminder.trans_id, idx_xray_film_reminder_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_film_reminder_on_trans_id on fomema_backup_nios.xray_film_reminder(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index xray_film_storage_detail.trans_id, idx_xray_film_storage_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_film_storage_detail_on_trans_id on fomema_backup_nios.xray_film_storage_detail(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_follow_up.trans_id, idx_xray_follow_up_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_follow_up_on_trans_id on fomema_backup_nios.xray_follow_up(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_not_done.trans_id, idx_xray_not_done_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_not_done_on_trans_id on fomema_backup_nios.xray_not_done(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_not_done.xray_code, idx_xray_not_done_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_not_done_on_xray_code on fomema_backup_nios.xray_not_done(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_not_done.worker_code, idx_xray_not_done_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_not_done_on_worker_code on fomema_backup_nios.xray_not_done(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_payin_list.xray_code, idx_xray_payin_list_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_payin_list_on_xray_code on fomema_backup_nios.xray_payin_list(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_payin_list.post_code, idx_xray_payin_list_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_payin_list_on_post_code on fomema_backup_nios.xray_payin_list(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_payin_list.district_code, idx_xray_payin_list_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_payin_list_on_district_code on fomema_backup_nios.xray_payin_list(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_payin_list.state_code, idx_xray_payin_list_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_payin_list_on_state_code on fomema_backup_nios.xray_payin_list(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_radio_assignment.trans_id, idx_xray_radio_assignment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_radio_assignment_on_trans_id on fomema_backup_nios.xray_radio_assignment(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_registration.post_code, idx_xray_registration_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_registration_on_post_code on fomema_backup_nios.xray_registration(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_registration.district_code, idx_xray_registration_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_registration_on_district_code on fomema_backup_nios.xray_registration(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_registration.state_code, idx_xray_registration_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_registration_on_state_code on fomema_backup_nios.xray_registration(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_registration.country_code, idx_xray_registration_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_registration_on_country_code on fomema_backup_nios.xray_registration(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_registration.status_code, idx_xray_registration_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_registration_on_status_code on fomema_backup_nios.xray_registration(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index xray_review_film.trans_id, idx_xray_review_film_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_review_film_on_trans_id on fomema_backup_nios.xray_review_film(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_review_film.xray_code, idx_xray_review_film_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_review_film_on_xray_code on fomema_backup_nios.xray_review_film(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_review_film.worker_code, idx_xray_review_film_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_review_film_on_worker_code on fomema_backup_nios.xray_review_film(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_review_film_comments.trans_id, idx_xray_review_film_comments_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_review_film_comments_on_trans_id on fomema_backup_nios.xray_review_film_comments(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_review_film_detail.trans_id, idx_xray_review_film_detail_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_review_film_detail_on_trans_id on fomema_backup_nios.xray_review_film_detail(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_review_film_detail.parameter_code, idx_xray_review_film_detail_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_review_film_detail_on_parameter_code on fomema_backup_nios.xray_review_film_detail(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_review_film_identical.trans_id, idx_xray_review_film_identical_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_review_film_identical_on_trans_id on fomema_backup_nios.xray_review_film_identical(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_review_film_identical.worker_code, idx_xray_review_film_identical_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_review_film_identical_on_worker_code on fomema_backup_nios.xray_review_film_identical(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_review_film.review_filmid, idx_xray_review_film_on_review_filmid', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_review_film_on_review_filmid on fomema_backup_nios.xray_review_film(review_filmid);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_submit_daily.trans_id, idx_xray_submit_daily_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_daily_on_trans_id on fomema_backup_nios.xray_submit_daily(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_submit_daily.xray_code, idx_xray_submit_daily_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_daily_on_xray_code on fomema_backup_nios.xray_submit_daily(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_submit_daily.worker_code, idx_xray_submit_daily_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_daily_on_worker_code on fomema_backup_nios.xray_submit_daily(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_submit_daily_abnormal.trans_id, idx_xray_submit_daily_abnormal_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_daily_abnormal_on_trans_id on fomema_backup_nios.xray_submit_daily_abnormal(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_submit_daily_abnormal.xray_code, idx_xray_submit_daily_abnormal_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_daily_abnormal_on_xray_code on fomema_backup_nios.xray_submit_daily_abnormal(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_submit_daily_abnormal.worker_code, idx_xray_submit_daily_abnormal_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_daily_abnormal_on_worker_code on fomema_backup_nios.xray_submit_daily_abnormal(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_submit_daily_normal.trans_id, idx_xray_submit_daily_normal_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_daily_normal_on_trans_id on fomema_backup_nios.xray_submit_daily_normal(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_submit_daily_normal.xray_code, idx_xray_submit_daily_normal_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_daily_normal_on_xray_code on fomema_backup_nios.xray_submit_daily_normal(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_submit_daily_normal.worker_code, idx_xray_submit_daily_normal_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_daily_normal_on_worker_code on fomema_backup_nios.xray_submit_daily_normal(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_submit_delay.trans_id, idx_xray_submit_delay_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_delay_on_trans_id on fomema_backup_nios.xray_submit_delay(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_submit_delay.xray_code, idx_xray_submit_delay_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_delay_on_xray_code on fomema_backup_nios.xray_submit_delay(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_submit_delay.worker_code, idx_xray_submit_delay_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_delay_on_worker_code on fomema_backup_nios.xray_submit_delay(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_process;

end;
$$;
