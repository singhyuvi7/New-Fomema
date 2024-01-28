
drop foreign table if exists fomema_backup_nios.agent_master;

create foreign table if not exists fomema_backup_nios.agent_master (
    "agent_code" varchar(10),
    "agent_name" varchar(50),
    "agency_licence_no" varchar(10),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "address4" varchar(50),
    "post_code" varchar(10),
    "phone" varchar(100),
    "fax" varchar(100),
    "email_id" varchar(100),
    "district_code" varchar(7),
    "state_code" varchar(7),
    "country_code" varchar(3),
    "primary_contact_person" varchar(50),
    "primary_contact_phone_no" varchar(20),
    "version_no" varchar(10),
    "creation_date" timestamp,
    "comments" varchar(4000),
    "bc_agent_code" varchar(13),
    "branch_code" varchar(2),
    "status_code" varchar(5),
    "creator_id" numeric(10),
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'agent_master');

\echo 'created foreign table fomema_backup_nios.agent_master';

drop foreign table if exists fomema_backup_nios.bank_master;

create foreign table if not exists fomema_backup_nios.bank_master (
    "bank_code" varchar(8),
    "bank_name" varchar(100),
    "isactive" char(1),
    "swift_code" varchar(20),
    "local_bank" char(20),
    "routing" varchar(15),
    "routing2" varchar(15)
) server fomema_backup options (schema_name 'nios', table_name 'bank_master');

\echo 'created foreign table fomema_backup_nios.bank_master';

drop foreign table if exists fomema_backup_nios.bulletin_master;

create foreign table if not exists fomema_backup_nios.bulletin_master (
    "bulletinid" numeric(10),
    "type" char(1),
    "target" char(1),
    "notice_date" timestamp,
    "subject" varchar(250),
    "notice" text,
    "start_date" timestamp,
    "expiry_date" timestamp,
    "acknowledge" char(1),
    "filename" varchar(50),
    "filepath" varchar(250),
    "createby" varchar(13),
    "createdate" timestamp,
    "modifyby" varchar(13),
    "modifydate" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'bulletin_master');

\echo 'created foreign table fomema_backup_nios.bulletin_master';

drop foreign table if exists fomema_backup_nios.capability_master;

create foreign table if not exists fomema_backup_nios.capability_master (
    "capid" numeric(10),
    "description" varchar(100),
    "category" numeric(10),
    "status" varchar(5),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "longdesc" varchar(255)
) server fomema_backup options (schema_name 'nios', table_name 'capability_master');

\echo 'created foreign table fomema_backup_nios.capability_master';

drop foreign table if exists fomema_backup_nios.code_master;

create foreign table if not exists fomema_backup_nios.code_master (
    "req_type" varchar(2),
    "type_ind" varchar(1),
    "state_code" varchar(1),
    "name_first" varchar(1),
    "last_issue_no" numeric
) server fomema_backup options (schema_name 'nios', table_name 'code_master');

\echo 'created foreign table fomema_backup_nios.code_master';

drop foreign table if exists fomema_backup_nios.code_state_master;

create foreign table if not exists fomema_backup_nios.code_state_master (
    "state_code" varchar(7),
    "map_code" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'code_state_master');

\echo 'created foreign table fomema_backup_nios.code_state_master';

drop foreign table if exists fomema_backup_nios.condition_master;

create foreign table if not exists fomema_backup_nios.condition_master (
    "parameter_code" varchar(10),
    "description" varchar(240)
) server fomema_backup options (schema_name 'nios', table_name 'condition_master');

\echo 'created foreign table fomema_backup_nios.condition_master';

drop foreign table if exists fomema_backup_nios.country_master;

create foreign table if not exists fomema_backup_nios.country_master (
    "country_code" varchar(3),
    "country_name" varchar(50),
    "sequence" numeric(5)
) server fomema_backup options (schema_name 'nios', table_name 'country_master');

\echo 'created foreign table fomema_backup_nios.country_master';

drop foreign table if exists fomema_backup_nios.district_master;

create foreign table if not exists fomema_backup_nios.district_master (
    "district_code" varchar(7),
    "district_name" varchar(40),
    "country_code" varchar(3),
    "state_code" varchar(7)
) server fomema_backup options (schema_name 'nios', table_name 'district_master');

\echo 'created foreign table fomema_backup_nios.district_master';

drop foreign table if exists fomema_backup_nios.doctor_master;

create foreign table if not exists fomema_backup_nios.doctor_master (
    "doctor_code" varchar(10),
    "doctor_name" varchar(50),
    "clinic_name" varchar(100),
    "creation_date" timestamp,
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
    "phone" varchar(100),
    "fax" varchar(100),
    "state_code" varchar(7),
    "district_code" varchar(7),
    "country_code" varchar(3),
    "radiologist_code" varchar(10),
    "xray_code" varchar(10),
    "laboratory_code" varchar(10),
    "email_id" varchar(100),
    "xray_regn_no" varchar(20),
    "version_no" varchar(10),
    "own_xray_clinic" varchar(1),
    "qualification" varchar(50),
    "no_of_solo_clinics" varchar(2),
    "no_of_group_clinics" varchar(2),
    "status_code" varchar(5),
    "comments" varchar(4000),
    "numquarantine" numeric(4),
    "bc_doctor_code" varchar(13),
    "quota" numeric(10),
    "quota_use" numeric(5),
    "nearest_district_office" varchar(7),
    "creator_id" numeric(10),
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "isproblematic" varchar(2),
    "bc_radiologist_code" varchar(13),
    "bc_xray_code" varchar(13),
    "bc_laboratory_code" varchar(13),
    "prefer_xray_code" varchar(13),
    "prefer_xray_distance" varchar(10),
    "dregid" numeric(10),
    "gst_code" varchar(20),
    "gst_tax" numeric(126),
    "male_rate" numeric(126),
    "female_rate" numeric(126),
    "bank_account_no" varchar(20),
    "gst_type" numeric(10),
    "bank_code" varchar(8),
    "mystics_ic" numeric,
    "mobile_no" varchar(20),
    "renewal_date" timestamp,
    "fp_device" numeric(1),
    "device_install" numeric(1)
) server fomema_backup options (schema_name 'nios', table_name 'doctor_master');

\echo 'created foreign table fomema_backup_nios.doctor_master';

drop foreign table if exists fomema_backup_nios.doctor_parameter_master;

create foreign table if not exists fomema_backup_nios.doctor_parameter_master (
    "parameter_code" varchar(10),
    "description" varchar(50),
    "status" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'doctor_parameter_master');

\echo 'created foreign table fomema_backup_nios.doctor_parameter_master';

drop foreign table if exists fomema_backup_nios.draft_master;

create foreign table if not exists fomema_backup_nios.draft_master (
    "id" numeric(19),
    "version" numeric(19),
    "approval_code" varchar(80),
    "bank_area" varchar(400),
    "bank_code" varchar(32),
    "branch_code" varchar(8),
    "card_type" varchar(80),
    "collection_status" varchar(1020),
    "collection_uuid" varchar(1020),
    "comments" varchar(2000),
    "contact_address1" varchar(200),
    "contact_address2" varchar(200),
    "contact_address3" varchar(200),
    "contact_address4" varchar(200),
    "contact_district_code" varchar(28),
    "contact_fax" varchar(400),
    "contact_name" varchar(200),
    "contact_phone" varchar(400),
    "contact_post_code" varchar(28),
    "contact_state_code" varchar(28),
    "creation_date" timestamp,
    "creator_id" numeric(10),
    "date_issue" timestamp,
    "draft_type" numeric(10),
    "expiry_date" timestamp,
    "invoice_batch" numeric(10),
    "modification_date" timestamp,
    "modify_id" numeric(10),
    "name_on_card" varchar(400),
    "payment_amount" numeric(126),
    "payment_no" varchar(64),
    "payment_surcharge" numeric(126),
    "payment_type" numeric(10),
    "receipt_payment_no" varchar(64),
    "receipt_payment_type" numeric(10),
    "receipt_tranno" varchar(40),
    "ref_no" varchar(200),
    "replacement_draft_id" numeric(19),
    "status" numeric(10),
    "tranno" varchar(40),
    "transdate" timestamp,
    "voided_reason" varchar(1020),
    "zone_code" varchar(8),
    "source" numeric(10),
    "collection_cn_status" numeric,
    "collection_date" timestamp,
    "voided_date" timestamp,
    "gst_amount" numeric(126),
    "gst_percentage" numeric(126),
    "employer_alloc_master_id" numeric(19),
    "ap_invoice_no" varchar(255),
    "ap_group_id" numeric(19),
    "other_amount" numeric(126),
    "other_amount_gst" numeric(126),
    "process_fee" numeric(126)
) server fomema_backup options (schema_name 'nios', table_name 'draft_master');

\echo 'created foreign table fomema_backup_nios.draft_master';

drop foreign table if exists fomema_backup_nios.dxprovider_master;

create foreign table if not exists fomema_backup_nios.dxprovider_master (
    "provider_id" varchar(3),
    "provider_name" varchar(20),
    "passphrase" varchar(20),
    "provider_url" varchar(100)
) server fomema_backup options (schema_name 'nios', table_name 'dxprovider_master');

\echo 'created foreign table fomema_backup_nios.dxprovider_master';

drop foreign table if exists fomema_backup_nios.employer_alloc_master;

create foreign table if not exists fomema_backup_nios.employer_alloc_master (
    "id" numeric(19),
    "version" numeric(19),
    "approval_code" varchar(80),
    "bank_area" varchar(400),
    "bank_code" varchar(32),
    "branch_code" varchar(8),
    "card_type" varchar(80),
    "collection_status" varchar(1020),
    "collection_uuid" varchar(1020),
    "comments" varchar(2000),
    "contact_address1" varchar(200),
    "contact_address2" varchar(200),
    "contact_address3" varchar(200),
    "contact_address4" varchar(200),
    "contact_district_code" varchar(28),
    "contact_fax" varchar(400),
    "contact_name" varchar(200),
    "contact_phone" varchar(400),
    "contact_post_code" varchar(28),
    "contact_state_code" varchar(28),
    "creation_date" timestamp,
    "creator_id" numeric(10),
    "date_issue" timestamp,
    "draft_type" numeric(10),
    "expiry_date" timestamp,
    "gst_amount" numeric(126),
    "gst_percentage" numeric(126),
    "invoice_batch" numeric(10),
    "modification_date" timestamp,
    "modify_id" numeric(10),
    "name_on_card" varchar(400),
    "payment_amount" numeric(126),
    "payment_no" varchar(64),
    "payment_surcharge" numeric(126),
    "payment_type" numeric(10),
    "receipt_payment_no" varchar(64),
    "receipt_payment_type" numeric(10),
    "receipt_tranno" varchar(40),
    "ref_no" varchar(200),
    "replacement_draft_id" numeric(19),
    "source" numeric(10),
    "status" numeric(10),
    "tranno" varchar(40),
    "transdate" timestamp,
    "voided_date" timestamp,
    "voided_reason" varchar(1020),
    "zone_code" varchar(8)
) server fomema_backup options (schema_name 'nios', table_name 'employer_alloc_master');

\echo 'created foreign table fomema_backup_nios.employer_alloc_master';

drop foreign table if exists fomema_backup_nios.employer_master;

create foreign table if not exists fomema_backup_nios.employer_master (
    "employer_code" varchar(10),
    "employer_name" varchar(150),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "address4" varchar(50),
    "business_code" varchar(10),
    "country_code" varchar(3),
    "state_code" varchar(7),
    "district_code" varchar(7),
    "status_code" varchar(5),
    "creation_date" timestamp,
    "post_code" varchar(10),
    "phone" varchar(100),
    "fax" varchar(100),
    "email_id" varchar(100),
    "primary_contact_person" varchar(50),
    "primary_contact_phone" varchar(20),
    "doctor_code" varchar(10),
    "version_no" varchar(10),
    "comments" varchar(4000),
    "bc_employer_code" varchar(13),
    "creator_id" numeric(10),
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "branch_code" varchar(2),
    "isblacklisted" varchar(5),
    "blacklisted_date" timestamp,
    "bc_doctor_code" varchar(13),
    "classification" varchar(5),
    "company_regno" varchar(20),
    "icpassport_no" varchar(20),
    "badpayment_ind" numeric(1),
    "ap_group_id" numeric(19),
    "employer_account_type" numeric(1),
    "employer_type" numeric(1)
) server fomema_backup options (schema_name 'nios', table_name 'employer_master');

\echo 'created foreign table fomema_backup_nios.employer_master';

drop foreign table if exists fomema_backup_nios.fin_batch_master;

create foreign table if not exists fomema_backup_nios.fin_batch_master (
    "batch_number" numeric,
    "batch_startdate" timestamp,
    "batch_enddate" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fin_batch_master');

\echo 'created foreign table fomema_backup_nios.fin_batch_master';

drop foreign table if exists fomema_backup_nios.fom_module_master;

create foreign table if not exists fomema_backup_nios.fom_module_master (
    "mod_id" numeric,
    "parent_mod_id" numeric,
    "mod_desc" varchar(50),
    "description" varchar(250),
    "modified_date" timestamp,
    "created_date" timestamp,
    "sort_order" numeric,
    "isactive" numeric,
    "url" varchar(250)
) server fomema_backup options (schema_name 'nios', table_name 'fom_module_master');

\echo 'created foreign table fomema_backup_nios.fom_module_master';

drop foreign table if exists fomema_backup_nios.fom_user_master;

create foreign table if not exists fomema_backup_nios.fom_user_master (
    "uuid" numeric(10),
    "passwordcount" numeric,
    "attempdate" timestamp,
    "status" varchar(5),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fom_user_master');

\echo 'created foreign table fomema_backup_nios.fom_user_master';

drop foreign table if exists fomema_backup_nios.foreign_clinic_master;

create foreign table if not exists fomema_backup_nios.foreign_clinic_master (
    "clinic_code" varchar(10),
    "country_code" varchar(3),
    "region" varchar(50),
    "clinic_name" varchar(100),
    "address" varchar(255),
    "phone_no" varchar(50),
    "status_code" varchar(1),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'foreign_clinic_master');

\echo 'created foreign table fomema_backup_nios.foreign_clinic_master';

drop foreign table if exists fomema_backup_nios.foreign_worker_master_cancel;

create foreign table if not exists fomema_backup_nios.foreign_worker_master_cancel (
    "worker_code" varchar(10),
    "worker_name" varchar(50),
    "creation_date" timestamp,
    "fathers_name" varchar(50),
    "date_of_birth" timestamp,
    "passport_no" varchar(20),
    "visa_no" varchar(20),
    "sex" varchar(1),
    "job_type" varchar(50),
    "arrival_date" timestamp,
    "version_no" varchar(10),
    "blood_group" varchar(3),
    "country_code" varchar(3),
    "departure_date" timestamp,
    "last_examine_date" timestamp,
    "employer_pref_ind" varchar(1),
    "imm_name" varchar(50),
    "agent_code" varchar(10),
    "employer_code" varchar(10),
    "fit_ind" varchar(1),
    "fomema_ind" varchar(1),
    "renewal_date" timestamp,
    "bc_worker_code" varchar(13),
    "bc_agent_code" varchar(13),
    "bc_employer_code" varchar(13),
    "can_renew" varchar(5),
    "ismonitor" varchar(5),
    "isimmblock" varchar(5),
    "creator_id" numeric(10),
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "status_code" varchar(5),
    "ply_count" numeric(10),
    "ply_printed" varchar(5),
    "isblacklisted" varchar(5),
    "blacklisted_date" timestamp,
    "visa_expiry_date" timestamp,
    "rh" varchar(1),
    "classification" varchar(5),
    "clinic_code" varchar(10),
    "clinic_examdate" timestamp,
    "created_by" varchar(10),
    "immblocked_by" varchar(3),
    "pati" varchar(1),
    "cancel_by" numeric(10),
    "cancel_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'foreign_worker_master_cancel');

\echo 'created foreign table fomema_backup_nios.foreign_worker_master_cancel';

drop foreign table if exists fomema_backup_nios.foreign_worker_master_delete;

create foreign table if not exists fomema_backup_nios.foreign_worker_master_delete (
    "worker_code" varchar(10),
    "worker_name" varchar(50),
    "creation_date" timestamp,
    "fathers_name" varchar(50),
    "date_of_birth" timestamp,
    "passport_no" varchar(20),
    "visa_no" varchar(20),
    "sex" varchar(1),
    "job_type" varchar(50),
    "arrival_date" timestamp,
    "version_no" varchar(10),
    "blood_group" varchar(3),
    "country_code" varchar(3),
    "departure_date" timestamp,
    "last_examine_date" timestamp,
    "employer_pref_ind" varchar(1),
    "imm_name" varchar(50),
    "agent_code" varchar(10),
    "employer_code" varchar(10),
    "fit_ind" varchar(1),
    "fomema_ind" varchar(1),
    "renewal_date" timestamp,
    "bc_worker_code" varchar(13),
    "bc_agent_code" varchar(13),
    "bc_employer_code" varchar(13),
    "can_renew" varchar(5),
    "ismonitor" varchar(5),
    "isimmblock" varchar(5),
    "creator_id" numeric(10),
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "status_code" varchar(5),
    "ply_count" numeric(10),
    "ply_printed" varchar(5),
    "isblacklisted" varchar(5),
    "blacklisted_date" timestamp,
    "visa_expiry_date" timestamp,
    "rh" varchar(1),
    "classification" varchar(5),
    "clinic_code" varchar(10),
    "clinic_examdate" timestamp,
    "created_by" varchar(10),
    "del_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'foreign_worker_master_delete');

\echo 'created foreign table fomema_backup_nios.foreign_worker_master_delete';

drop foreign table if exists fomema_backup_nios.icon_master;

create foreign table if not exists fomema_backup_nios.icon_master (
    "iconid" numeric(10),
    "parenticonid" numeric(10),
    "isfolder" varchar(5),
    "icondesc" varchar(255),
    "capid" numeric(10),
    "identifier" numeric(10),
    "imagefile1" varchar(50),
    "imagefile2" varchar(50),
    "contextname" varchar(50),
    "indexpage" varchar(50),
    "parameter" varchar(200),
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'icon_master');

\echo 'created foreign table fomema_backup_nios.icon_master';

drop foreign table if exists fomema_backup_nios.ind_master;

create foreign table if not exists fomema_backup_nios.ind_master (
    "ind" varchar(1),
    "req_type" varchar(2)
) server fomema_backup options (schema_name 'nios', table_name 'ind_master');

\echo 'created foreign table fomema_backup_nios.ind_master';

drop foreign table if exists fomema_backup_nios.invoice_master;

create foreign table if not exists fomema_backup_nios.invoice_master (
    "invoice_no" varchar(20),
    "service_provider_code" varchar(10),
    "status" char(1),
    "bill_amount" numeric(10, 2),
    "gst_amount" numeric(10, 2),
    "invoice_amount" numeric(10, 2),
    "invoice_rounding_amount" numeric(10, 2),
    "group_invoice" char(1),
    "service_providers_group_id" numeric,
    "male_rate" numeric(126),
    "female_rate" numeric(126),
    "gst_code" varchar(20),
    "gst_tax" numeric(126),
    "gst_type" numeric(10),
    "creator_id" varchar(20),
    "creation_date" timestamp,
    "modify_id" varchar(20),
    "modification_date" timestamp,
    "batch_number" numeric
) server fomema_backup options (schema_name 'nios', table_name 'invoice_master');

\echo 'created foreign table fomema_backup_nios.invoice_master';

drop foreign table if exists fomema_backup_nios.jobtype_master;

create foreign table if not exists fomema_backup_nios.jobtype_master (
    "job_type" varchar(40),
    "description" varchar(255),
    "status_code" varchar(5)
) server fomema_backup options (schema_name 'nios', table_name 'jobtype_master');

\echo 'created foreign table fomema_backup_nios.jobtype_master';

drop foreign table if exists fomema_backup_nios.laboratory_master;

create foreign table if not exists fomema_backup_nios.laboratory_master (
    "laboratory_code" varchar(10),
    "laboratory_name" varchar(50),
    "creation_date" timestamp,
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
    "version_no" varchar(10),
    "qualification" varchar(50),
    "status_code" varchar(5),
    "comments" varchar(4000),
    "bc_laboratory_code" varchar(13),
    "nearest_district_office" varchar(7),
    "classification" varchar(5),
    "creator_id" numeric(10),
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "lab_group" varchar(2),
    "grade_point" numeric(3),
    "license" varchar(20),
    "license_year" varchar(4),
    "lregid" numeric(10),
    "web_service_access" char(1),
    "passphrase" varchar(100),
    "gst_code" varchar(20),
    "gst_tax" numeric(126),
    "male_rate" numeric(126),
    "female_rate" numeric(126),
    "bank_account_no" varchar(20),
    "gst_type" numeric(10),
    "bank_code" varchar(8),
    "laboratory_logo" varchar(50),
    "web_taxinvoice" numeric(1),
    "mobile_no" varchar(20),
    "renewal_date" timestamp,
    "gst_effective_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'laboratory_master');

\echo 'created foreign table fomema_backup_nios.laboratory_master';

drop foreign table if exists fomema_backup_nios.lab_rates_master;

create foreign table if not exists fomema_backup_nios.lab_rates_master (
    "lab_code" varchar(10),
    "male" numeric(6, 2),
    "female" numeric(6, 2)
) server fomema_backup options (schema_name 'nios', table_name 'lab_rates_master');

\echo 'created foreign table fomema_backup_nios.lab_rates_master';

drop foreign table if exists fomema_backup_nios.module_master;

create foreign table if not exists fomema_backup_nios.module_master (
    "moduleid" numeric(10),
    "modulename" varchar(50),
    "description" varchar(255),
    "capid" numeric(10),
    "status" varchar(5),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'module_master');

\echo 'created foreign table fomema_backup_nios.module_master';

drop foreign table if exists fomema_backup_nios.moh_master_quota;

create foreign table if not exists fomema_backup_nios.moh_master_quota (
    "quota_type" varchar(20),
    "apply_to" varchar(10),
    "quota" numeric,
    "comments" varchar(255)
) server fomema_backup options (schema_name 'nios', table_name 'moh_master_quota');

\echo 'created foreign table fomema_backup_nios.moh_master_quota';

drop foreign table if exists fomema_backup_nios.myimms_country_master;

create foreign table if not exists fomema_backup_nios.myimms_country_master (
    "nios_country_code" varchar(3),
    "myimms_country_code" varchar(3),
    "country_name" varchar(100)
) server fomema_backup options (schema_name 'nios', table_name 'myimms_country_master');

\echo 'created foreign table fomema_backup_nios.myimms_country_master';

drop foreign table if exists fomema_backup_nios.post_master;

create foreign table if not exists fomema_backup_nios.post_master (
    "district" varchar(100),
    "post_code" varchar(6),
    "post_office" varchar(100),
    "state" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 'post_master');

\echo 'created foreign table fomema_backup_nios.post_master';

drop foreign table if exists fomema_backup_nios.radiographer_master;

create foreign table if not exists fomema_backup_nios.radiographer_master (
    "radiographer_id" numeric(10),
    "radiographer_name" varchar(50),
    "status" varchar(1),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modification_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'radiographer_master');

\echo 'created foreign table fomema_backup_nios.radiographer_master';

drop foreign table if exists fomema_backup_nios.radiologist_master;

create foreign table if not exists fomema_backup_nios.radiologist_master (
    "radiologist_code" varchar(10),
    "radiologist_name" varchar(50),
    "creation_date" timestamp,
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
    "version_no" varchar(10),
    "qualification" varchar(50),
    "xray_regn_no" varchar(20),
    "status_code" varchar(5),
    "comments" varchar(4000),
    "bc_radiologist_code" varchar(13),
    "creator_id" numeric(10),
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "rdregid" numeric(10),
    "nearest_district_office" varchar(7),
    "radiologist_ic_new" varchar(20),
    "radiologist_ic_old" varchar(20),
    "is_pcr" char(1),
    "apc_year" varchar(4),
    "nios_uuid" numeric,
    "apc_no" varchar(20),
    "nsr_no" varchar(20),
    "xray_name" varchar(50),
    "gst_code" varchar(20),
    "gst_tax" numeric(126),
    "male_rate" numeric(126),
    "female_rate" numeric(126),
    "bank_account_no" varchar(20),
    "gst_type" numeric(10),
    "bank_code" varchar(8),
    "mobile_no" varchar(20),
    "renewal_date" timestamp,
    "quota" numeric(10),
    "quota_use" numeric(10)
) server fomema_backup options (schema_name 'nios', table_name 'radiologist_master');

\echo 'created foreign table fomema_backup_nios.radiologist_master';

drop foreign table if exists fomema_backup_nios.report_group_master;

create foreign table if not exists fomema_backup_nios.report_group_master (
    "groupid" numeric(10),
    "iconid" numeric(10),
    "description" varchar(50),
    "seq" numeric(10),
    "status" char(1),
    "width" numeric(5)
) server fomema_backup options (schema_name 'nios', table_name 'report_group_master');

\echo 'created foreign table fomema_backup_nios.report_group_master';

drop foreign table if exists fomema_backup_nios.role_master;

create foreign table if not exists fomema_backup_nios.role_master (
    "roleid" numeric(10),
    "description" varchar(100),
    "status" varchar(5),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'role_master');

\echo 'created foreign table fomema_backup_nios.role_master';

drop foreign table if exists fomema_backup_nios.scb_pay_master;

create foreign table if not exists fomema_backup_nios.scb_pay_master (
    "worker_code" varchar(10),
    "doctor_code" varchar(10),
    "date_reg_rev" timestamp,
    "name" varchar(50),
    "entry_date" timestamp,
    "amount" numeric(6),
    "amt_ded" numeric(3),
    "xray_clinic_code" varchar(10),
    "xray_amount" numeric(6),
    "doc_payblock_ind" varchar(1),
    "xray_payblock_ind" varchar(1),
    "doc_payblock_date" timestamp,
    "doc_unblock_date" timestamp,
    "xray_payblock_date" timestamp,
    "xray_unblock_date" timestamp,
    "xray_ded" numeric(3)
) server fomema_backup options (schema_name 'nios', table_name 'scb_pay_master');

\echo 'created foreign table fomema_backup_nios.scb_pay_master';

drop foreign table if exists fomema_backup_nios.scb_pay_master_upload;

create foreign table if not exists fomema_backup_nios.scb_pay_master_upload (
    "worker_code" varchar(10),
    "doctor_code" varchar(10),
    "date_reg_rev" timestamp,
    "name" varchar(50),
    "entry_date" timestamp,
    "amount" numeric(6),
    "amt_ded" numeric(3),
    "xray_clinic_code" varchar(10),
    "xray_amount" numeric(6),
    "doc_payblock_ind" varchar(1),
    "xray_payblock_ind" varchar(1),
    "doc_payblock_date" timestamp,
    "doc_unblock_date" timestamp,
    "xray_payblock_date" timestamp,
    "xray_unblock_date" timestamp,
    "xray_ded" numeric(3)
) server fomema_backup options (schema_name 'nios', table_name 'scb_pay_master_upload');

\echo 'created foreign table fomema_backup_nios.scb_pay_master_upload';

drop foreign table if exists fomema_backup_nios.sequence_master;

create foreign table if not exists fomema_backup_nios.sequence_master (
    "sequencename" varchar(30),
    "lastvalue" numeric(28),
    "description" varchar(100),
    "moduleid" varchar(50),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'sequence_master');

\echo 'created foreign table fomema_backup_nios.sequence_master';

drop foreign table if exists fomema_backup_nios.service_providers_bank_master;

create foreign table if not exists fomema_backup_nios.service_providers_bank_master (
    "bank_code" varchar(8),
    "bank_name" varchar(100),
    "isactive" char(1),
    "swift_code" varchar(20)
) server fomema_backup options (schema_name 'nios', table_name 'service_providers_bank_master');

\echo 'created foreign table fomema_backup_nios.service_providers_bank_master';

drop foreign table if exists fomema_backup_nios.state_master;

create foreign table if not exists fomema_backup_nios.state_master (
    "state_code" varchar(7),
    "state_name" varchar(15),
    "state_longname" varchar(30)
) server fomema_backup options (schema_name 'nios', table_name 'state_master');

\echo 'created foreign table fomema_backup_nios.state_master';

drop foreign table if exists fomema_backup_nios.state_master_rpt;

create foreign table if not exists fomema_backup_nios.state_master_rpt (
    "state_code" varchar(7),
    "state_name" varchar(15),
    "state_ref" varchar(3)
) server fomema_backup options (schema_name 'nios', table_name 'state_master_rpt');

\echo 'created foreign table fomema_backup_nios.state_master_rpt';

drop foreign table if exists fomema_backup_nios.state_post_master;

create foreign table if not exists fomema_backup_nios.state_post_master (
    "state_code" varchar(7),
    "post_code" varchar(2)
) server fomema_backup options (schema_name 'nios', table_name 'state_post_master');

\echo 'created foreign table fomema_backup_nios.state_post_master';

drop foreign table if exists fomema_backup_nios.um_module_master;

create foreign table if not exists fomema_backup_nios.um_module_master (
    "mod_id" numeric,
    "parent_mod_id" numeric,
    "mod_desc" varchar(50),
    "description" varchar(250),
    "modified_date" timestamp,
    "created_date" timestamp,
    "sort_order" numeric,
    "isactive" numeric,
    "url" varchar(250)
) server fomema_backup options (schema_name 'nios', table_name 'um_module_master');

\echo 'created foreign table fomema_backup_nios.um_module_master';

drop foreign table if exists fomema_backup_nios.um_user_master;

create foreign table if not exists fomema_backup_nios.um_user_master (
    "uuid" numeric(10),
    "passwordcount" numeric,
    "attempdate" timestamp,
    "status" varchar(5),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'um_user_master');

\echo 'created foreign table fomema_backup_nios.um_user_master';

drop foreign table if exists fomema_backup_nios.usercap_master;

create foreign table if not exists fomema_backup_nios.usercap_master (
    "cap_id" varchar(10),
    "description" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 'usercap_master');

\echo 'created foreign table fomema_backup_nios.usercap_master';

drop foreign table if exists fomema_backup_nios.usermaster;

create foreign table if not exists fomema_backup_nios.usermaster (
    "userid" varchar(10),
    "fullname" varchar(50),
    "cap_id" varchar(10),
    "password" varchar(20)
) server fomema_backup options (schema_name 'nios', table_name 'usermaster');

\echo 'created foreign table fomema_backup_nios.usermaster';

drop foreign table if exists fomema_backup_nios.visit_plan_master;

create foreign table if not exists fomema_backup_nios.visit_plan_master (
    "plan_id" numeric,
    "plan_status" char(1),
    "category" char(1),
    "creator_id" varchar(20),
    "creation_date" timestamp,
    "modify_id" varchar(20),
    "modify_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'visit_plan_master');

\echo 'created foreign table fomema_backup_nios.visit_plan_master';

drop foreign table if exists fomema_backup_nios.visit_rpt_labmaster;

create foreign table if not exists fomema_backup_nios.visit_rpt_labmaster (
    "laboratory_code" varchar(10),
    "visit_date" timestamp,
    "visit_type" varchar(30),
    "start_time" timestamp,
    "end_time" timestamp,
    "lab_category" varchar(30),
    "cov_districtcode" varchar(500),
    "attd_lab_personnel" varchar(500),
    "staff_pathologist" varchar(500),
    "staff_degholder_cnt" numeric,
    "staff_dipholder_cnt" numeric,
    "staff_technician_cnt" numeric,
    "staff_despatch_cnt" numeric,
    "staff_others_cnt" numeric,
    "staffing" varchar(1000),
    "report_id" numeric,
    "creator_id" varchar(20),
    "creation_date" timestamp,
    "modify_id" varchar(20),
    "modify_date" timestamp,
    "moh_representative" varchar(50),
    "report_submit_date" timestamp,
    "insp_others" varchar(50),
    "insp_team" varchar(500),
    "nontechnical_degree_cnt" numeric,
    "nontechnical_diploma_cnt" numeric,
    "nontechnical_cert_cnt" numeric,
    "technical_degree_cnt" numeric,
    "technical_diploma_cnt" numeric,
    "technical_cert_cnt" numeric,
    "despatch_degree_cnt" numeric,
    "despatch_diploma_cnt" numeric,
    "despatch_cert_cnt" numeric,
    "others_degree_cnt" numeric,
    "others_diploma_cnt" numeric,
    "others_cert_cnt" numeric,
    "referral_lab" varchar(4000)
) server fomema_backup options (schema_name 'nios', table_name 'visit_rpt_labmaster');

\echo 'created foreign table fomema_backup_nios.visit_rpt_labmaster';

drop foreign table if exists fomema_backup_nios.v_appeal_master;

create foreign table if not exists fomema_backup_nios.v_appeal_master (
    "worker_code" varchar(10),
    "name" varchar(50),
    "passport_nbr" varchar(10),
    "employer_state" varchar(15),
    "certify_date" varchar(19),
    "officer" varchar(20),
    "appeal_ind" varchar(15),
    "comments" varchar(100),
    "create_date" varchar(19),
    "trans_id" varchar(14)
) server fomema_backup options (schema_name 'nios', table_name 'v_appeal_master');

\echo 'created foreign table fomema_backup_nios.v_appeal_master';

drop foreign table if exists fomema_backup_nios.v_foreign_worker_master;

create foreign table if not exists fomema_backup_nios.v_foreign_worker_master (
    "worker_code" varchar(10),
    "worker_name" varchar(50),
    "creation_date" timestamp,
    "fathers_name" varchar(50),
    "date_of_birth" timestamp,
    "passport_no" varchar(20),
    "visa_no" varchar(20),
    "sex" varchar(1),
    "job_type" varchar(50),
    "arrival_date" timestamp,
    "version_no" varchar(10),
    "blood_group" varchar(3),
    "country_code" varchar(3),
    "departure_date" timestamp,
    "last_examine_date" timestamp,
    "employer_pref_ind" varchar(1),
    "imm_name" varchar(50),
    "agent_code" varchar(10),
    "employer_code" varchar(10),
    "fit_ind" varchar(1),
    "fomema_ind" varchar(1),
    "renewal_date" timestamp,
    "bc_worker_code" varchar(13),
    "bc_agent_code" varchar(13),
    "bc_employer_code" varchar(13),
    "can_renew" varchar(5),
    "ismonitor" varchar(5),
    "isimmblock" varchar(5),
    "creator_id" numeric(10),
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "status_code" varchar(5),
    "ply_count" numeric(10),
    "ply_printed" varchar(5),
    "isblacklisted" varchar(5),
    "blacklisted_date" timestamp,
    "visa_expiry_date" timestamp,
    "rh" varchar(1),
    "classification" varchar(5),
    "clinic_code" varchar(10),
    "clinic_examdate" timestamp,
    "created_by" varchar(10),
    "immblocked_by" varchar(3),
    "pati" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'v_foreign_worker_master');

\echo 'created foreign table fomema_backup_nios.v_foreign_worker_master';

drop foreign table if exists fomema_backup_nios.v_user_master;

create foreign table if not exists fomema_backup_nios.v_user_master (
    "uuid" numeric(10),
    "userid" varchar(20),
    "empid" varchar(20),
    "password" varchar(100),
    "passwordcount" numeric,
    "attempdate" timestamp,
    "displayname" varchar(100),
    "gender" varchar(1),
    "status" varchar(5),
    "email_id" varchar(100),
    "employmentdate" timestamp,
    "designation" varchar(50),
    "usertype" varchar(5),
    "roleid" numeric(10),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "branch_code" varchar(2)
) server fomema_backup options (schema_name 'nios', table_name 'v_user_master');

\echo 'created foreign table fomema_backup_nios.v_user_master';

drop foreign table if exists fomema_backup_nios.xray_master;

create foreign table if not exists fomema_backup_nios.xray_master (
    "xray_code" varchar(10),
    "xray_name" varchar(50),
    "creation_date" timestamp,
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
    "version_no" varchar(10),
    "qualification" varchar(50),
    "status_code" varchar(5),
    "comments" varchar(4000),
    "bc_xray_code" varchar(13),
    "classification" varchar(5),
    "creator_id" numeric(10),
    "modify_id" numeric(10),
    "modification_date" timestamp,
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
    "radiooperated" varchar(1),
    "radiologist_name" varchar(50),
    "apc_year" varchar(4),
    "apc_no" varchar(20),
    "gst_code" varchar(20),
    "gst_tax" numeric(126),
    "male_rate" numeric(126),
    "female_rate" numeric(126),
    "bank_account_no" varchar(20),
    "gst_type" numeric(10),
    "bank_code" varchar(8),
    "mystics_ic" numeric,
    "digital_image" numeric(1),
    "mobile_no" varchar(20),
    "renewal_date" timestamp,
    "fp_device" numeric(1),
    "seminar_attendees" varchar(1),
    "device_install" numeric(1)
) server fomema_backup options (schema_name 'nios', table_name 'xray_master');

\echo 'created foreign table fomema_backup_nios.xray_master';

drop foreign table if exists fomema_backup_nios.zone_master;

create foreign table if not exists fomema_backup_nios.zone_master (
    "zone_code" varchar(2),
    "zone_name" varchar(30),
    "clearing_days" numeric(3),
    "interest_charge" numeric(10, 2),
    "minimum_charge" numeric(10, 2),
    "group_id" varchar(2),
    "state_code" varchar(7),
    "district_code" varchar(7)
) server fomema_backup options (schema_name 'nios', table_name 'zone_master');

\echo 'created foreign table fomema_backup_nios.zone_master';
