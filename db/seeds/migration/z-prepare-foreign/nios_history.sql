
drop foreign table if exists fomema_backup_nios.agent_history;

create foreign table if not exists fomema_backup_nios.agent_history (
    "agent_code" varchar(10),
    "bc_agent_code" varchar(13),
    "agent_name" varchar(50),
    "agency_licence_no" varchar(10),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "address4" varchar(50),
    "post_code" varchar(10),
    "phone" varchar(25),
    "fax" varchar(25),
    "email_id" varchar(100),
    "district_code" varchar(7),
    "state_code" varchar(7),
    "country_code" varchar(3),
    "primary_contact_person" varchar(50),
    "primary_contact_phone_no" varchar(20),
    "version_no" varchar(10),
    "comments" varchar(40),
    "district_name" varchar(40),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "status_code" varchar(5),
    "branch_code" varchar(2),
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'agent_history');

\echo 'created foreign table fomema_backup_nios.agent_history';

drop foreign table if exists fomema_backup_nios.bad_payment_history;

create foreign table if not exists fomema_backup_nios.bad_payment_history (
    "paymentid" numeric(10),
    "bank_code" varchar(8),
    "bank_branch" varchar(100),
    "document_no" varchar(50),
    "document_date" timestamp,
    "contact_name" varchar(50),
    "contact_phone" varchar(25),
    "contact_fax" varchar(25),
    "contact_address1" varchar(50),
    "contact_address2" varchar(50),
    "contact_address3" varchar(50),
    "contact_address4" varchar(50),
    "contact_post_code" varchar(10),
    "contact_state_code" varchar(7),
    "contact_district_code" varchar(7),
    "amount" numeric(10, 2),
    "status" varchar(5),
    "comments" varchar(4000),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "version_no" varchar(10),
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'bad_payment_history');

\echo 'created foreign table fomema_backup_nios.bad_payment_history';

drop foreign table if exists fomema_backup_nios.batch_coupling_change_history;

create foreign table if not exists fomema_backup_nios.batch_coupling_change_history (
    "batch_transid" varchar(14),
    "bc_doctor_code" varchar(13),
    "bc_laboratory_code" varchar(13),
    "bc_xray_code" varchar(13),
    "status" varchar(2),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'batch_coupling_change_history');

\echo 'created foreign table fomema_backup_nios.batch_coupling_change_history';

drop foreign table if exists fomema_backup_nios.district_office_history;

create foreign table if not exists fomema_backup_nios.district_office_history (
    "office_code" varchar(7),
    "office_name" varchar(255),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "address4" varchar(50),
    "post_code" varchar(10),
    "phone" varchar(25),
    "fax" varchar(25),
    "email_id" varchar(100),
    "primary_contact_person" varchar(50),
    "district_code" varchar(7),
    "state_code" varchar(7),
    "status_code" varchar(5),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "log_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'district_office_history');

\echo 'created foreign table fomema_backup_nios.district_office_history';

drop foreign table if exists fomema_backup_nios.doctor_history;

create foreign table if not exists fomema_backup_nios.doctor_history (
    "doctor_code" varchar(10),
    "version_no" varchar(10),
    "creation_date" timestamp,
    "doctor_name" varchar(50),
    "clinic_name" varchar(100),
    "doctor_ic_new" varchar(20),
    "doctor_ic_old" varchar(20),
    "annual_practice_certificate" varchar(20),
    "application_number" varchar(7),
    "application_year" varchar(4),
    "kdm_member" varchar(10),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "address4" varchar(50),
    "post_code" varchar(10),
    "district_code" varchar(7),
    "state_code" varchar(7),
    "country_code" varchar(3),
    "phone" varchar(100),
    "fax" varchar(100),
    "xray_code" varchar(10),
    "radiologist_code" varchar(10),
    "laboratory_code" varchar(10),
    "email_id" varchar(100),
    "xray_regn_no" varchar(20),
    "own_xray_clinic" varchar(1),
    "qualification" varchar(50),
    "no_of_solo_clinics" varchar(2),
    "no_of_group_clinics" varchar(2),
    "comments" varchar(4000),
    "numquarantine" numeric(4),
    "district_name" varchar(40),
    "modification_date" timestamp,
    "bc_doctor_code" varchar(13),
    "status_code" varchar(5),
    "quota" numeric(5),
    "quota_use" numeric(5),
    "nearest_district_office" varchar(7),
    "creator_id" numeric(10),
    "modify_id" numeric(10),
    "isproblematic" varchar(2),
    "bc_radiologist_code" varchar(13),
    "bc_xray_code" varchar(13),
    "bc_laboratory_code" varchar(13),
    "prefer_xray_code" varchar(13),
    "prefer_xray_distance" varchar(10),
    "dregid" numeric(10),
    "action" varchar(10),
    "action_date" timestamp,
    "mobile_no" varchar(20),
    "renewal_date" timestamp,
    "gst_code" varchar(20),
    "gst_tax" numeric(126),
    "male_rate" numeric(126),
    "female_rate" numeric(126),
    "bank_account_no" varchar(20),
    "bank_code" varchar(8),
    "gst_type" numeric(1),
    "mystics_ic" numeric(1)
) server fomema_backup options (schema_name 'nios', table_name 'doctor_history');

\echo 'created foreign table fomema_backup_nios.doctor_history';

drop foreign table if exists fomema_backup_nios.employer_history;

create foreign table if not exists fomema_backup_nios.employer_history (
    "creation_date" timestamp,
    "employer_name" varchar(150),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "address4" varchar(50),
    "post_code" varchar(10),
    "phone" varchar(100),
    "fax" varchar(100),
    "comments" varchar(4000),
    "district_code" varchar(7),
    "employer_code" varchar(10),
    "version_no" varchar(10),
    "email_id" varchar(100),
    "primary_contact_person" varchar(50),
    "business_code" varchar(10),
    "country_code" varchar(3),
    "state_code" varchar(7),
    "primary_contact_phone" varchar(20),
    "doctor_code" varchar(10),
    "district_name" varchar(40),
    "modification_date" timestamp,
    "bc_employer_code" varchar(13),
    "bc_doctor_code" varchar(13),
    "status_code" varchar(5),
    "branch_code" varchar(2),
    "creator_id" numeric(10),
    "modify_id" numeric(10),
    "isblacklisted" varchar(5),
    "blacklisted_date" timestamp,
    "classification" varchar(5),
    "action" varchar(10),
    "action_date" timestamp,
    "company_regno" varchar(20),
    "icpassport_no" varchar(20),
    "employer_type" numeric(1)
) server fomema_backup options (schema_name 'nios', table_name 'employer_history');

\echo 'created foreign table fomema_backup_nios.employer_history';

drop foreign table if exists fomema_backup_nios.fw_appeal_approval_history;

create foreign table if not exists fomema_backup_nios.fw_appeal_approval_history (
    "appealappid" numeric(10),
    "appealid" numeric(10),
    "req_userid" numeric(10),
    "req_date" timestamp,
    "req_comments" varchar(4000),
    "approval_userid" numeric(10),
    "approval_date" timestamp,
    "approval_comments" varchar(4000),
    "status" varchar(1),
    "appeal_result" varchar(1),
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fw_appeal_approval_history');

\echo 'created foreign table fomema_backup_nios.fw_appeal_approval_history';

drop foreign table if exists fomema_backup_nios.fw_appeal_history;

create foreign table if not exists fomema_backup_nios.fw_appeal_history (
    "appealid" numeric(10),
    "trans_id" varchar(14),
    "bc_worker_code" varchar(13),
    "appeal_doctor_code" varchar(13),
    "letter_apointment_date" timestamp,
    "result_date" timestamp,
    "idemnity_date" timestamp,
    "letter_notification" timestamp,
    "comments" varchar(4000),
    "follow_up" varchar(13),
    "status" varchar(5),
    "appeal_success" varchar(5),
    "creation_date" timestamp,
    "modification_date" timestamp,
    "phase_status" varchar(2),
    "blood_group" varchar(3),
    "rh" varchar(1),
    "appeal_close_comments" varchar(4000),
    "officer_incharge" varchar(50),
    "iscancelled" varchar(1),
    "action" varchar(10),
    "action_date" timestamp,
    "appeal_type" varchar(3),
    "appeal_start_comments" varchar(4000),
    "creator_id" varchar(10),
    "modification_id" varchar(10),
    "appeal_summary_comments" varchar(4000)
) server fomema_backup options (schema_name 'nios', table_name 'fw_appeal_history');

\echo 'created foreign table fomema_backup_nios.fw_appeal_history';

drop foreign table if exists fomema_backup_nios.fw_comment_history;

create foreign table if not exists fomema_backup_nios.fw_comment_history (
    "log_date" timestamp,
    "trans_id" varchar(14),
    "parameter_code" varchar(10),
    "comments" varchar(1000),
    "modification_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fw_comment_history');

\echo 'created foreign table fomema_backup_nios.fw_comment_history';

drop foreign table if exists fomema_backup_nios.fw_detail_history;

create foreign table if not exists fomema_backup_nios.fw_detail_history (
    "parameter_code" varchar(10),
    "trans_id" varchar(14),
    "med_history" varchar(5),
    "effected_date" timestamp,
    "modification_date" timestamp,
    "parameter_value" varchar(20),
    "action" varchar(10),
    "action_date" timestamp,
    "modify_id" numeric(10)
) server fomema_backup options (schema_name 'nios', table_name 'fw_detail_history');

\echo 'created foreign table fomema_backup_nios.fw_detail_history';

drop foreign table if exists fomema_backup_nios.fw_extra_comments_history;

create foreign table if not exists fomema_backup_nios.fw_extra_comments_history (
    "trans_id" varchar(14),
    "log_date" timestamp,
    "comment_date" timestamp,
    "comment_time" varchar(8),
    "userid" varchar(30),
    "action" varchar(10),
    "action_date" timestamp,
    "comments" varchar(4000)
) server fomema_backup options (schema_name 'nios', table_name 'fw_extra_comments_history');

\echo 'created foreign table fomema_backup_nios.fw_extra_comments_history';

drop foreign table if exists fomema_backup_nios.fw_quarantine_reason_history;

create foreign table if not exists fomema_backup_nios.fw_quarantine_reason_history (
    "trans_id" varchar(14),
    "reason_code" varchar(10),
    "log_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fw_quarantine_reason_history');

\echo 'created foreign table fomema_backup_nios.fw_quarantine_reason_history';

drop foreign table if exists fomema_backup_nios.fw_transaction_history;

create foreign table if not exists fomema_backup_nios.fw_transaction_history (
    "trans_id" varchar(14),
    "log_date" timestamp,
    "worker_code" varchar(10),
    "xray_code" varchar(10),
    "radiologist_code" varchar(10),
    "doctor_code" varchar(10),
    "laboratory_code" varchar(10),
    "employer_code" varchar(10),
    "transdate" timestamp,
    "org_bit" varchar(1),
    "certify_date" timestamp,
    "exam_date" timestamp,
    "lab_submit_date" timestamp,
    "xray_submit_date" timestamp,
    "height" varchar(6),
    "weight" varchar(6),
    "pulse" varchar(6),
    "systolic" varchar(6),
    "diastolic" varchar(6),
    "bld_grp" varchar(2),
    "rh" varchar(1),
    "fit_ind" varchar(1),
    "imm_ind" varchar(1),
    "renew_ind" varchar(1),
    "qrtn_ind" varchar(1),
    "imm_send_ind" varchar(1),
    "lab_notdone_ind" varchar(1),
    "xray_notdone_ind" varchar(1),
    "release_date" timestamp,
    "invalidate_result" varchar(1),
    "invalidate_date" timestamp,
    "imm_send_date" timestamp,
    "user_id" varchar(30),
    "modification_date" timestamp,
    "bc_doctor_code" varchar(13),
    "bc_employer_code" varchar(13),
    "bc_laboratory_code" varchar(13),
    "bc_radiologist_code" varchar(13),
    "bc_xray_code" varchar(13),
    "bc_worker_code" varchar(13),
    "version_no" varchar(10),
    "xray_testdone_date" timestamp,
    "tcupi_ind" varchar(1),
    "taken_drugs" varchar(1),
    "lab_specimen_date" timestamp,
    "worker_consent" varchar(1),
    "action" varchar(10),
    "action_date" timestamp,
    "last_pms_date" timestamp,
    "modify_id" numeric(10),
    "created_by" varchar(30),
    "ismonitor" char(1),
    "doctor_state_code" varchar(7),
    "ply_count" numeric,
    "irr_ind" varchar(1),
    "imr_ind" varchar(1),
    "med_ind" numeric,
    "reg_ind" numeric,
    "xray_film_type" varchar(1),
    "xqrtn_ind" varchar(1),
    "badpayment_ind" numeric(1),
    "xrelease_date" timestamp,
    "unfit_printed" varchar(1),
    "dfit_ind" numeric(1),
    "mfit_ind" numeric(1),
    "xfit_ind" numeric(1),
    "mr" numeric(1),
    "xr" numeric(1),
    "payment_ind" numeric(1),
    "sex" varchar(1),
    "plks_no" numeric(3),
    "ispra" numeric(1),
    "lab_specimen_taken_date" timestamp,
    "blood_barcode_no" varchar(20),
    "urine_barcode_no" varchar(20),
    "xray_ref_no" varchar(20),
    "provider_id" varchar(3),
    "xray_upload_status" varchar(3)
) server fomema_backup options (schema_name 'nios', table_name 'fw_transaction_history');

\echo 'created foreign table fomema_backup_nios.fw_transaction_history';

drop foreign table if exists fomema_backup_nios.group_doctor_pay_history;

create foreign table if not exists fomema_backup_nios.group_doctor_pay_history (
    "group_code" varchar(6),
    "doctor_code" varchar(10),
    "group_status" varchar(1),
    "create_date" timestamp,
    "action" varchar(6),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'group_doctor_pay_history');

\echo 'created foreign table fomema_backup_nios.group_doctor_pay_history';

drop foreign table if exists fomema_backup_nios.group_xray_pay_history;

create foreign table if not exists fomema_backup_nios.group_xray_pay_history (
    "group_code" varchar(6),
    "pay_ind" varchar(1),
    "xray_code" varchar(10),
    "group_status" varchar(1),
    "create_date" timestamp,
    "action" varchar(6),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'group_xray_pay_history');

\echo 'created foreign table fomema_backup_nios.group_xray_pay_history';

drop foreign table if exists fomema_backup_nios.laboratory_history;

create foreign table if not exists fomema_backup_nios.laboratory_history (
    "laboratory_code" varchar(10),
    "version_no" varchar(10),
    "creation_date" timestamp,
    "laboratory_name" varchar(50),
    "registration_no" varchar(20),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "address4" varchar(50),
    "post_code" varchar(10),
    "phone" varchar(100),
    "fax" varchar(100),
    "state_code" varchar(7),
    "district_code" varchar(7),
    "country_code" varchar(3),
    "email_id" varchar(100),
    "primary_contact_person" varchar(50),
    "primary_contact_phone" varchar(20),
    "lab_type" varchar(1),
    "qualification" varchar(50),
    "comments" varchar(4000),
    "district_name" varchar(40),
    "modification_date" timestamp,
    "bc_laboratory_code" varchar(13),
    "status_code" varchar(5),
    "nearest_district_office" varchar(7),
    "classification" varchar(5),
    "creator_id" numeric(10),
    "modify_id" numeric(10),
    "lab_group" varchar(2),
    "grade_point" numeric(3),
    "license" varchar(20),
    "license_year" varchar(4),
    "lregid" numeric(10),
    "action" varchar(10),
    "action_date" timestamp,
    "web_service_access" char(1),
    "passphrase" varchar(100),
    "mobile_no" varchar(20),
    "renewal_date" timestamp,
    "gst_code" varchar(20),
    "gst_tax" numeric(126),
    "male_rate" numeric(126),
    "female_rate" numeric(126),
    "bank_account_no" varchar(20),
    "laboratory_logo" varchar(50),
    "web_taxinvoice" numeric(1),
    "bank_code" varchar(8),
    "gst_type" numeric(1),
    "gst_effective_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'laboratory_history');

\echo 'created foreign table fomema_backup_nios.laboratory_history';

drop foreign table if exists fomema_backup_nios.payment_req_history;

create foreign table if not exists fomema_backup_nios.payment_req_history (
    "id" numeric(19),
    "amount" numeric(126),
    "branch_code" varchar(8),
    "certify_date" timestamp,
    "create_date" timestamp,
    "creator_id" varchar(40),
    "fin_batch_no" numeric(10),
    "gst_code" varchar(80),
    "gst_tax" numeric(126),
    "gst_type" numeric(10),
    "gstamount" numeric(126),
    "invoice_date" timestamp,
    "invoice_no" varchar(120),
    "payment_req_id" numeric(10),
    "reference_id" varchar(1020),
    "request_date" timestamp,
    "service_provider_code" varchar(40),
    "service_provider_group_id" varchar(120),
    "sex" varchar(4),
    "sp_code" varchar(40),
    "sp_type" varchar(4),
    "status" numeric(10),
    "trans_type" numeric(10),
    "transid" varchar(56),
    "worker_code" varchar(40),
    "worker_name" varchar(200),
    "isread" numeric,
    "read_date" timestamp,
    "read_by" varchar(7)
) server fomema_backup options (schema_name 'nios', table_name 'payment_req_history');

\echo 'created foreign table fomema_backup_nios.payment_req_history';

drop foreign table if exists fomema_backup_nios.provider_history;

create foreign table if not exists fomema_backup_nios.provider_history (
    "service_provider" varchar(10),
    "action_date" timestamp,
    "old_status" varchar(5),
    "new_status" varchar(5),
    "old_state" varchar(7),
    "new_state" varchar(7),
    "action" varchar(20)
) server fomema_backup options (schema_name 'nios', table_name 'provider_history');

\echo 'created foreign table fomema_backup_nios.provider_history';

drop foreign table if exists fomema_backup_nios.quarantine_release_req_history;

create foreign table if not exists fomema_backup_nios.quarantine_release_req_history (
    "qrrid" numeric(18),
    "trans_id" varchar(14),
    "comments" varchar(4000),
    "status" varchar(5),
    "medstatus" char(1),
    "request_by" numeric(10),
    "creation_date" timestamp,
    "ismonitor" char(1),
    "mle" numeric(10),
    "assessment_date" timestamp,
    "release_date" timestamp,
    "modify_id" numeric(10),
    "modify_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_release_req_history');

\echo 'created foreign table fomema_backup_nios.quarantine_release_req_history';

drop foreign table if exists fomema_backup_nios.quarantine_status_history;

create foreign table if not exists fomema_backup_nios.quarantine_status_history (
    "bc_worker_code" varchar(13),
    "old_status" varchar(1),
    "new_status" varchar(1),
    "userid" numeric(10),
    "mod_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_status_history');

\echo 'created foreign table fomema_backup_nios.quarantine_status_history';

drop foreign table if exists fomema_backup_nios.receipt_detail_history;

create foreign table if not exists fomema_backup_nios.receipt_detail_history (
    "tranno" varchar(10),
    "payment_type" numeric(3),
    "payment_no" varchar(16),
    "payment_amount" numeric(10, 2),
    "bank_code" varchar(8),
    "branch_area" varchar(100),
    "zone_code" varchar(2),
    "version_no" varchar(10),
    "date_issue" timestamp,
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp,
    "name_on_card" varchar(100),
    "expiry_date" timestamp,
    "approval_code" varchar(20),
    "ref_no" varchar(50),
    "payment_surcharge" numeric(10, 2),
    "card_type" varchar(20)
) server fomema_backup options (schema_name 'nios', table_name 'receipt_detail_history');

\echo 'created foreign table fomema_backup_nios.receipt_detail_history';

drop foreign table if exists fomema_backup_nios.receipt_history;

create foreign table if not exists fomema_backup_nios.receipt_history (
    "tranno" varchar(10),
    "oldtranno" varchar(10),
    "status" varchar(10),
    "no_male" numeric(5),
    "no_female" numeric(5),
    "amount" numeric(10, 2),
    "amount_paid" numeric(10, 2),
    "service_type" varchar(2),
    "isfoc" varchar(5),
    "isrefunded" varchar(5),
    "foc_reason" varchar(4000),
    "void_reason" varchar(4000),
    "printed" varchar(5),
    "print_count" numeric(5),
    "contact_name" varchar(50),
    "contact_phone" varchar(100),
    "contact_fax" varchar(100),
    "contact_address1" varchar(50),
    "contact_address2" varchar(50),
    "contact_address3" varchar(50),
    "contact_address4" varchar(50),
    "contact_post_code" varchar(10),
    "contact_state_code" varchar(7),
    "contact_district_code" varchar(7),
    "branch_code" varchar(2),
    "received_by" varchar(100),
    "trandate" timestamp,
    "expirydate" timestamp,
    "version_no" varchar(10),
    "comments" varchar(4000),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "no_uses" numeric(5),
    "no_uses_count" numeric(5),
    "service_provider" varchar(13),
    "action" varchar(10),
    "action_date" timestamp,
    "kivexpiry_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'receipt_history');

\echo 'created foreign table fomema_backup_nios.receipt_history';

drop foreign table if exists fomema_backup_nios.receipt_history_medcon;

create foreign table if not exists fomema_backup_nios.receipt_history_medcon (
    "trandate" timestamp,
    "tranno" varchar(10),
    "cancel" varchar(1),
    "employer" varchar(50),
    "company" varchar(50),
    "no_male" numeric(5),
    "no_female" numeric(5),
    "received_by" varchar(10),
    "amount" numeric(10, 2),
    "service_type" varchar(2),
    "deleted_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'receipt_history_medcon');

\echo 'created foreign table fomema_backup_nios.receipt_history_medcon';

drop foreign table if exists fomema_backup_nios.receipt_prefer_doctor_history;

create foreign table if not exists fomema_backup_nios.receipt_prefer_doctor_history (
    "tranno" varchar(10),
    "trandate" timestamp,
    "bc_doctor_code" varchar(13),
    "allocation" numeric(10),
    "allocation_use" numeric(10),
    "version_no" varchar(10),
    "log_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp,
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'receipt_prefer_doctor_history');

\echo 'created foreign table fomema_backup_nios.receipt_prefer_doctor_history';

drop foreign table if exists fomema_backup_nios.receipt_usage_history;

create foreign table if not exists fomema_backup_nios.receipt_usage_history (
    "trandate" timestamp,
    "tranno" varchar(10),
    "trans_id" varchar(14),
    "bc_worker_code" varchar(13),
    "status_code" varchar(5),
    "comments" varchar(4000),
    "version_no" varchar(5),
    "trans_version_no" varchar(5),
    "log_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp,
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'receipt_usage_history');

\echo 'created foreign table fomema_backup_nios.receipt_usage_history';

drop foreign table if exists fomema_backup_nios.refund_detail_history;

create foreign table if not exists fomema_backup_nios.refund_detail_history (
    "refund_detailid" varchar(15),
    "refundid" varchar(15),
    "refund_type" varchar(5),
    "amount" numeric(10, 2),
    "admin_charges" numeric(10, 2),
    "trans_id" varchar(14),
    "bc_worker_code" varchar(13),
    "worker_name" varchar(40),
    "bc_employer_code" varchar(13),
    "receipt_tranno" varchar(10),
    "receipt_trandate" timestamp,
    "registration_date" timestamp,
    "doc_4ply_employer" varchar(1),
    "doc_4ply_doctor" varchar(1),
    "doc_4ply_laboratory" varchar(1),
    "doc_4ply_xray" varchar(1),
    "total_male" numeric(5),
    "total_female" numeric(5),
    "total_worker" numeric(10),
    "total_kiv_male" numeric(5),
    "total_kiv_female" numeric(5),
    "unutilised_amount" numeric(10, 2),
    "payment_mode" varchar(5),
    "payment_amount" numeric(10, 2),
    "doc_letter" varchar(1),
    "doc_receipt" varchar(1),
    "comments" varchar(4000),
    "status_code" varchar(10),
    "ply_reprint_count" numeric(10),
    "version_no" varchar(10),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp,
    "receipt_oldno" varchar(10),
    "transdate" timestamp,
    "sex" char(1)
) server fomema_backup options (schema_name 'nios', table_name 'refund_detail_history');

\echo 'created foreign table fomema_backup_nios.refund_detail_history';

drop foreign table if exists fomema_backup_nios.refund_history;

create foreign table if not exists fomema_backup_nios.refund_history (
    "refundid" varchar(15),
    "total_amount" numeric(10, 2),
    "date_received_document" timestamp,
    "cheque_number" varchar(20),
    "cheque_payment_date" timestamp,
    "cheque_release_date" timestamp,
    "contact_name" varchar(50),
    "contact_phone" varchar(100),
    "contact_address1" varchar(50),
    "contact_address2" varchar(50),
    "contact_address3" varchar(50),
    "contact_address4" varchar(50),
    "admin_charges" numeric(10, 2),
    "comments" varchar(4000),
    "status_code" varchar(10),
    "version_no" varchar(10),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp,
    "refundee_name" varchar(50),
    "refundee_phone" varchar(100),
    "refundee_address1" varchar(50),
    "refundee_address2" varchar(50),
    "refundee_address3" varchar(50),
    "refundee_address4" varchar(50),
    "service_provider" varchar(13),
    "branch_code" varchar(2),
    "cheque_amount" numeric(10, 2)
) server fomema_backup options (schema_name 'nios', table_name 'refund_history');

\echo 'created foreign table fomema_backup_nios.refund_history';

drop foreign table if exists fomema_backup_nios.request_table_hist;

create foreign table if not exists fomema_backup_nios.request_table_hist (
    "req_id" varchar(16),
    "req_type" varchar(2),
    "participants_details" varchar(2000),
    "request_read" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'request_table_hist');

\echo 'created foreign table fomema_backup_nios.request_table_hist';

drop foreign table if exists fomema_backup_nios.rfw_batch_transaction_history;

create foreign table if not exists fomema_backup_nios.rfw_batch_transaction_history (
    "rbatch_id" varchar(14),
    "laboratory_code_a" varchar(10),
    "bc_laboratory_code_a" varchar(13),
    "laboratory_code_b" varchar(10),
    "bc_laboratory_code_b" varchar(13),
    "status_code" varchar(1),
    "version_no" varchar(10),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modification_id" numeric(10),
    "modification_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp,
    "laboratory_code_ori" varchar(10),
    "bc_laboratory_code_ori" varchar(13)
) server fomema_backup options (schema_name 'nios', table_name 'rfw_batch_transaction_history');

\echo 'created foreign table fomema_backup_nios.rfw_batch_transaction_history';

drop foreign table if exists fomema_backup_nios.rfw_case_transaction_history;

create foreign table if not exists fomema_backup_nios.rfw_case_transaction_history (
    "rtrans_id" varchar(14),
    "rbatch_id" varchar(14),
    "trans_id" varchar(14),
    "worker_code" varchar(10),
    "bc_worker_code" varchar(13),
    "comments" varchar(4000),
    "specimen_type" varchar(5),
    "f1_specimen_takenbygp_date" timestamp,
    "f1_specimen_tested_date" timestamp,
    "f1_comments" varchar(4000),
    "f2_bloodgroup" char(1),
    "f2_elisa" char(1),
    "f2_hbsag" char(1),
    "f2_vdrltpha" char(1),
    "f2_tpha" char(1),
    "f2_malaria" char(1),
    "f2_urineopiates" char(1),
    "f2_urinecannabis" char(1),
    "f2_urinepregnancy" char(1),
    "f2_urinecolor" char(1),
    "f2_urinegravity" char(1),
    "f2_urinesugar" char(1),
    "f2_urinealbumin" char(1),
    "f2_urinemicroexam" char(1),
    "specimen_surrender_date" timestamp,
    "status_code" varchar(1),
    "version_no" varchar(10),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modification_id" numeric(10),
    "modification_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp,
    "tag_ind" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'rfw_case_transaction_history');

\echo 'created foreign table fomema_backup_nios.rfw_case_transaction_history';

drop foreign table if exists fomema_backup_nios.rfw_comment_history;

create foreign table if not exists fomema_backup_nios.rfw_comment_history (
    "rfwtrans_id" varchar(14),
    "parameter_code" varchar(10),
    "comments" varchar(1000),
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'rfw_comment_history');

\echo 'created foreign table fomema_backup_nios.rfw_comment_history';

drop foreign table if exists fomema_backup_nios.rfw_detail_history;

create foreign table if not exists fomema_backup_nios.rfw_detail_history (
    "rfwtrans_id" varchar(14),
    "parameter_code" varchar(10),
    "parameter_value" varchar(20),
    "med_history" varchar(1),
    "effected_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'rfw_detail_history');

\echo 'created foreign table fomema_backup_nios.rfw_detail_history';

drop foreign table if exists fomema_backup_nios.rfw_fw_transaction_history;

create foreign table if not exists fomema_backup_nios.rfw_fw_transaction_history (
    "rfwtrans_id" varchar(14),
    "rtrans_id" varchar(14),
    "laboratory_code" varchar(10),
    "bc_laboratory_code" varchar(13),
    "lab_submit_date" timestamp,
    "lab_specimen_date" timestamp,
    "bld_grp" varchar(2),
    "rh" varchar(1),
    "version_no" varchar(10),
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'rfw_fw_transaction_history');

\echo 'created foreign table fomema_backup_nios.rfw_fw_transaction_history';

drop foreign table if exists fomema_backup_nios.service_provider_group_history;

create foreign table if not exists fomema_backup_nios.service_provider_group_history (
    "id" numeric(19),
    "version" numeric(19),
    "address1" varchar(1020),
    "address2" varchar(1020),
    "address3" varchar(1020),
    "address4" varchar(1020),
    "bank_account_holder_name" varchar(1020),
    "bank_account_no" varchar(80),
    "district_code" varchar(1020),
    "fax" varchar(1020),
    "group_code" varchar(10),
    "group_name" varchar(200),
    "isactive" varchar(1020),
    "phone" varchar(1020),
    "postcode" varchar(1020),
    "service_type" varchar(4),
    "state_code" varchar(1020),
    "roc" varchar(1020),
    "female_rate" numeric(126),
    "male_rate" numeric(126),
    "business_reg_no" varchar(80),
    "email_address" varchar(100),
    "gst_code" varchar(20),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "gst_tax" numeric(126),
    "gst_type" numeric(10),
    "bank_code" varchar(8),
    "group_logo" varchar(50),
    "service_provider_master_code" varchar(10),
    "web_taxinvoice" numeric(1),
    "gst_effective_date" timestamp,
    "comments" varchar(4000),
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'service_provider_group_history');

\echo 'created foreign table fomema_backup_nios.service_provider_group_history';

drop foreign table if exists fomema_backup_nios.status_change_history;

create foreign table if not exists fomema_backup_nios.status_change_history (
    "worker_code" varchar(10),
    "trans_id" varchar(14),
    "old_status" varchar(1),
    "new_status" varchar(1),
    "userid" varchar(20),
    "mod_date" timestamp,
    "bc_worker_code" varchar(13),
    "source" numeric,
    "action" varchar(10),
    "action_date" timestamp,
    "wrongtrans_ind" varchar(3),
    "source_id" numeric,
    "decision" varchar(20)
) server fomema_backup options (schema_name 'nios', table_name 'status_change_history');

\echo 'created foreign table fomema_backup_nios.status_change_history';

drop foreign table if exists fomema_backup_nios.user_session_history;

create foreign table if not exists fomema_backup_nios.user_session_history (
    "sessionid" varchar(50),
    "remote_address" varchar(50),
    "last_access" timestamp,
    "request_uri" varchar(4000),
    "timeout" numeric(10)
) server fomema_backup options (schema_name 'nios', table_name 'user_session_history');

\echo 'created foreign table fomema_backup_nios.user_session_history';

drop foreign table if exists fomema_backup_nios.v_foreign_worker_history;

create foreign table if not exists fomema_backup_nios.v_foreign_worker_history (
    "worker_code" varchar(10),
    "version_no" varchar(10),
    "creation_date" timestamp,
    "worker_name" varchar(50),
    "employer_code" varchar(10),
    "fathers_name" varchar(50),
    "country_code" varchar(3),
    "date_of_birth" timestamp,
    "passport_no" varchar(20),
    "visa_no" varchar(20),
    "sex" varchar(1),
    "job_type" varchar(50),
    "arrival_date" timestamp,
    "departure_date" timestamp,
    "agent_code" varchar(10),
    "blood_group" varchar(3),
    "last_examine_date" timestamp,
    "employer_pref_ind" varchar(1),
    "imm_name" varchar(50),
    "fomema_ind" varchar(1),
    "renewal_date" timestamp,
    "modification_date" timestamp,
    "bc_worker_code" varchar(13),
    "bc_agent_code" varchar(13),
    "bc_employer_code" varchar(13),
    "fit_ind" varchar(1),
    "can_renew" varchar(5),
    "ismonitor" varchar(5),
    "isimmblock" varchar(5),
    "creator_id" numeric(10),
    "modify_id" numeric(10),
    "status_code" varchar(5),
    "ply_count" numeric(10),
    "ply_printed" varchar(5),
    "isblacklisted" varchar(5),
    "blacklisted_date" timestamp,
    "visa_expiry_date" timestamp,
    "rh" varchar(1),
    "classification" varchar(5),
    "action" varchar(10),
    "action_date" timestamp,
    "clinic_code" varchar(10),
    "clinic_examdate" timestamp,
    "created_by" varchar(10),
    "immblocked_by" varchar(3),
    "pati" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'v_foreign_worker_history');

\echo 'created foreign table fomema_backup_nios.v_foreign_worker_history';

drop foreign table if exists fomema_backup_nios.worker_cancel_history;

create foreign table if not exists fomema_backup_nios.worker_cancel_history (
    "fwcancelid" varchar(15),
    "admin_charge" varchar(5),
    "admin_fee" numeric(10, 2),
    "refund_amount" numeric(10, 2),
    "status" varchar(10),
    "version_no" varchar(10),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "cancelled_by" numeric(10),
    "cancelled_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'worker_cancel_history');

\echo 'created foreign table fomema_backup_nios.worker_cancel_history';

drop foreign table if exists fomema_backup_nios.wrong_transmission_history;

create foreign table if not exists fomema_backup_nios.wrong_transmission_history (
    "case_id" numeric,
    "provider_code" varchar(10),
    "trans_id" varchar(14),
    "trans_date" timestamp,
    "result_date" timestamp,
    "fwt_version_no" numeric,
    "comments" varchar(4000),
    "modify_id" varchar(20),
    "modify_date" timestamp,
    "version_no" numeric,
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'wrong_transmission_history');

\echo 'created foreign table fomema_backup_nios.wrong_transmission_history';

drop foreign table if exists fomema_backup_nios.xqcc_certificate_history;

create foreign table if not exists fomema_backup_nios.xqcc_certificate_history (
    "bc_xray_code" varchar(13),
    "status" varchar(1),
    "meet_sop" varchar(1),
    "acceptable_quality" varchar(1),
    "correct_report" varchar(1),
    "regular_submission" varchar(1),
    "date_approval" timestamp,
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modification_id" numeric(10),
    "modification_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_certificate_history');

\echo 'created foreign table fomema_backup_nios.xqcc_certificate_history';

drop foreign table if exists fomema_backup_nios.xqua_release_req_history;

create foreign table if not exists fomema_backup_nios.xqua_release_req_history (
    "xqrrid" numeric(18),
    "trans_id" varchar(14),
    "comments" varchar(4000),
    "status" varchar(5),
    "medstatus" char(1),
    "request_by" numeric(10),
    "creation_date" timestamp,
    "ismonitor" char(1),
    "mle" numeric(10),
    "assessment_date" timestamp,
    "release_date" timestamp,
    "modify_id" numeric(10),
    "modify_date" timestamp,
    "action" varchar(10),
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xqua_release_req_history');

\echo 'created foreign table fomema_backup_nios.xqua_release_req_history';

drop foreign table if exists fomema_backup_nios.xray_adhoc_submit_history;

create foreign table if not exists fomema_backup_nios.xray_adhoc_submit_history (
    "trans_id" varchar(14),
    "xray_code" varchar(10),
    "xray_name" varchar(50),
    "worker_code" varchar(10),
    "worker_name" varchar(50),
    "transdate" timestamp,
    "xray_submit_date" timestamp,
    "send_ind" varchar(5),
    "send_date" timestamp,
    "rownumber" numeric(11),
    "filetype" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 'xray_adhoc_submit_history');

\echo 'created foreign table fomema_backup_nios.xray_adhoc_submit_history';

drop foreign table if exists fomema_backup_nios.xray_history;

create foreign table if not exists fomema_backup_nios.xray_history (
    "xray_code" varchar(10),
    "creation_date" timestamp,
    "version_no" varchar(10),
    "xray_name" varchar(50),
    "xray_regn_no" varchar(20),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "address4" varchar(50),
    "post_code" varchar(10),
    "phone" varchar(100),
    "fax" varchar(100),
    "district_code" varchar(7),
    "state_code" varchar(7),
    "country_code" varchar(3),
    "email_id" varchar(100),
    "primary_contact_person" varchar(50),
    "primary_contact_phone_no" varchar(20),
    "qualification" varchar(50),
    "comments" varchar(4000),
    "district_name" varchar(40),
    "modification_date" timestamp,
    "bc_xray_code" varchar(13),
    "status_code" varchar(5),
    "classification" varchar(5),
    "creator_id" numeric(10),
    "modify_id" numeric(10),
    "grade_point" numeric(3),
    "license" varchar(20),
    "license_year" varchar(4),
    "xray_fac_flag" varchar(5),
    "xregid" numeric(10),
    "nearest_district_office" varchar(7),
    "xray_ic_new" varchar(20),
    "xray_ic_old" varchar(20),
    "mohlicense_status" varchar(5),
    "mohlicense_expirydate" timestamp,
    "action" varchar(10),
    "action_date" timestamp,
    "radiooperated" varchar(1),
    "radiologist_name" varchar(50),
    "apc_year" varchar(4),
    "apc_no" varchar(20),
    "mobile_no" varchar(20),
    "renewal_date" timestamp,
    "gst_code" varchar(20),
    "gst_tax" numeric(126),
    "male_rate" numeric(126),
    "female_rate" numeric(126),
    "bank_account_no" varchar(20),
    "digital_image" numeric(1),
    "mystics_ic" numeric(1),
    "bank_code" varchar(8),
    "gst_type" numeric(1)
) server fomema_backup options (schema_name 'nios', table_name 'xray_history');

\echo 'created foreign table fomema_backup_nios.xray_history';

drop foreign table if exists fomema_backup_nios.xray_submit_history;

create foreign table if not exists fomema_backup_nios.xray_submit_history (
    "trans_id" varchar(14),
    "xray_code" varchar(10),
    "xray_name" varchar(50),
    "worker_code" varchar(10),
    "worker_name" varchar(50),
    "transdate" timestamp,
    "xray_submit_date" timestamp,
    "send_ind" varchar(5),
    "send_date" timestamp,
    "rownumber" numeric(11),
    "filetype" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 'xray_submit_history');

\echo 'created foreign table fomema_backup_nios.xray_submit_history';
