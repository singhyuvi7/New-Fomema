
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_item bigint;
begin
    insert into public.migration_logs (description, start_at) values ('start index nios history process', clock_timestamp()) returning id into v_copy_log_id_process;

insert into public.migration_logs (description, start_at) values ('start index agent_history.post_code, idx_agent_history_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_agent_history_on_post_code on fomema_backup_nios.agent_history(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index agent_history.district_code, idx_agent_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_agent_history_on_district_code on fomema_backup_nios.agent_history(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index agent_history.state_code, idx_agent_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_agent_history_on_state_code on fomema_backup_nios.agent_history(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index agent_history.country_code, idx_agent_history_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_agent_history_on_country_code on fomema_backup_nios.agent_history(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index agent_history.status_code, idx_agent_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_agent_history_on_status_code on fomema_backup_nios.agent_history(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index agent_history.branch_code, idx_agent_history_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_agent_history_on_branch_code on fomema_backup_nios.agent_history(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index bad_payment_history.bank_code, idx_bad_payment_history_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_bad_payment_history_on_bank_code on fomema_backup_nios.bad_payment_history(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index bad_payment_history.contact_post_code, idx_bad_payment_history_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_bad_payment_history_on_contact_post_code on fomema_backup_nios.bad_payment_history(contact_post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index bad_payment_history.contact_state_code, idx_bad_payment_history_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_bad_payment_history_on_contact_state_code on fomema_backup_nios.bad_payment_history(contact_state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index bad_payment_history.contact_district_code, idx_bad_payment_history_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_bad_payment_history_on_contact_district_code on fomema_backup_nios.bad_payment_history(contact_district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index district_office_history.office_code, idx_district_office_history_on_office_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_district_office_history_on_office_code on fomema_backup_nios.district_office_history(office_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index district_office_history.post_code, idx_district_office_history_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_district_office_history_on_post_code on fomema_backup_nios.district_office_history(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index district_office_history.district_code, idx_district_office_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_district_office_history_on_district_code on fomema_backup_nios.district_office_history(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index district_office_history.state_code, idx_district_office_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_district_office_history_on_state_code on fomema_backup_nios.district_office_history(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index district_office_history.status_code, idx_district_office_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_district_office_history_on_status_code on fomema_backup_nios.district_office_history(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index doctor_history.doctor_code, idx_doctor_history_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_history_on_doctor_code on fomema_backup_nios.doctor_history(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_history.post_code, idx_doctor_history_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_history_on_post_code on fomema_backup_nios.doctor_history(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_history.district_code, idx_doctor_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_history_on_district_code on fomema_backup_nios.doctor_history(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_history.state_code, idx_doctor_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_history_on_state_code on fomema_backup_nios.doctor_history(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_history.country_code, idx_doctor_history_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_history_on_country_code on fomema_backup_nios.doctor_history(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_history.xray_code, idx_doctor_history_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_history_on_xray_code on fomema_backup_nios.doctor_history(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_history.radiologist_code, idx_doctor_history_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_history_on_radiologist_code on fomema_backup_nios.doctor_history(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_history.laboratory_code, idx_doctor_history_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_history_on_laboratory_code on fomema_backup_nios.doctor_history(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_history.status_code, idx_doctor_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_history_on_status_code on fomema_backup_nios.doctor_history(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_history.prefer_xray_code, idx_doctor_history_on_prefer_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_history_on_prefer_xray_code on fomema_backup_nios.doctor_history(prefer_xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_history.gst_code, idx_doctor_history_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_history_on_gst_code on fomema_backup_nios.doctor_history(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_history.bank_code, idx_doctor_history_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_history_on_bank_code on fomema_backup_nios.doctor_history(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index employer_history.post_code, idx_employer_history_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_history_on_post_code on fomema_backup_nios.employer_history(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_history.district_code, idx_employer_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_history_on_district_code on fomema_backup_nios.employer_history(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_history.employer_code, idx_employer_history_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_history_on_employer_code on fomema_backup_nios.employer_history(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_history.business_code, idx_employer_history_on_business_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_history_on_business_code on fomema_backup_nios.employer_history(business_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_history.country_code, idx_employer_history_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_history_on_country_code on fomema_backup_nios.employer_history(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_history.state_code, idx_employer_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_history_on_state_code on fomema_backup_nios.employer_history(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_history.doctor_code, idx_employer_history_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_history_on_doctor_code on fomema_backup_nios.employer_history(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_history.status_code, idx_employer_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_history_on_status_code on fomema_backup_nios.employer_history(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_history.branch_code, idx_employer_history_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_history_on_branch_code on fomema_backup_nios.employer_history(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index fw_appeal_history.trans_id, idx_fw_appeal_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_appeal_history_on_trans_id on fomema_backup_nios.fw_appeal_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_appeal_history.appeal_doctor_code, idx_fw_appeal_history_on_appeal_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_appeal_history_on_appeal_doctor_code on fomema_backup_nios.fw_appeal_history(appeal_doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_comment_history.trans_id, idx_fw_comment_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_comment_history_on_trans_id on fomema_backup_nios.fw_comment_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_comment_history.parameter_code, idx_fw_comment_history_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_comment_history_on_parameter_code on fomema_backup_nios.fw_comment_history(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_detail_history.trans_id, idx_fw_detail_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_detail_history_on_trans_id on fomema_backup_nios.fw_detail_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_detail_history.parameter_code, idx_fw_detail_history_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_detail_history_on_parameter_code on fomema_backup_nios.fw_detail_history(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_extra_comments_history.trans_id, idx_fw_extra_comments_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_extra_comments_history_on_trans_id on fomema_backup_nios.fw_extra_comments_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_quarantine_reason_history.trans_id, idx_fw_quarantine_reason_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_quarantine_reason_history_on_trans_id on fomema_backup_nios.fw_quarantine_reason_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_quarantine_reason_history.reason_code, idx_fw_quarantine_reason_history_on_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_quarantine_reason_history_on_reason_code on fomema_backup_nios.fw_quarantine_reason_history(reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_transaction_history.trans_id, idx_fw_transaction_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_history_on_trans_id on fomema_backup_nios.fw_transaction_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_history.worker_code, idx_fw_transaction_history_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_history_on_worker_code on fomema_backup_nios.fw_transaction_history(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_history.xray_code, idx_fw_transaction_history_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_history_on_xray_code on fomema_backup_nios.fw_transaction_history(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_history.radiologist_code, idx_fw_transaction_history_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_history_on_radiologist_code on fomema_backup_nios.fw_transaction_history(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_history.doctor_code, idx_fw_transaction_history_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_history_on_doctor_code on fomema_backup_nios.fw_transaction_history(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_history.laboratory_code, idx_fw_transaction_history_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_history_on_laboratory_code on fomema_backup_nios.fw_transaction_history(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_history.employer_code, idx_fw_transaction_history_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_history_on_employer_code on fomema_backup_nios.fw_transaction_history(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_history.doctor_state_code, idx_fw_transaction_history_on_doctor_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_history_on_doctor_state_code on fomema_backup_nios.fw_transaction_history(doctor_state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_history.blood_barcode_no, idx_fw_transaction_history_on_blood_barcode_no', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_history_on_blood_barcode_no on fomema_backup_nios.fw_transaction_history(blood_barcode_no);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_history.urine_barcode_no, idx_fw_transaction_history_on_urine_barcode_no', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_history_on_urine_barcode_no on fomema_backup_nios.fw_transaction_history(urine_barcode_no);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index group_doctor_pay_history.group_code, idx_group_doctor_pay_history_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_group_doctor_pay_history_on_group_code on fomema_backup_nios.group_doctor_pay_history(group_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index group_doctor_pay_history.doctor_code, idx_group_doctor_pay_history_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_group_doctor_pay_history_on_doctor_code on fomema_backup_nios.group_doctor_pay_history(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index group_xray_pay_history.group_code, idx_group_xray_pay_history_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_group_xray_pay_history_on_group_code on fomema_backup_nios.group_xray_pay_history(group_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index group_xray_pay_history.xray_code, idx_group_xray_pay_history_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_group_xray_pay_history_on_xray_code on fomema_backup_nios.group_xray_pay_history(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index laboratory_history.laboratory_code, idx_laboratory_history_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_history_on_laboratory_code on fomema_backup_nios.laboratory_history(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_history.post_code, idx_laboratory_history_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_history_on_post_code on fomema_backup_nios.laboratory_history(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_history.state_code, idx_laboratory_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_history_on_state_code on fomema_backup_nios.laboratory_history(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_history.district_code, idx_laboratory_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_history_on_district_code on fomema_backup_nios.laboratory_history(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_history.country_code, idx_laboratory_history_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_history_on_country_code on fomema_backup_nios.laboratory_history(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_history.status_code, idx_laboratory_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_history_on_status_code on fomema_backup_nios.laboratory_history(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_history.gst_code, idx_laboratory_history_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_history_on_gst_code on fomema_backup_nios.laboratory_history(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_history.bank_code, idx_laboratory_history_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_history_on_bank_code on fomema_backup_nios.laboratory_history(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index payment_req_history.branch_code, idx_payment_req_history_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_req_history_on_branch_code on fomema_backup_nios.payment_req_history(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_req_history.gst_code, idx_payment_req_history_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_req_history_on_gst_code on fomema_backup_nios.payment_req_history(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_req_history.service_provider_code, idx_payment_req_history_on_service_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_req_history_on_service_provider_code on fomema_backup_nios.payment_req_history(service_provider_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_req_history.sp_code, idx_payment_req_history_on_sp_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_req_history_on_sp_code on fomema_backup_nios.payment_req_history(sp_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment_req_history.worker_code, idx_payment_req_history_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_req_history_on_worker_code on fomema_backup_nios.payment_req_history(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index quarantine_release_req_history.trans_id, idx_quarantine_release_req_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_quarantine_release_req_history_on_trans_id on fomema_backup_nios.quarantine_release_req_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index receipt_detail_history.bank_code, idx_receipt_detail_history_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_detail_history_on_bank_code on fomema_backup_nios.receipt_detail_history(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt_detail_history.zone_code, idx_receipt_detail_history_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_detail_history_on_zone_code on fomema_backup_nios.receipt_detail_history(zone_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt_detail_history.approval_code, idx_receipt_detail_history_on_approval_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_detail_history_on_approval_code on fomema_backup_nios.receipt_detail_history(approval_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index receipt_history.contact_post_code, idx_receipt_history_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_history_on_contact_post_code on fomema_backup_nios.receipt_history(contact_post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt_history.contact_state_code, idx_receipt_history_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_history_on_contact_state_code on fomema_backup_nios.receipt_history(contact_state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt_history.contact_district_code, idx_receipt_history_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_history_on_contact_district_code on fomema_backup_nios.receipt_history(contact_district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt_history.branch_code, idx_receipt_history_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_history_on_branch_code on fomema_backup_nios.receipt_history(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index receipt_usage_history.trans_id, idx_receipt_usage_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_usage_history_on_trans_id on fomema_backup_nios.receipt_usage_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index receipt_usage_history.status_code, idx_receipt_usage_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_receipt_usage_history_on_status_code on fomema_backup_nios.receipt_usage_history(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index refund_detail_history.trans_id, idx_refund_detail_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_refund_detail_history_on_trans_id on fomema_backup_nios.refund_detail_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index refund_detail_history.status_code, idx_refund_detail_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_refund_detail_history_on_status_code on fomema_backup_nios.refund_detail_history(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index refund_history.status_code, idx_refund_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_refund_history_on_status_code on fomema_backup_nios.refund_history(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index refund_history.branch_code, idx_refund_history_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_refund_history_on_branch_code on fomema_backup_nios.refund_history(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index rfw_batch_transaction_history.laboratory_code_a, idx_rfw_batch_transaction_history_on_laboratory_code_a', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_batch_transaction_history_on_laboratory_code_a on fomema_backup_nios.rfw_batch_transaction_history(laboratory_code_a);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index rfw_batch_transaction_history.laboratory_code_b, idx_rfw_batch_transaction_history_on_laboratory_code_b', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_batch_transaction_history_on_laboratory_code_b on fomema_backup_nios.rfw_batch_transaction_history(laboratory_code_b);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index rfw_batch_transaction_history.status_code, idx_rfw_batch_transaction_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_batch_transaction_history_on_status_code on fomema_backup_nios.rfw_batch_transaction_history(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index rfw_batch_transaction_history.laboratory_code_ori, idx_rfw_batch_transaction_history_on_laboratory_code_ori', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_batch_transaction_history_on_laboratory_code_ori on fomema_backup_nios.rfw_batch_transaction_history(laboratory_code_ori);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index rfw_case_transaction_history.trans_id, idx_rfw_case_transaction_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_case_transaction_history_on_trans_id on fomema_backup_nios.rfw_case_transaction_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index rfw_case_transaction_history.worker_code, idx_rfw_case_transaction_history_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_case_transaction_history_on_worker_code on fomema_backup_nios.rfw_case_transaction_history(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index rfw_case_transaction_history.status_code, idx_rfw_case_transaction_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_case_transaction_history_on_status_code on fomema_backup_nios.rfw_case_transaction_history(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index rfw_comment_history.parameter_code, idx_rfw_comment_history_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_comment_history_on_parameter_code on fomema_backup_nios.rfw_comment_history(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index rfw_detail_history.parameter_code, idx_rfw_detail_history_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_detail_history_on_parameter_code on fomema_backup_nios.rfw_detail_history(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index rfw_fw_transaction_history.laboratory_code, idx_rfw_fw_transaction_history_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_rfw_fw_transaction_history_on_laboratory_code on fomema_backup_nios.rfw_fw_transaction_history(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index service_provider_group_history.district_code, idx_service_provider_group_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_provider_group_history_on_district_code on fomema_backup_nios.service_provider_group_history(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index service_provider_group_history.group_code, idx_service_provider_group_history_on_group_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_provider_group_history_on_group_code on fomema_backup_nios.service_provider_group_history(group_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index service_provider_group_history.postcode, idx_service_provider_group_history_on_postcode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_provider_group_history_on_postcode on fomema_backup_nios.service_provider_group_history(postcode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index service_provider_group_history.state_code, idx_service_provider_group_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_provider_group_history_on_state_code on fomema_backup_nios.service_provider_group_history(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index service_provider_group_history.gst_code, idx_service_provider_group_history_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_provider_group_history_on_gst_code on fomema_backup_nios.service_provider_group_history(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index service_provider_group_history.bank_code, idx_service_provider_group_history_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_provider_group_history_on_bank_code on fomema_backup_nios.service_provider_group_history(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index service_provider_group_history.service_provider_master_code, idx_service_provider_group_history_on_spmc', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_provider_group_history_on_spmc on fomema_backup_nios.service_provider_group_history(service_provider_master_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index v_foreign_worker_history.status_code, idx_v_foreign_worker_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_foreign_worker_history_on_status_code on fomema_backup_nios.v_foreign_worker_history(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index v_foreign_worker_history.worker_code, idx_v_foreign_worker_history_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_foreign_worker_history_on_worker_code on fomema_backup_nios.v_foreign_worker_history(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index v_foreign_worker_history.employer_code, idx_v_foreign_worker_history_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_foreign_worker_history_on_employer_code on fomema_backup_nios.v_foreign_worker_history(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index v_foreign_worker_history.country_code, idx_v_foreign_worker_history_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_foreign_worker_history_on_country_code on fomema_backup_nios.v_foreign_worker_history(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index v_foreign_worker_history.clinic_code, idx_v_foreign_worker_history_on_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_foreign_worker_history_on_clinic_code on fomema_backup_nios.v_foreign_worker_history(clinic_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index wrong_transmission_history.trans_id, idx_wrong_transmission_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_wrong_transmission_history_on_trans_id on fomema_backup_nios.wrong_transmission_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index wrong_transmission_history.provider_code, idx_wrong_transmission_history_on_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_wrong_transmission_history_on_provider_code on fomema_backup_nios.wrong_transmission_history(provider_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index xqua_release_req_history.trans_id, idx_xqua_release_req_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xqua_release_req_history_on_trans_id on fomema_backup_nios.xqua_release_req_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_adhoc_submit_history.trans_id, idx_xray_adhoc_submit_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_adhoc_submit_history_on_trans_id on fomema_backup_nios.xray_adhoc_submit_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_adhoc_submit_history.xray_code, idx_xray_adhoc_submit_history_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_adhoc_submit_history_on_xray_code on fomema_backup_nios.xray_adhoc_submit_history(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_adhoc_submit_history.worker_code, idx_xray_adhoc_submit_history_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_adhoc_submit_history_on_worker_code on fomema_backup_nios.xray_adhoc_submit_history(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_history.xray_code, idx_xray_history_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_history_on_xray_code on fomema_backup_nios.xray_history(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_history.post_code, idx_xray_history_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_history_on_post_code on fomema_backup_nios.xray_history(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_history.district_code, idx_xray_history_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_history_on_district_code on fomema_backup_nios.xray_history(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_history.state_code, idx_xray_history_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_history_on_state_code on fomema_backup_nios.xray_history(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_history.country_code, idx_xray_history_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_history_on_country_code on fomema_backup_nios.xray_history(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_history.status_code, idx_xray_history_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_history_on_status_code on fomema_backup_nios.xray_history(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_history.gst_code, idx_xray_history_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_history_on_gst_code on fomema_backup_nios.xray_history(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_history.bank_code, idx_xray_history_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_history_on_bank_code on fomema_backup_nios.xray_history(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_submit_history.trans_id, idx_xray_submit_history_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_history_on_trans_id on fomema_backup_nios.xray_submit_history(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_submit_history.xray_code, idx_xray_submit_history_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_history_on_xray_code on fomema_backup_nios.xray_submit_history(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_submit_history.worker_code, idx_xray_submit_history_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_submit_history_on_worker_code on fomema_backup_nios.xray_submit_history(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_process;

end;
$$;
