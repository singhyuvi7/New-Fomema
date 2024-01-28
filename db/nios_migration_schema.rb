# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "oracle_fdw"
  enable_extension "plpgsql"

  create_table "account_concile", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "amount_expect", precision: 14, scale: 2
    t.decimal "amount_return", precision: 14, scale: 2
    t.datetime "creation_date"
    t.string "description", limit: 4000
    t.string "description2", limit: 4000
    t.decimal "isread", precision: 10
    t.datetime "process_date"
    t.string "process_id", limit: 1020
    t.decimal "reference_id", precision: 10
    t.decimal "type", precision: 10
  end

  create_table "account_reference", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.string "draft_master_id", limit: 76
    t.string "payment_no", limit: 64
    t.decimal "payment_type", precision: 10
    t.decimal "reference_source", precision: 10
    t.string "tranno", limit: 40
    t.string "payment_refund_id", limit: 76
  end

  create_table "account_setting", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.datetime "create_date"
    t.decimal "creator_id", precision: 10
    t.string "parameter", limit: 120
    t.string "value", limit: 50
    t.string "description", limit: 400
  end

  create_table "adminusers", id: false, force: :cascade do |t|
    t.string "usercode", limit: 13
    t.string "username", limit: 50
    t.string "userpass", limit: 100
    t.datetime "lastlogindate"
  end

  create_table "advance_payment", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "amount", precision: 126
    t.decimal "ap_group_id", precision: 19
    t.string "bank_area", limit: 1020
    t.string "bank_code", limit: 1020
    t.string "contact_address1", limit: 200
    t.string "contact_address2", limit: 200
    t.string "contact_address3", limit: 200
    t.string "contact_address4", limit: 200
    t.string "contact_district_code", limit: 28
    t.string "contact_fax", limit: 400
    t.string "contact_name", limit: 200
    t.string "contact_phone", limit: 400
    t.string "contact_post_code", limit: 40
    t.string "contact_state_code", limit: 28
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.datetime "date_issue"
    t.datetime "modification_date"
    t.decimal "modify_id", precision: 10
    t.string "payment_no", limit: 1020
    t.decimal "payment_type", precision: 10
    t.string "status", limit: 4
    t.string "zone_code", limit: 1020
    t.string "branch_code", limit: 8
    t.datetime "voided_date"
  end

  create_table "advance_payment_account", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "amount", precision: 126
    t.decimal "ap_id", precision: 19
    t.decimal "ap_group_id", precision: 19
    t.string "branch_code", limit: 8
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.string "description", limit: 4000
    t.decimal "draft_id", precision: 19
    t.string "employer_code", limit: 40
    t.decimal "gst_amount", precision: 126
    t.datetime "modification_date"
    t.decimal "modify_id", precision: 10
    t.decimal "type", precision: 10
    t.decimal "refund_id", precision: 19
  end

  create_table "advance_payment_approval", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.string "approve_status", limit: 1020
    t.string "comments", limit: 1600
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.datetime "modification_date"
    t.decimal "modify_id", precision: 10
    t.decimal "approval_id", precision: 10
    t.decimal "ap_id", precision: 19
  end

  create_table "advance_payment_group", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.string "address1", limit: 1020
    t.string "address2", limit: 1020
    t.string "address3", limit: 1020
    t.string "address4", limit: 1020
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.string "district_code", limit: 28
    t.string "email_address", limit: 400
    t.string "fax", limit: 1020
    t.string "group_code", limit: 40
    t.string "group_name", limit: 200
    t.string "isactive", limit: 1020
    t.datetime "modification_date"
    t.decimal "modify_id", precision: 10
    t.string "phone", limit: 1020
    t.string "postcode", limit: 1020
    t.string "roc", limit: 80
    t.string "state_code", limit: 28
  end

  create_table "agent_history", id: false, force: :cascade do |t|
    t.string "agent_code", limit: 10
    t.string "bc_agent_code", limit: 13
    t.string "agent_name", limit: 50
    t.string "agency_licence_no", limit: 10
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 25
    t.string "fax", limit: 25
    t.string "email_id", limit: 100
    t.string "district_code", limit: 7
    t.string "state_code", limit: 7
    t.string "country_code", limit: 3
    t.string "primary_contact_person", limit: 50
    t.string "primary_contact_phone_no", limit: 20
    t.string "version_no", limit: 10
    t.string "comments", limit: 40
    t.string "district_name", limit: 40
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "status_code", limit: 5
    t.string "branch_code", limit: 2
    t.string "action", limit: 10
    t.datetime "action_date"
    t.index ["agent_code"], name: "idx_agent_history_on_agent_code"
    t.index ["bc_agent_code"], name: "idx_agent_history_on_bc_agent_code"
    t.index ["branch_code"], name: "idx_agent_history_on_branch_code"
    t.index ["country_code"], name: "idx_agent_history_on_country_code"
    t.index ["district_code"], name: "idx_agent_history_on_district_code"
    t.index ["post_code"], name: "idx_agent_history_on_post_code"
    t.index ["state_code"], name: "idx_agent_history_on_state_code"
    t.index ["status_code"], name: "idx_agent_history_on_status_code"
  end

  create_table "agent_master", id: false, force: :cascade do |t|
    t.string "agent_code", limit: 10
    t.string "agent_name", limit: 50
    t.string "agency_licence_no", limit: 10
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 100
    t.string "fax", limit: 100
    t.string "email_id", limit: 100
    t.string "district_code", limit: 7
    t.string "state_code", limit: 7
    t.string "country_code", limit: 3
    t.string "primary_contact_person", limit: 50
    t.string "primary_contact_phone_no", limit: 20
    t.string "version_no", limit: 10
    t.datetime "creation_date"
    t.string "comments", limit: 4000
    t.string "bc_agent_code", limit: 13
    t.string "branch_code", limit: 2
    t.string "status_code", limit: 5
    t.decimal "creator_id", precision: 10
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.index ["agent_code"], name: "idx_agent_master_on_agent_code"
    t.index ["bc_agent_code"], name: "idx_agent_master_on_bc_agent_code"
    t.index ["branch_code"], name: "idx_agent_master_on_branch_code"
    t.index ["country_code"], name: "idx_agent_master_on_country_code"
    t.index ["district_code"], name: "idx_agent_master_on_district_code"
    t.index ["post_code"], name: "idx_agent_master_on_post_code"
    t.index ["state_code"], name: "idx_agent_master_on_state_code"
    t.index ["status_code"], name: "idx_agent_master_on_status_code"
  end

  create_table "announcement", id: false, force: :cascade do |t|
    t.decimal "id"
    t.datetime "creation_date"
    t.string "subject", limit: 200
    t.datetime "start_date"
    t.datetime "end_date"
    t.text "content"
    t.decimal "status", precision: 1
  end

  create_table "ap_invoice_generated", id: false, force: :cascade do |t|
    t.string "creditor_code", limit: 10
    t.string "trans_id", limit: 14
    t.datetime "created_date"
    t.string "filename", limit: 100
    t.string "type", limit: 2
    t.index ["trans_id"], name: "idx_ap_invoice_generated_on_trans_id"
  end

  create_table "app_audit", id: false, force: :cascade do |t|
    t.datetime "audit_date"
    t.string "userid", limit: 30
    t.string "module_id", limit: 30
    t.string "audit_details"
  end

  create_table "app_module", id: false, force: :cascade do |t|
    t.string "module_id", limit: 30
    t.string "description", limit: 80
  end

  create_table "appeal_fw_appeal", id: false, force: :cascade do |t|
    t.decimal "appealid", precision: 10
    t.string "trans_id", limit: 14
    t.string "bc_worker_code", limit: 13
    t.string "appeal_doctor_code", limit: 13
    t.datetime "letter_apointment_date"
    t.datetime "result_date"
    t.datetime "idemnity_date"
    t.datetime "letter_notification"
    t.string "comments", limit: 4000
    t.string "follow_up", limit: 13
    t.string "status", limit: 5
    t.string "appeal_success", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.string "phase_status", limit: 2
    t.string "blood_group", limit: 3
    t.string "rh", limit: 1
    t.string "appeal_close_comments", limit: 4000
    t.string "officer_incharge", limit: 50
    t.string "iscancelled", limit: 1
    t.string "appeal_type", limit: 3
    t.index ["trans_id"], name: "idx_appeal_fw_appeal_on_trans_id"
  end

  create_table "appeal_fw_appeal_appro_his", id: false, force: :cascade do |t|
    t.decimal "appealappid", precision: 10
    t.decimal "appealid", precision: 10
    t.decimal "req_userid", precision: 10
    t.datetime "req_date"
    t.string "req_comments", limit: 4000
    t.decimal "approval_userid", precision: 10
    t.datetime "approval_date"
    t.string "approval_comments", limit: 4000
    t.string "status", limit: 1
    t.string "appeal_result", limit: 1
    t.string "action", limit: 10
    t.datetime "action_date"
  end

  create_table "appeal_fw_appeal_approval", id: false, force: :cascade do |t|
    t.decimal "appealappid", precision: 10
    t.decimal "appealid", precision: 10
    t.decimal "req_userid", precision: 10
    t.datetime "req_date"
    t.string "req_comments", limit: 4000
    t.decimal "approval_userid", precision: 10
    t.datetime "approval_date"
    t.string "approval_comments", limit: 4000
    t.string "status", limit: 1
    t.string "appeal_result", limit: 1
  end

  create_table "appeal_master", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "name", limit: 50
    t.string "passport_nbr", limit: 10
    t.string "employer_state", limit: 15
    t.datetime "certify_date"
    t.string "officer", limit: 20
    t.string "appeal_ind", limit: 15
    t.string "comments", limit: 100
    t.datetime "create_date"
    t.string "trans_id", limit: 14
    t.index ["trans_id"], name: "idx_appeal_master_on_trans_id"
  end

  create_table "appeal_payment", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "lab_code", limit: 10
    t.decimal "lab_amt", precision: 6, scale: 2
    t.string "lab_inform", limit: 1
    t.string "lab_cond", limit: 10
    t.datetime "date_reg"
    t.string "reg_by", limit: 15
  end

  create_table "appeal_status", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "name", limit: 50
    t.string "passport_nbr", limit: 10
    t.string "employer_state", limit: 15
    t.datetime "certify_date"
    t.datetime "successful_date"
    t.datetime "unsuccessful_date"
    t.datetime "followup_date"
    t.string "case", limit: 15
    t.string "followup_ind", limit: 1
    t.string "appeal_ind", limit: 1
    t.string "comments", limit: 100
    t.datetime "decision_date"
    t.string "trans_id", limit: 14
    t.index ["trans_id"], name: "idx_appeal_status_on_trans_id"
  end

  create_table "appeal_todolist", id: false, force: :cascade do |t|
    t.decimal "todoid", precision: 10
    t.string "remark", limit: 500
    t.string "url", limit: 500
  end

  create_table "appeal_todolist_map", id: false, force: :cascade do |t|
    t.string "parameter_code", limit: 10
    t.decimal "todoid", precision: 10
    t.string "can_appeal", limit: 1
  end

  create_table "arch_fw_comment", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "parameter_code", limit: 10
    t.string "comments", limit: 1000
    t.index ["trans_id"], name: "idx_arch_fw_comment_on_trans_id"
  end

  create_table "arch_fw_detail", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "parameter_code", limit: 10
    t.string "med_history", limit: 5
    t.datetime "effected_date"
    t.string "parameter_value", limit: 20
    t.index ["trans_id"], name: "idx_arch_fw_detail_on_trans_id"
  end

  create_table "arch_fw_extra_comments", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.datetime "comment_date"
    t.string "comment_time", limit: 8
    t.string "userid", limit: 30
    t.text "comments"
    t.index ["trans_id"], name: "idx_arch_fw_extra_comments_on_trans_id"
  end

  create_table "arch_fw_quarantine_reason", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "reason_code", limit: 10
    t.index ["trans_id"], name: "idx_arch_fw_quarantine_reason_on_trans_id"
  end

  create_table "arch_fw_transaction", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "doctor_code", limit: 10
    t.string "employer_code", limit: 10
    t.string "laboratory_code", limit: 10
    t.string "radiologist_code", limit: 10
    t.string "xray_code", limit: 10
    t.string "worker_code", limit: 10
    t.datetime "transdate"
    t.string "org_bit", limit: 1
    t.datetime "certify_date"
    t.datetime "exam_date"
    t.datetime "lab_submit_date"
    t.datetime "xray_submit_date"
    t.string "height", limit: 6
    t.string "weight", limit: 6
    t.string "pulse", limit: 6
    t.string "systolic", limit: 6
    t.string "diastolic", limit: 6
    t.string "bld_grp", limit: 2
    t.string "rh", limit: 1
    t.string "fit_ind", limit: 1
    t.string "imm_ind", limit: 1
    t.string "renew_ind", limit: 1
    t.string "qrtn_ind", limit: 1
    t.string "imm_send_ind", limit: 1
    t.string "lab_notdone_ind", limit: 1
    t.string "xray_notdone_ind", limit: 1
    t.datetime "release_date"
    t.string "invalidate_result", limit: 1
    t.datetime "invalidate_date"
    t.datetime "imm_send_date"
    t.string "user_id", limit: 30
    t.string "bc_doctor_code", limit: 13
    t.string "bc_employer_code", limit: 13
    t.string "bc_laboratory_code", limit: 13
    t.string "bc_radiologist_code", limit: 13
    t.string "bc_xray_code", limit: 13
    t.string "bc_worker_code", limit: 13
    t.string "version_no", limit: 10
    t.datetime "xray_testdone_date"
    t.string "taken_drugs", limit: 1
    t.string "tcupi_ind", limit: 1
    t.datetime "lab_specimen_date"
    t.datetime "last_pms_date"
    t.string "worker_consent", limit: 1
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "irr_ind", limit: 1
    t.string "imr_ind", limit: 1
    t.decimal "med_ind"
    t.decimal "reg_ind"
    t.index ["trans_id"], name: "idx_arch_fw_transaction_on_trans_id"
  end

  create_table "bad_payment", id: false, force: :cascade do |t|
    t.decimal "paymentid", precision: 10
    t.string "bank_code", limit: 8
    t.string "bank_branch", limit: 100
    t.string "document_no", limit: 50
    t.datetime "document_date"
    t.string "contact_name", limit: 50
    t.string "contact_phone", limit: 25
    t.string "contact_fax", limit: 25
    t.string "contact_address1", limit: 50
    t.string "contact_address2", limit: 50
    t.string "contact_address3", limit: 50
    t.string "contact_address4", limit: 50
    t.string "contact_post_code", limit: 10
    t.string "contact_state_code", limit: 7
    t.string "contact_district_code", limit: 7
    t.decimal "amount", precision: 10, scale: 2
    t.string "comments", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "version_no", limit: 10
  end

  create_table "bad_payment_history", id: false, force: :cascade do |t|
    t.decimal "paymentid", precision: 10
    t.string "bank_code", limit: 8
    t.string "bank_branch", limit: 100
    t.string "document_no", limit: 50
    t.datetime "document_date"
    t.string "contact_name", limit: 50
    t.string "contact_phone", limit: 25
    t.string "contact_fax", limit: 25
    t.string "contact_address1", limit: 50
    t.string "contact_address2", limit: 50
    t.string "contact_address3", limit: 50
    t.string "contact_address4", limit: 50
    t.string "contact_post_code", limit: 10
    t.string "contact_state_code", limit: 7
    t.string "contact_district_code", limit: 7
    t.decimal "amount", precision: 10, scale: 2
    t.string "status", limit: 5
    t.string "comments", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "version_no", limit: 10
    t.string "action", limit: 10
    t.datetime "action_date"
    t.index ["bank_code"], name: "idx_bad_payment_history_on_bank_code"
    t.index ["contact_district_code"], name: "idx_bad_payment_history_on_contact_district_code"
    t.index ["contact_post_code"], name: "idx_bad_payment_history_on_contact_post_code"
    t.index ["contact_state_code"], name: "idx_bad_payment_history_on_contact_state_code"
  end

  create_table "bad_payment_removal_comments", id: false, force: :cascade do |t|
    t.decimal "paymentid", precision: 10
    t.string "removal_comments", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
  end

  create_table "bank_draft_expiry", id: false, force: :cascade do |t|
    t.string "bank_code", limit: 8
    t.decimal "valid_days", precision: 20
  end

  create_table "bank_master", id: false, force: :cascade do |t|
    t.string "bank_code", limit: 8
    t.string "bank_name", limit: 100
    t.string "isactive", limit: 1
    t.string "swift_code", limit: 20
    t.string "local_bank", limit: 20
    t.string "routing", limit: 15
    t.string "routing2", limit: 15
    t.index ["bank_code"], name: "idx_bank_master_on_bank_code"
    t.index ["swift_code"], name: "idx_bank_master_on_swift_code"
  end

  create_table "barcode_transaction", id: false, force: :cascade do |t|
    t.decimal "barcodetransid"
    t.string "tranno", limit: 10
    t.string "bc_worker_code", limit: 13
    t.string "trans_id", limit: 14
    t.string "status", limit: 5
    t.string "creator_id", limit: 50
    t.datetime "creation_date"
    t.string "modifier_id", limit: 50
    t.datetime "modify_date"
    t.string "employer_code", limit: 10
    t.index ["trans_id"], name: "idx_barcode_transaction_on_trans_id"
  end

  create_table "batch_coupling_change", id: false, force: :cascade do |t|
    t.string "batch_transid", limit: 14
    t.string "bc_doctor_code", limit: 13
    t.string "bc_laboratory_code", limit: 13
    t.string "bc_xray_code", limit: 13
    t.string "status", limit: 2
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "batch_coupling_change_history", id: false, force: :cascade do |t|
    t.string "batch_transid", limit: 14
    t.string "bc_doctor_code", limit: 13
    t.string "bc_laboratory_code", limit: 13
    t.string "bc_xray_code", limit: 13
    t.string "status", limit: 2
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.index ["bc_doctor_code"], name: "idx_batch_coupling_change_history_on_bc_doctor_code"
    t.index ["bc_laboratory_code"], name: "idx_batch_coupling_change_history_on_bc_laboratory_code"
    t.index ["bc_xray_code"], name: "idx_batch_coupling_change_history_on_bc_xray_code"
  end

  create_table "batchlab_group", id: false, force: :cascade do |t|
    t.string "lab_group", limit: 2
    t.string "description", limit: 255
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "batchusers", id: false, force: :cascade do |t|
    t.string "usercode", limit: 13
    t.string "username", limit: 50
    t.string "userpass", limit: 100
    t.string "useremail", limit: 50
    t.datetime "lastlogindate"
    t.datetime "logoutdate"
    t.string "status", limit: 10
    t.decimal "ismerts"
    t.string "usergroup", limit: 2
  end

  create_table "branch_printers", id: false, force: :cascade do |t|
    t.decimal "branch_printerid", precision: 10
    t.string "branch_code", limit: 2
    t.string "printer_name", limit: 100
    t.string "active", limit: 1
  end

  create_table "branches", id: false, force: :cascade do |t|
    t.string "branch_code", limit: 2
    t.string "name", limit: 50
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 5
    t.string "district", limit: 15
    t.string "state", limit: 15
    t.string "phone", limit: 100
    t.string "fax", limit: 100
    t.string "email", limit: 100
    t.string "created_by", limit: 10
    t.string "branch_type", limit: 2
    t.string "bank_code", limit: 8
    t.string "bank_co", limit: 50
    t.string "bank_acctno", limit: 50
    t.string "bank_zone", limit: 5
  end

  create_table "bulletin_acknowledge", id: false, force: :cascade do |t|
    t.decimal "bulletinid", precision: 10
    t.string "usercode", limit: 10
    t.datetime "ackdate"
  end

  create_table "bulletin_master", id: false, force: :cascade do |t|
    t.decimal "bulletinid", precision: 10
    t.string "type", limit: 1
    t.string "target", limit: 1
    t.datetime "notice_date"
    t.string "subject", limit: 250
    t.text "notice"
    t.datetime "start_date"
    t.datetime "expiry_date"
    t.string "acknowledge", limit: 1
    t.string "filename", limit: 50
    t.string "filepath", limit: 250
    t.string "createby", limit: 13
    t.datetime "createdate"
    t.string "modifyby", limit: 13
    t.datetime "modifydate"
  end

  create_table "bulletin_target", id: false, force: :cascade do |t|
    t.decimal "bulletinid", precision: 10
    t.string "usercode", limit: 10
  end

  create_table "bypass_error", id: false, force: :cascade do |t|
    t.string "error_desc", limit: 30
    t.decimal "error_ind", precision: 2
  end

  create_table "capability_master", id: false, force: :cascade do |t|
    t.decimal "capid", precision: 10
    t.string "description", limit: 100
    t.decimal "category", precision: 10
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "longdesc", limit: 255
  end

  create_table "cng_worker_clinic", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "country_code", limit: 3
    t.string "clinic_code", limit: 10
  end

  create_table "code_m", id: false, force: :cascade do |t|
    t.string "req_type", limit: 2
    t.string "type_ind", limit: 1
    t.string "state_code", limit: 1
    t.string "name_first", limit: 1
    t.decimal "last_issue_no"
  end

  create_table "code_master", id: false, force: :cascade do |t|
    t.string "req_type", limit: 2
    t.string "type_ind", limit: 1
    t.string "state_code", limit: 1
    t.string "name_first", limit: 1
    t.decimal "last_issue_no"
    t.index ["state_code"], name: "idx_code_master_on_state_code"
  end

  create_table "code_state_master", id: false, force: :cascade do |t|
    t.string "state_code", limit: 7
    t.string "map_code", limit: 1
    t.index ["map_code"], name: "idx_code_state_master_on_map_code"
    t.index ["state_code"], name: "idx_code_state_master_on_state_code"
  end

  create_table "condition_map", id: false, force: :cascade do |t|
    t.string "parameter_code", limit: 10
    t.string "old_parameter_code", limit: 10
  end

  create_table "condition_master", id: false, force: :cascade do |t|
    t.string "parameter_code", limit: 10
    t.string "description", limit: 240
    t.index ["parameter_code"], name: "idx_condition_master_on_parameter_code"
  end

  create_table "copy_logs", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.datetime "updated_at", precision: 0
    t.string "description", limit: 255
    t.bigint "oracle_table_id"
    t.datetime "begin_at", precision: 0
    t.datetime "end_at", precision: 0
    t.text "remark"
    t.index ["oracle_table_id"], name: "copy_logs_oracle_table_id_index"
  end

  create_table "country_master", id: false, force: :cascade do |t|
    t.string "country_code", limit: 3
    t.string "country_name", limit: 50
    t.decimal "sequence", precision: 5
    t.index ["country_code"], name: "idx_country_master_on_country_code"
  end

  create_table "country_master", id: false, force: :cascade do |t|
    t.string "country_code", limit: 3
    t.string "country_name", limit: 50
    t.decimal "sequence", precision: 5
    t.index ["country_code"], name: "idx_country_master_on_country_code"
  end

  create_table "coupling_trans", id: false, force: :cascade do |t|
    t.string "bc_doctor_code", limit: 13
    t.string "bc_old_laboratory_code", limit: 13
    t.string "bc_laboratory_code", limit: 13
    t.string "bc_old_xray_code", limit: 13
    t.string "bc_xray_code", limit: 13
    t.string "bc_old_radiologist_code", limit: 13
    t.string "bc_radiologist_code", limit: 13
    t.datetime "transdate"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "customer_complaint", id: false, force: :cascade do |t|
    t.decimal "complaint_id", precision: 10
    t.string "complaint_by", limit: 100
    t.string "complaint_code", limit: 13
    t.string "complaint_type", limit: 1
    t.string "complaint_against", limit: 100
    t.string "complaint_against_code", limit: 13
    t.string "complaint_against_type", limit: 1
    t.datetime "complaint_date"
    t.string "complaint_content", limit: 2000
    t.string "assigned_to", limit: 100
    t.string "resolution_remarks", limit: 2000
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "delay_trans", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.string "worker_code", limit: 10
    t.datetime "exam_date"
    t.datetime "lab_submit_date"
    t.datetime "xray_submit_date"
    t.datetime "action_date"
  end

  create_table "diff_rh", id: false, force: :cascade do |t|
    t.string "tranno", limit: 10
    t.string "oldtranno", limit: 10
    t.string "branch_code", limit: 2
    t.string "service_type", limit: 2
    t.datetime "trandate"
  end

  create_table "discrp_tab", id: false, force: :cascade do |t|
    t.string "ftype", limit: 1
    t.string "scandir", limit: 2
    t.string "fcode", limit: 10
    t.string "ecode", limit: 2
    t.string "a_loc", limit: 1
    t.string "a_fcode", limit: 10
  end

  create_table "district_map", id: false, force: :cascade do |t|
    t.string "district_map_code", limit: 7
    t.string "district_map_name", limit: 50
  end

  create_table "district_master", id: false, force: :cascade do |t|
    t.string "district_code", limit: 7
    t.string "district_name", limit: 40
    t.string "country_code", limit: 3
    t.string "state_code", limit: 7
    t.index ["country_code"], name: "idx_district_master_on_country_code"
    t.index ["district_code"], name: "idx_district_master_on_district_code"
    t.index ["state_code"], name: "idx_district_master_on_state_code"
  end

  create_table "district_office", id: false, force: :cascade do |t|
    t.string "office_code", limit: 7
    t.string "office_name", limit: 255
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 25
    t.string "fax", limit: 25
    t.string "email_id", limit: 100
    t.string "primary_contact_person", limit: 50
    t.string "district_code", limit: 7
    t.string "state_code", limit: 7
    t.string "status_code", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "district_office_history", id: false, force: :cascade do |t|
    t.string "office_code", limit: 7
    t.string "office_name", limit: 255
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 25
    t.string "fax", limit: 25
    t.string "email_id", limit: 100
    t.string "primary_contact_person", limit: 50
    t.string "district_code", limit: 7
    t.string "state_code", limit: 7
    t.string "status_code", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.datetime "log_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.index ["district_code"], name: "idx_district_office_history_on_district_code"
    t.index ["office_code"], name: "idx_district_office_history_on_office_code"
    t.index ["post_code"], name: "idx_district_office_history_on_post_code"
    t.index ["state_code"], name: "idx_district_office_history_on_state_code"
    t.index ["status_code"], name: "idx_district_office_history_on_status_code"
  end

  create_table "doc_compare", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.string "old_doctor_name", limit: 50
    t.string "old_doctor_regn_no", limit: 20
    t.string "old_radiologist_code", limit: 10
    t.string "old_xray_code", limit: 10
    t.string "old_laboratory_code", limit: 10
    t.string "new_doctor_name", limit: 50
    t.string "new_doctor_regn_no", limit: 20
    t.string "new_radiologist_code", limit: 10
    t.string "new_xray_code", limit: 10
    t.string "new_laboratory_code", limit: 10
  end

  create_table "doc_lab_allocation", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.string "old_lab", limit: 10
    t.string "new_lab", limit: 10
    t.datetime "mod_date"
    t.decimal "modify_id", precision: 10
  end

  create_table "doc_quota_allocation", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.decimal "old_quota", precision: 10
    t.decimal "new_quota", precision: 10
    t.datetime "mod_date"
    t.decimal "modify_id", precision: 10
  end

  create_table "doc_status", id: false, force: :cascade do |t|
    t.datetime "action_date"
    t.string "doctor_code", limit: 10
    t.string "status", limit: 3
    t.string "reason", limit: 200
    t.datetime "date_susp"
  end

  create_table "doc_xray_allocation", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.string "old_xray", limit: 10
    t.string "new_xray", limit: 10
    t.datetime "mod_date"
    t.decimal "modify_id", precision: 10
  end

  create_table "doctor_change_request", id: false, force: :cascade do |t|
    t.decimal "dm_cr_id", precision: 10
    t.string "doctor_code", limit: 10
    t.datetime "request_date"
    t.string "status", limit: 20
    t.datetime "mclx_date"
    t.string "mclx_appxray", limit: 10
    t.decimal "approvedby", precision: 10
    t.datetime "approved_date"
    t.string "approved_comment", limit: 1000
    t.decimal "createby", precision: 10
    t.datetime "createdate"
    t.decimal "modifyby", precision: 10
    t.datetime "modifydate"
    t.string "require_mclx", limit: 1
    t.string "report_printed", limit: 1
  end

  create_table "doctor_change_request_detail", id: false, force: :cascade do |t|
    t.decimal "dm_cr_id", precision: 10
    t.string "cr_column", limit: 100
    t.string "cr_old", limit: 100
    t.string "cr_new", limit: 100
  end

  create_table "doctor_history", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.string "version_no", limit: 10
    t.datetime "creation_date"
    t.string "doctor_name", limit: 50
    t.string "clinic_name", limit: 100
    t.string "doctor_ic_new", limit: 20
    t.string "doctor_ic_old", limit: 20
    t.string "annual_practice_certificate", limit: 20
    t.string "application_number", limit: 7
    t.string "application_year", limit: 4
    t.string "kdm_member", limit: 10
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "district_code", limit: 7
    t.string "state_code", limit: 7
    t.string "country_code", limit: 3
    t.string "phone", limit: 100
    t.string "fax", limit: 100
    t.string "xray_code", limit: 10
    t.string "radiologist_code", limit: 10
    t.string "laboratory_code", limit: 10
    t.string "email_id", limit: 100
    t.string "xray_regn_no", limit: 20
    t.string "own_xray_clinic", limit: 1
    t.string "qualification", limit: 50
    t.string "no_of_solo_clinics", limit: 2
    t.string "no_of_group_clinics", limit: 2
    t.string "comments", limit: 4000
    t.decimal "numquarantine", precision: 4
    t.string "district_name", limit: 40
    t.datetime "modification_date"
    t.string "bc_doctor_code", limit: 13
    t.string "status_code", limit: 5
    t.decimal "quota", precision: 5
    t.decimal "quota_use", precision: 5
    t.string "nearest_district_office", limit: 7
    t.decimal "creator_id", precision: 10
    t.decimal "modify_id", precision: 10
    t.string "isproblematic", limit: 2
    t.string "bc_radiologist_code", limit: 13
    t.string "bc_xray_code", limit: 13
    t.string "bc_laboratory_code", limit: 13
    t.string "prefer_xray_code", limit: 13
    t.string "prefer_xray_distance", limit: 10
    t.decimal "dregid", precision: 10
    t.string "action", limit: 10
    t.datetime "action_date"
    t.string "mobile_no", limit: 20
    t.datetime "renewal_date"
    t.string "gst_code", limit: 20
    t.decimal "gst_tax", precision: 126
    t.decimal "male_rate", precision: 126
    t.decimal "female_rate", precision: 126
    t.string "bank_account_no", limit: 20
    t.string "bank_code", limit: 8
    t.decimal "gst_type", precision: 1
    t.decimal "mystics_ic", precision: 1
    t.index ["bank_code"], name: "idx_doctor_history_on_bank_code"
    t.index ["bc_doctor_code"], name: "idx_doctor_history_on_bc_doctor_code"
    t.index ["bc_laboratory_code"], name: "idx_doctor_history_on_bc_laboratory_code"
    t.index ["bc_radiologist_code"], name: "idx_doctor_history_on_bc_radiologist_code"
    t.index ["bc_xray_code"], name: "idx_doctor_history_on_bc_xray_code"
    t.index ["country_code"], name: "idx_doctor_history_on_country_code"
    t.index ["district_code"], name: "idx_doctor_history_on_district_code"
    t.index ["doctor_code"], name: "idx_doctor_history_on_doctor_code"
    t.index ["gst_code"], name: "idx_doctor_history_on_gst_code"
    t.index ["laboratory_code"], name: "idx_doctor_history_on_laboratory_code"
    t.index ["post_code"], name: "idx_doctor_history_on_post_code"
    t.index ["prefer_xray_code"], name: "idx_doctor_history_on_prefer_xray_code"
    t.index ["radiologist_code"], name: "idx_doctor_history_on_radiologist_code"
    t.index ["state_code"], name: "idx_doctor_history_on_state_code"
    t.index ["status_code"], name: "idx_doctor_history_on_status_code"
    t.index ["xray_code"], name: "idx_doctor_history_on_xray_code"
  end

  create_table "doctor_load_6p", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.decimal "quota", precision: 10
    t.decimal "quota_use", precision: 5
    t.decimal "allocation", precision: 10
    t.decimal "allocation_use", precision: 10
    t.decimal "no_exam", precision: 10
    t.decimal "load", precision: 10
    t.datetime "action_date"
    t.string "dist_code", limit: 5
    t.string "state_code", limit: 5
    t.decimal "bal_quota", precision: 10
  end

  create_table "doctor_master", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.string "doctor_name", limit: 50
    t.string "clinic_name", limit: 100
    t.datetime "creation_date"
    t.string "doctor_ic_new", limit: 20
    t.string "doctor_ic_old", limit: 20
    t.string "annual_practice_certificate", limit: 20
    t.string "application_number", limit: 7
    t.string "application_year", limit: 4
    t.string "kdm_member", limit: 10
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 100
    t.string "fax", limit: 100
    t.string "state_code", limit: 7
    t.string "district_code", limit: 7
    t.string "country_code", limit: 3
    t.string "radiologist_code", limit: 10
    t.string "xray_code", limit: 10
    t.string "laboratory_code", limit: 10
    t.string "email_id", limit: 100
    t.string "xray_regn_no", limit: 20
    t.string "version_no", limit: 10
    t.string "own_xray_clinic", limit: 1
    t.string "qualification", limit: 50
    t.string "no_of_solo_clinics", limit: 2
    t.string "no_of_group_clinics", limit: 2
    t.string "status_code", limit: 5
    t.string "comments", limit: 4000
    t.decimal "numquarantine", precision: 4
    t.string "bc_doctor_code", limit: 13
    t.decimal "quota", precision: 10
    t.decimal "quota_use", precision: 5
    t.string "nearest_district_office", limit: 7
    t.decimal "creator_id", precision: 10
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "isproblematic", limit: 2
    t.string "bc_radiologist_code", limit: 13
    t.string "bc_xray_code", limit: 13
    t.string "bc_laboratory_code", limit: 13
    t.string "prefer_xray_code", limit: 13
    t.string "prefer_xray_distance", limit: 10
    t.decimal "dregid", precision: 10
    t.string "gst_code", limit: 20
    t.decimal "gst_tax", precision: 126
    t.decimal "male_rate", precision: 126
    t.decimal "female_rate", precision: 126
    t.string "bank_account_no", limit: 20
    t.decimal "gst_type", precision: 10
    t.string "bank_code", limit: 8
    t.decimal "mystics_ic"
    t.string "mobile_no", limit: 20
    t.datetime "renewal_date"
    t.decimal "fp_device", precision: 1
    t.decimal "device_install", precision: 1
    t.index ["bank_code"], name: "idx_doctor_master_on_bank_code"
    t.index ["bc_doctor_code"], name: "idx_doctor_master_on_bc_doctor_code"
    t.index ["bc_laboratory_code"], name: "idx_doctor_master_on_bc_laboratory_code"
    t.index ["bc_radiologist_code"], name: "idx_doctor_master_on_bc_radiologist_code"
    t.index ["bc_xray_code"], name: "idx_doctor_master_on_bc_xray_code"
    t.index ["country_code"], name: "idx_doctor_master_on_country_code"
    t.index ["district_code"], name: "idx_doctor_master_on_district_code"
    t.index ["doctor_code"], name: "idx_doctor_master_on_doctor_code"
    t.index ["gst_code"], name: "idx_doctor_master_on_gst_code"
    t.index ["laboratory_code"], name: "idx_doctor_master_on_laboratory_code"
    t.index ["post_code"], name: "idx_doctor_master_on_post_code"
    t.index ["prefer_xray_code"], name: "idx_doctor_master_on_prefer_xray_code"
    t.index ["radiologist_code"], name: "idx_doctor_master_on_radiologist_code"
    t.index ["state_code"], name: "idx_doctor_master_on_state_code"
    t.index ["status_code"], name: "idx_doctor_master_on_status_code"
    t.index ["xray_code"], name: "idx_doctor_master_on_xray_code"
  end

  create_table "doctor_opthour", id: false, force: :cascade do |t|
    t.string "usercode", limit: 13
    t.datetime "monday_start"
    t.datetime "monday_end"
    t.string "monday_isclose", limit: 1
    t.string "monday_is24", limit: 1
    t.string "monday_break", limit: 255
    t.datetime "tuesday_start"
    t.datetime "tuesday_end"
    t.string "tuesday_isclose", limit: 1
    t.string "tuesday_is24", limit: 1
    t.string "tuesday_break", limit: 255
    t.datetime "wednesday_start"
    t.datetime "wednesday_end"
    t.string "wednesday_isclose", limit: 1
    t.string "wednesday_is24", limit: 1
    t.string "wednesday_break", limit: 255
    t.datetime "thursday_start"
    t.datetime "thursday_end"
    t.string "thursday_isclose", limit: 1
    t.string "thursday_is24", limit: 1
    t.string "thursday_break", limit: 255
    t.datetime "friday_start"
    t.datetime "friday_end"
    t.string "friday_isclose", limit: 1
    t.string "friday_is24", limit: 1
    t.string "friday_break", limit: 255
    t.datetime "saturday_start"
    t.datetime "saturday_end"
    t.string "saturday_isclose", limit: 1
    t.string "saturday_is24", limit: 1
    t.string "saturday_break", limit: 255
    t.datetime "sunday_start"
    t.datetime "sunday_end"
    t.string "sunday_isclose", limit: 1
    t.string "sunday_is24", limit: 1
    t.string "sunday_break", limit: 255
    t.datetime "pubhol_start"
    t.datetime "pubhol_end"
    t.string "pubhol_isclose", limit: 1
    t.string "pubhol_is24", limit: 1
    t.string "pubhol_break", limit: 255
    t.string "close_remark", limit: 255
    t.datetime "modified"
  end

  create_table "doctor_opthour_changelog", id: false, force: :cascade do |t|
    t.decimal "opt_changelog_cr_id", precision: 10
    t.string "usercode", limit: 20
    t.string "modifiedby", limit: 20
    t.datetime "modify_date"
    t.string "type", limit: 1
    t.decimal "bulletinid"
    t.string "dismiss", limit: 1
    t.decimal "dismiss_by"
    t.datetime "dismiss_date"
    t.string "remark", limit: 1000
  end

  create_table "doctor_parameter_master", id: false, force: :cascade do |t|
    t.string "parameter_code", limit: 10
    t.string "description", limit: 50
    t.string "status", limit: 1
    t.index ["parameter_code"], name: "idx_doctor_parameter_master_on_parameter_code"
  end

  create_table "doctor_quota_trans", id: false, force: :cascade do |t|
    t.datetime "trans_date"
    t.string "doctor_code", limit: 10
    t.decimal "old_quota"
    t.decimal "new_quota"
    t.datetime "decision_date"
    t.string "userid", limit: 20
  end

  create_table "doctor_registration", id: false, force: :cascade do |t|
    t.decimal "dregid", precision: 10
    t.string "doctor_name", limit: 50
    t.string "clinic_name", limit: 50
    t.string "doctor_ic_new", limit: 20
    t.string "doctor_ic_old", limit: 20
    t.string "application_number", limit: 20
    t.string "application_year", limit: 4
    t.string "kdm_member", limit: 10
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 25
    t.string "fax", limit: 25
    t.string "state_code", limit: 7
    t.string "district_code", limit: 7
    t.string "country_code", limit: 3
    t.string "email_id", limit: 100
    t.string "xray_regn_no", limit: 20
    t.string "own_xray_clinic", limit: 1
    t.string "qualification", limit: 50
    t.string "no_of_solo_clinics", limit: 2
    t.string "no_of_group_clinics", limit: 2
    t.string "status_code", limit: 5
    t.string "comments", limit: 4000
    t.string "prefer_xray_code", limit: 13
    t.string "prefer_xray_distance", limit: 10
    t.decimal "quota", precision: 5
    t.string "bc_radiologist_code", limit: 13
    t.string "bc_xray_code", limit: 13
    t.string "bc_laboratory_code", limit: 13
    t.string "nearest_district_office", limit: 7
    t.string "rcm_xray_code1", limit: 13
    t.string "rcm_xray_code2", limit: 13
    t.string "rcm_xray_code3", limit: 13
    t.string "tranno", limit: 10
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "doctor_request", id: false, force: :cascade do |t|
    t.decimal "dregid", precision: 10
    t.decimal "approval_id", precision: 10
    t.string "status", limit: 5
    t.string "comments", limit: 4000
    t.datetime "modification_date"
  end

  create_table "doctor_status_enquiry", id: false, force: :cascade do |t|
    t.string "bc_doctor_code", limit: 10
    t.decimal "reserved_quota", precision: 10
    t.decimal "pend_exam_less_5", precision: 10
    t.decimal "pend_exam_greater_5", precision: 10
    t.decimal "pend_cert_less_4", precision: 10
    t.decimal "pend_cert_greater_4", precision: 10
    t.decimal "pend_xray_less_5", precision: 10
    t.decimal "pend_xray_greater_5", precision: 10
    t.datetime "last_updated"
  end

  create_table "draft_allocation", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "allocation_amount", precision: 126
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.decimal "draft_master_id", precision: 19
    t.string "employer_code", limit: 40
    t.decimal "gst_amount", precision: 126
    t.string "invoice_no", limit: 40
    t.decimal "process_fee", precision: 126
  end

  create_table "draft_master", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.string "approval_code", limit: 80
    t.string "bank_area", limit: 400
    t.string "bank_code", limit: 32
    t.string "branch_code", limit: 8
    t.string "card_type", limit: 80
    t.string "collection_status", limit: 1020
    t.string "collection_uuid", limit: 1020
    t.string "comments", limit: 2000
    t.string "contact_address1", limit: 200
    t.string "contact_address2", limit: 200
    t.string "contact_address3", limit: 200
    t.string "contact_address4", limit: 200
    t.string "contact_district_code", limit: 28
    t.string "contact_fax", limit: 400
    t.string "contact_name", limit: 200
    t.string "contact_phone", limit: 400
    t.string "contact_post_code", limit: 28
    t.string "contact_state_code", limit: 28
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.datetime "date_issue"
    t.decimal "draft_type", precision: 10
    t.datetime "expiry_date"
    t.decimal "invoice_batch", precision: 10
    t.datetime "modification_date"
    t.decimal "modify_id", precision: 10
    t.string "name_on_card", limit: 400
    t.decimal "payment_amount", precision: 126
    t.string "payment_no", limit: 64
    t.decimal "payment_surcharge", precision: 126
    t.decimal "payment_type", precision: 10
    t.string "receipt_payment_no", limit: 64
    t.decimal "receipt_payment_type", precision: 10
    t.string "receipt_tranno", limit: 40
    t.string "ref_no", limit: 200
    t.decimal "replacement_draft_id", precision: 19
    t.decimal "status", precision: 10
    t.string "tranno", limit: 40
    t.datetime "transdate"
    t.string "voided_reason", limit: 1020
    t.string "zone_code", limit: 8
    t.decimal "source", precision: 10
    t.decimal "collection_cn_status"
    t.datetime "collection_date"
    t.datetime "voided_date"
    t.decimal "gst_amount", precision: 126
    t.decimal "gst_percentage", precision: 126
    t.decimal "employer_alloc_master_id", precision: 19
    t.string "ap_invoice_no", limit: 255
    t.decimal "ap_group_id", precision: 19
    t.decimal "other_amount", precision: 126
    t.decimal "other_amount_gst", precision: 126
    t.decimal "process_fee", precision: 126
    t.index ["approval_code"], name: "idx_draft_master_on_approval_code"
    t.index ["bank_code"], name: "idx_draft_master_on_bank_code"
    t.index ["branch_code"], name: "idx_draft_master_on_branch_code"
    t.index ["contact_district_code"], name: "idx_draft_master_on_contact_district_code"
    t.index ["contact_post_code"], name: "idx_draft_master_on_contact_post_code"
    t.index ["contact_state_code"], name: "idx_draft_master_on_contact_state_code"
    t.index ["zone_code"], name: "idx_draft_master_on_zone_code"
  end

  create_table "draft_usage", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.decimal "draft_master_id", precision: 19
    t.string "employer_code", limit: 40
    t.decimal "status", precision: 10
    t.string "trans_id", limit: 56
    t.decimal "utilise_amount", precision: 126
    t.string "worker_code", limit: 40
    t.string "branch_code", limit: 2
    t.index ["trans_id"], name: "idx_draft_usage_on_trans_id"
  end

  create_table "dup_rec", id: false, force: :cascade do |t|
    t.string "payment_no", limit: 10
    t.decimal "count"
  end

  create_table "dx_payblock", id: false, force: :cascade do |t|
    t.string "doc_xray_code", limit: 10
    t.string "doc_xray_ind", limit: 1
  end

  create_table "dxbasket", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.string "status", limit: 40
    t.datetime "submit_date"
    t.string "trans_id", limit: 56
    t.string "xray_code", limit: 40
    t.datetime "pickup_date"
    t.decimal "batch_id", precision: 10
    t.decimal "source_ref", precision: 10
    t.index ["trans_id"], name: "idx_dxbasket_on_trans_id"
  end

  create_table "dxfilm_audit", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.string "comments", limit: 4000
    t.datetime "create_date"
    t.string "creator_id", limit: 200
    t.decimal "film_auditid", precision: 10
    t.string "modifier_id", limit: 200
    t.datetime "modify_date"
    t.string "ref_transid", limit: 56
    t.string "trans_id", limit: 56
    t.string "worker_code", limit: 40
    t.index ["trans_id"], name: "idx_dxfilm_audit_on_trans_id"
  end

  create_table "dxfilm_movement", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.string "comments", limit: 500
    t.string "status", limit: 20
    t.datetime "status_date"
    t.string "trans_id", limit: 14
    t.string "uuid", limit: 255
    t.index ["trans_id"], name: "idx_dxfilm_movement_on_trans_id"
  end

  create_table "dxpcr_audit_comment", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.string "comments", limit: 2000
    t.string "parameter_code", limit: 20
    t.decimal "pcr_audit_film_id", precision: 19
  end

  create_table "dxpcr_audit_detail", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.string "parameter_code", limit: 20
    t.string "parameter_value", limit: 8
    t.decimal "pcr_audit_film_id", precision: 19
  end

  create_table "dxpcr_audit_film", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.datetime "audit_date"
    t.datetime "create_date"
    t.decimal "creator_id", precision: 10
    t.datetime "modify_date"
    t.decimal "modify_id", precision: 10
    t.string "pcr_code", limit: 40
    t.decimal "review_film_id", precision: 19
    t.string "trans_id", limit: 56
    t.string "worker_code", limit: 40
    t.string "xray_code", limit: 40
    t.decimal "retake_source", precision: 1
    t.index ["trans_id"], name: "idx_dxpcr_audit_film_on_trans_id"
  end

  create_table "dxpcr_pool", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.datetime "create_date"
    t.string "creator_id", limit: 40
    t.datetime "modify_date"
    t.string "modify_id", limit: 40
    t.string "pcr_code", limit: 40
    t.string "process_status", limit: 4
    t.decimal "review_film_id", precision: 19
    t.string "status", limit: 1020
    t.string "trans_id", limit: 56
    t.string "radiologist_code", limit: 40
    t.decimal "source_ref", precision: 1
    t.decimal "audit_film_id", precision: 19
    t.decimal "retake_source", precision: 1
    t.decimal "retake_request", precision: 1
    t.index ["trans_id"], name: "idx_dxpcr_pool_on_trans_id"
  end

  create_table "dxpcr_retake_reasons", id: false, force: :cascade do |t|
    t.string "id", limit: 20
    t.string "description", limit: 1000
  end

  create_table "dxprovider_master", id: false, force: :cascade do |t|
    t.string "provider_id", limit: 3
    t.string "provider_name", limit: 20
    t.string "passphrase", limit: 20
    t.string "provider_url", limit: 100
  end

  create_table "dxreview_film", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.datetime "create_date"
    t.decimal "creator_id", precision: 10
    t.datetime "modify_date"
    t.decimal "modify_id", precision: 10
    t.string "status", limit: 40
    t.string "trans_id", limit: 56
    t.string "worker_code", limit: 1020
    t.string "xray_code", limit: 40
    t.datetime "review_date"
    t.decimal "batch_id", precision: 10
    t.decimal "radiographer_id", precision: 10
    t.datetime "iqa_date"
    t.datetime "pcr_date"
    t.decimal "iqa_process_by", precision: 10
    t.decimal "autorelease", precision: 1
    t.decimal "autorelease_iqa", precision: 1
    t.index ["trans_id"], name: "idx_dxreview_film_on_trans_id"
  end

  create_table "dxreview_film_comment", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.string "comments", limit: 2000
    t.datetime "create_date"
    t.decimal "creator_id", precision: 10
    t.decimal "dxry_id", precision: 19
    t.datetime "modify_date"
    t.decimal "modify_id", precision: 10
  end

  create_table "dxreview_film_detail", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "dxry_id", precision: 19
    t.string "parameter_code", limit: 20
    t.string "parameter_value", limit: 8
  end

  create_table "dxreview_film_identical", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "dxry_id", precision: 19
    t.string "trans_id", limit: 56
    t.string "worker_code", limit: 40
    t.index ["trans_id"], name: "idx_dxreview_film_identical_on_trans_id"
  end

  create_table "dxxray_audit", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.string "comments", limit: 2000
    t.datetime "create_date"
    t.decimal "creator_id", precision: 10
    t.datetime "modify_date"
    t.decimal "modify_id", precision: 10
    t.string "ref_trans_id", limit: 56
    t.string "trans_id", limit: 56
    t.string "worker_code", limit: 40
    t.index ["trans_id"], name: "idx_dxxray_audit_on_trans_id"
  end

  create_table "employer_account", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "amount", precision: 126
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.decimal "draft_id", precision: 19
    t.decimal "draft_allocation_id", precision: 19
    t.decimal "draft_usage_id", precision: 19
    t.string "employer_code", limit: 40
    t.decimal "gst_amount", precision: 126
    t.datetime "modification_date"
    t.decimal "modify_id", precision: 10
    t.decimal "type", precision: 10
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.string "branch_code", limit: 2
    t.string "description", limit: 4000
    t.string "sex", limit: 1
    t.decimal "ap_group_id", precision: 19
    t.decimal "ap_id", precision: 19
    t.decimal "refund_id", precision: 19
    t.decimal "portal_batchid", precision: 10
    t.decimal "other_amount", precision: 126
    t.decimal "other_amount_gst", precision: 126
    t.decimal "gst_tax"
    t.decimal "process_fee", precision: 126
    t.index ["trans_id"], name: "idx_employer_account_on_trans_id"
  end

  create_table "employer_alloc_detail", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "allocation_amount", precision: 126
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.decimal "employer_alloc_master_id", precision: 19
    t.string "employer_code", limit: 40
    t.decimal "gst_amount", precision: 126
    t.string "invoice_no", limit: 40
  end

  create_table "employer_alloc_master", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.string "approval_code", limit: 80
    t.string "bank_area", limit: 400
    t.string "bank_code", limit: 32
    t.string "branch_code", limit: 8
    t.string "card_type", limit: 80
    t.string "collection_status", limit: 1020
    t.string "collection_uuid", limit: 1020
    t.string "comments", limit: 2000
    t.string "contact_address1", limit: 200
    t.string "contact_address2", limit: 200
    t.string "contact_address3", limit: 200
    t.string "contact_address4", limit: 200
    t.string "contact_district_code", limit: 28
    t.string "contact_fax", limit: 400
    t.string "contact_name", limit: 200
    t.string "contact_phone", limit: 400
    t.string "contact_post_code", limit: 28
    t.string "contact_state_code", limit: 28
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.datetime "date_issue"
    t.decimal "draft_type", precision: 10
    t.datetime "expiry_date"
    t.decimal "gst_amount", precision: 126
    t.decimal "gst_percentage", precision: 126
    t.decimal "invoice_batch", precision: 10
    t.datetime "modification_date"
    t.decimal "modify_id", precision: 10
    t.string "name_on_card", limit: 400
    t.decimal "payment_amount", precision: 126
    t.string "payment_no", limit: 64
    t.decimal "payment_surcharge", precision: 126
    t.decimal "payment_type", precision: 10
    t.string "receipt_payment_no", limit: 64
    t.decimal "receipt_payment_type", precision: 10
    t.string "receipt_tranno", limit: 40
    t.string "ref_no", limit: 200
    t.decimal "replacement_draft_id", precision: 19
    t.decimal "source", precision: 10
    t.decimal "status", precision: 10
    t.string "tranno", limit: 40
    t.datetime "transdate"
    t.datetime "voided_date"
    t.string "voided_reason", limit: 1020
    t.string "zone_code", limit: 8
    t.index ["approval_code"], name: "idx_employer_alloc_master_on_approval_code"
    t.index ["bank_code"], name: "idx_employer_alloc_master_on_bank_code"
    t.index ["branch_code"], name: "idx_employer_alloc_master_on_branch_code"
    t.index ["contact_district_code"], name: "idx_employer_alloc_master_on_contact_district_code"
    t.index ["contact_post_code"], name: "idx_employer_alloc_master_on_contact_post_code"
    t.index ["contact_state_code"], name: "idx_employer_alloc_master_on_contact_state_code"
    t.index ["zone_code"], name: "idx_employer_alloc_master_on_zone_code"
  end

  create_table "employer_cn", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "account_concile_id", precision: 19
    t.decimal "allocation_amount", precision: 126
    t.string "branch_code", limit: 1020
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.string "credit_note_no", limit: 40
    t.decimal "draft_allocation_id", precision: 19
    t.string "employer_code", limit: 40
    t.decimal "gst_amount", precision: 126
    t.decimal "is_posted", precision: 10
    t.decimal "gst_percentage", precision: 126
    t.decimal "nios_reference_no", precision: 19
    t.decimal "mystics_reference_no", precision: 19
    t.decimal "type", precision: 10
    t.datetime "posted_date"
    t.decimal "ap_group_id", precision: 19
    t.decimal "payment_refund_id", precision: 19
    t.decimal "other_amount", precision: 126
    t.decimal "other_amount_gst", precision: 126
  end

  create_table "employer_history", id: false, force: :cascade do |t|
    t.datetime "creation_date"
    t.string "employer_name", limit: 150
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 100
    t.string "fax", limit: 100
    t.string "comments", limit: 4000
    t.string "district_code", limit: 7
    t.string "employer_code", limit: 10
    t.string "version_no", limit: 10
    t.string "email_id", limit: 100
    t.string "primary_contact_person", limit: 50
    t.string "business_code", limit: 10
    t.string "country_code", limit: 3
    t.string "state_code", limit: 7
    t.string "primary_contact_phone", limit: 20
    t.string "doctor_code", limit: 10
    t.string "district_name", limit: 40
    t.datetime "modification_date"
    t.string "bc_employer_code", limit: 13
    t.string "bc_doctor_code", limit: 13
    t.string "status_code", limit: 5
    t.string "branch_code", limit: 2
    t.decimal "creator_id", precision: 10
    t.decimal "modify_id", precision: 10
    t.string "isblacklisted", limit: 5
    t.datetime "blacklisted_date"
    t.string "classification", limit: 5
    t.string "action", limit: 10
    t.datetime "action_date"
    t.string "company_regno", limit: 20
    t.string "icpassport_no", limit: 20
    t.decimal "employer_type", precision: 1
    t.index ["bc_doctor_code"], name: "idx_employer_history_on_bc_doctor_code"
    t.index ["bc_employer_code"], name: "idx_employer_history_on_bc_employer_code"
    t.index ["branch_code"], name: "idx_employer_history_on_branch_code"
    t.index ["business_code"], name: "idx_employer_history_on_business_code"
    t.index ["country_code"], name: "idx_employer_history_on_country_code"
    t.index ["district_code"], name: "idx_employer_history_on_district_code"
    t.index ["doctor_code"], name: "idx_employer_history_on_doctor_code"
    t.index ["employer_code"], name: "idx_employer_history_on_employer_code"
    t.index ["post_code"], name: "idx_employer_history_on_post_code"
    t.index ["state_code"], name: "idx_employer_history_on_state_code"
    t.index ["status_code"], name: "idx_employer_history_on_status_code"
  end

  create_table "employer_master", id: false, force: :cascade do |t|
    t.string "employer_code", limit: 10
    t.string "employer_name", limit: 150
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "business_code", limit: 10
    t.string "country_code", limit: 3
    t.string "state_code", limit: 7
    t.string "district_code", limit: 7
    t.string "status_code", limit: 5
    t.datetime "creation_date"
    t.string "post_code", limit: 10
    t.string "phone", limit: 100
    t.string "fax", limit: 100
    t.string "email_id", limit: 100
    t.string "primary_contact_person", limit: 50
    t.string "primary_contact_phone", limit: 20
    t.string "doctor_code", limit: 10
    t.string "version_no", limit: 10
    t.string "comments", limit: 4000
    t.string "bc_employer_code", limit: 13
    t.decimal "creator_id", precision: 10
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "branch_code", limit: 2
    t.string "isblacklisted", limit: 5
    t.datetime "blacklisted_date"
    t.string "bc_doctor_code", limit: 13
    t.string "classification", limit: 5
    t.string "company_regno", limit: 20
    t.string "icpassport_no", limit: 20
    t.decimal "badpayment_ind", precision: 1
    t.decimal "ap_group_id", precision: 19
    t.decimal "employer_account_type", precision: 1
    t.decimal "employer_type", precision: 1
    t.index ["bc_doctor_code"], name: "idx_employer_master_on_bc_doctor_code"
    t.index ["bc_employer_code"], name: "idx_employer_master_on_bc_employer_code"
    t.index ["branch_code"], name: "idx_employer_master_on_branch_code"
    t.index ["business_code"], name: "idx_employer_master_on_business_code"
    t.index ["country_code"], name: "idx_employer_master_on_country_code"
    t.index ["district_code"], name: "idx_employer_master_on_district_code"
    t.index ["doctor_code"], name: "idx_employer_master_on_doctor_code"
    t.index ["employer_code"], name: "idx_employer_master_on_employer_code"
    t.index ["post_code"], name: "idx_employer_master_on_post_code"
    t.index ["state_code"], name: "idx_employer_master_on_state_code"
    t.index ["status_code"], name: "idx_employer_master_on_status_code"
  end

  create_table "employer_notification", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.string "passport_no", limit: 20
    t.string "worker_name", limit: 50
    t.datetime "transdate"
    t.string "doctor_code", limit: 10
    t.datetime "expiry_date"
    t.string "expiry_ind", limit: 1
    t.string "branch_code", limit: 2
    t.string "state_code", limit: 1
    t.datetime "creation_date"
    t.string "employer_code", limit: 10
    t.index ["trans_id"], name: "idx_employer_notification_on_trans_id"
  end

  create_table "employer_notification_count", id: false, force: :cascade do |t|
    t.string "employer_code", limit: 10
    t.decimal "total", precision: 5
  end

  create_table "errormsg_from_kk", id: false, force: :cascade do |t|
    t.datetime "msgtime"
    t.string "msgtext", limit: 1000
    t.decimal "msgid"
  end

  create_table "fin_batch_master", id: false, force: :cascade do |t|
    t.decimal "batch_number"
    t.datetime "batch_startdate"
    t.datetime "batch_enddate"
  end

  create_table "fin_batch_trans", id: false, force: :cascade do |t|
    t.decimal "batch_number"
    t.string "trans_id", limit: 14
    t.datetime "certify_date"
    t.index ["trans_id"], name: "idx_fin_batch_trans_on_trans_id"
  end

  create_table "finance_payment", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "trans_id", limit: 14
    t.datetime "certify_date"
    t.datetime "report_date"
    t.index ["trans_id"], name: "idx_finance_payment_on_trans_id"
  end

  create_table "fom_doctor_quota_bkp", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.string "laboratory_code", limit: 10
    t.string "xray_code", limit: 10
    t.decimal "quota"
    t.decimal "quota_use"
    t.datetime "creation_date"
    t.string "status_code", limit: 5
  end

  create_table "fom_lab_payment_missed", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "lab_code", limit: 10
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.string "sex", limit: 1
    t.datetime "transdate"
    t.datetime "certify_date"
    t.index ["trans_id"], name: "idx_fom_lab_payment_missed_on_trans_id"
  end

  create_table "fom_lab_unpaid", id: false, force: :cascade do |t|
    t.decimal "l_order_no"
    t.string "l_trans_id", limit: 14
    t.string "l_lab_code", limit: 10
    t.string "l_worker_code", limit: 10
    t.datetime "l_specimen_date"
    t.datetime "l_submit_date"
    t.string "l_batch_no", limit: 100
    t.string "f_ref_no", limit: 100
    t.string "f_trans_id", limit: 14
    t.string "f_lab_code", limit: 10
    t.datetime "f_specimen_date"
    t.datetime "f_submit_date"
    t.datetime "f_certify_date"
    t.string "f_remark", limit: 2000
  end

  create_table "fom_module_master", id: false, force: :cascade do |t|
    t.decimal "mod_id"
    t.decimal "parent_mod_id"
    t.string "mod_desc", limit: 50
    t.string "description", limit: 250
    t.datetime "modified_date"
    t.datetime "created_date"
    t.decimal "sort_order"
    t.decimal "isactive"
    t.string "url", limit: 250
  end

  create_table "fom_params", id: false, force: :cascade do |t|
    t.string "param_code", limit: 100
    t.string "param_value", limit: 1000
    t.decimal "isactive"
    t.datetime "created_date"
    t.string "remark", limit: 1000
    t.string "refid", limit: 100
  end

  create_table "fom_pay_transaction", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.string "sex", limit: 1
    t.string "branch_code", limit: 2
    t.datetime "certify_date"
    t.string "sp_type", limit: 1
    t.string "sp_code", limit: 10
    t.decimal "sp_group_id"
    t.string "sp_state_code", limit: 20
    t.decimal "amount", precision: 126
    t.string "xray_notdone_ind", limit: 120
    t.datetime "created_date"
    t.string "gst_code", limit: 20
    t.decimal "gst_tax", precision: 126
    t.decimal "gst_type", precision: 10
    t.decimal "gstamount", precision: 126
    t.index ["trans_id"], name: "idx_fom_pay_transaction_on_trans_id"
  end

  create_table "fom_pay_transaction_missed", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.string "doctor_code", limit: 10
    t.string "name", limit: 50
    t.datetime "certify_date"
    t.decimal "doc_amount", precision: 6
    t.decimal "doc_ded", precision: 3
    t.string "xray_code", limit: 10
    t.decimal "xray_amount", precision: 6
    t.decimal "xray_ded", precision: 3
    t.string "doc_pb_ind", limit: 1
    t.string "xray_pb_ind", limit: 1
    t.datetime "doc_pb_date"
    t.datetime "xray_pb_date"
    t.datetime "doc_unb_date"
    t.datetime "xray_unb_date"
    t.string "sex", limit: 1
    t.index ["trans_id"], name: "idx_fom_pay_transaction_missed_on_trans_id"
  end

  create_table "fom_payment_status_missed", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "doctor_code", limit: 10
    t.string "doc_pay_ind", limit: 1
    t.datetime "doctor_paid"
    t.string "xray_code", limit: 10
    t.string "xray_pay_ind", limit: 1
    t.datetime "xray_paid"
    t.string "lab_code", limit: 10
    t.string "lab_pay_ind", limit: 1
    t.datetime "lab_paid"
    t.datetime "certify_date"
    t.index ["trans_id"], name: "idx_fom_payment_status_missed_on_trans_id"
  end

  create_table "fom_special_payment", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "sp_type", limit: 1
    t.datetime "payment_date"
    t.decimal "payment_amount"
    t.string "created_by", limit: 20
    t.datetime "created_date"
    t.index ["trans_id"], name: "idx_fom_special_payment_on_trans_id"
  end

  create_table "fom_tempmyeg", id: false, force: :cascade do |t|
    t.string "worker_name", limit: 50
    t.string "passport_no", limit: 25
    t.string "country", limit: 50
    t.string "old_passport_no", limit: 25
  end

  create_table "fom_tmp_jim", id: false, force: :cascade do |t|
    t.string "mfo_doc_no", limit: 20
    t.string "mfo_nat", limit: 20
    t.string "mfo_txn_id", limit: 20
    t.datetime "created_date"
    t.datetime "modified_date"
    t.string "diseases", limit: 4000
    t.string "unfit_comment", limit: 4000
    t.string "old_fit_ind", limit: 1
    t.string "new_fit_ind", limit: 1
    t.datetime "fit_ind_changed_date"
    t.datetime "mfo_exam_date"
    t.string "trans_id", limit: 20
    t.string "dfit_ind", limit: 1
    t.index ["trans_id"], name: "idx_fom_tmp_jim_on_trans_id"
  end

  create_table "fom_user_capability", id: false, force: :cascade do |t|
    t.decimal "uuid", precision: 10
    t.decimal "mod_id", precision: 38
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "fom_user_master", id: false, force: :cascade do |t|
    t.decimal "uuid", precision: 10
    t.decimal "passwordcount"
    t.datetime "attempdate"
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "fom_xray_not_done_missed", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "xray_code", limit: 10
    t.string "worker_code", limit: 10
    t.datetime "transdate"
    t.datetime "certify_date"
    t.datetime "xray_submit_date"
    t.datetime "release_date"
    t.decimal "xray_ded", precision: 3
    t.index ["trans_id"], name: "idx_fom_xray_not_done_missed_on_trans_id"
  end

  create_table "fom_xray_not_receive", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "xray_code", limit: 10
    t.string "xray_name", limit: 250
    t.string "phone", limit: 100
    t.string "fax", limit: 100
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.string "passport_no", limit: 20
    t.datetime "certify_date"
    t.datetime "xray_testdone_date"
    t.datetime "xray_submit_date"
    t.datetime "target_receive_date"
    t.decimal "day_delay"
    t.string "fit_ind", limit: 1
    t.string "dfit_ind", limit: 1
    t.string "xray_film_type", limit: 1
    t.datetime "modified_date"
    t.datetime "created_date"
    t.index ["trans_id"], name: "idx_fom_xray_not_receive_on_trans_id"
  end

  create_table "fom_xray_use_swast", id: false, force: :cascade do |t|
    t.string "xray_code", limit: 10
    t.datetime "install_date"
    t.datetime "created_date"
  end

  create_table "foreign_clinic_master", id: false, force: :cascade do |t|
    t.string "clinic_code", limit: 10
    t.string "country_code", limit: 3
    t.string "region", limit: 50
    t.string "clinic_name", limit: 100
    t.string "address", limit: 255
    t.string "phone_no", limit: 50
    t.string "status_code", limit: 1
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.index ["clinic_code"], name: "idx_foreign_clinic_master_on_clinic_code"
    t.index ["country_code"], name: "idx_foreign_clinic_master_on_country_code"
    t.index ["status_code"], name: "idx_foreign_clinic_master_on_status_code"
  end

  create_table "foreign_worker_biodata", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "nationality", limit: 3
    t.string "date_of_birth", limit: 8
    t.string "gender", limit: 1
    t.string "worker_name", limit: 150
    t.string "doc_expiry_date", limit: 8
    t.string "doc_issue_authority", limit: 3
    t.string "application_number", limit: 45
    t.string "afis_id", limit: 15
    t.string "ners_reason_code", limit: 5
    t.string "date_of_arrival", limit: 8
    t.string "employer_name", limit: 150
    t.string "employer_id", limit: 20
    t.string "employer_type", limit: 3
    t.string "employer_address1", limit: 40
    t.string "employer_address2", limit: 40
    t.string "employer_address3", limit: 40
    t.string "employer_address4", limit: 40
    t.string "employer_postcode", limit: 15
    t.string "employer_city", limit: 6
    t.string "employer_state", limit: 3
    t.string "employer_email", limit: 60
    t.string "employer_phone_no", limit: 25
    t.string "ners_status", limit: 3
    t.string "ners_message", limit: 100
    t.string "transaction_id", limit: 30
    t.decimal "uuid", precision: 10
    t.datetime "creation_date"
    t.string "surname", limit: 150
    t.string "passport_no", limit: 20
    t.string "fp_biosl", limit: 2
    t.string "trans_id", limit: 14
    t.string "fp_availability_status", limit: 3
    t.string "fp_avail", limit: 30
    t.string "renew_count_year", limit: 2
    t.string "pra_create_id", limit: 30
    t.decimal "verify_ind", precision: 1
    t.string "error_desc", limit: 100
    t.string "error_ind", limit: 10
    t.index ["trans_id"], name: "idx_foreign_worker_biodata_on_trans_id"
  end

  create_table "foreign_worker_master_cancel", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.datetime "creation_date"
    t.string "fathers_name", limit: 50
    t.datetime "date_of_birth"
    t.string "passport_no", limit: 20
    t.string "visa_no", limit: 20
    t.string "sex", limit: 1
    t.string "job_type", limit: 50
    t.datetime "arrival_date"
    t.string "version_no", limit: 10
    t.string "blood_group", limit: 3
    t.string "country_code", limit: 3
    t.datetime "departure_date"
    t.datetime "last_examine_date"
    t.string "employer_pref_ind", limit: 1
    t.string "imm_name", limit: 50
    t.string "agent_code", limit: 10
    t.string "employer_code", limit: 10
    t.string "fit_ind", limit: 1
    t.string "fomema_ind", limit: 1
    t.datetime "renewal_date"
    t.string "bc_worker_code", limit: 13
    t.string "bc_agent_code", limit: 13
    t.string "bc_employer_code", limit: 13
    t.string "can_renew", limit: 5
    t.string "ismonitor", limit: 5
    t.string "isimmblock", limit: 5
    t.decimal "creator_id", precision: 10
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "status_code", limit: 5
    t.decimal "ply_count", precision: 10
    t.string "ply_printed", limit: 5
    t.string "isblacklisted", limit: 5
    t.datetime "blacklisted_date"
    t.datetime "visa_expiry_date"
    t.string "rh", limit: 1
    t.string "classification", limit: 5
    t.string "clinic_code", limit: 10
    t.datetime "clinic_examdate"
    t.string "created_by", limit: 10
    t.string "immblocked_by", limit: 3
    t.string "pati", limit: 1
    t.decimal "cancel_by", precision: 10
    t.datetime "cancel_date"
    t.index ["agent_code"], name: "idx_foreign_worker_master_cancel_on_agent_code"
    t.index ["bc_agent_code"], name: "idx_foreign_worker_master_cancel_on_bc_agent_code"
    t.index ["bc_employer_code"], name: "idx_foreign_worker_master_cancel_on_bc_employer_code"
    t.index ["bc_worker_code"], name: "idx_foreign_worker_master_cancel_on_bc_worker_code"
    t.index ["clinic_code"], name: "idx_foreign_worker_master_cancel_on_clinic_code"
    t.index ["country_code"], name: "idx_foreign_worker_master_cancel_on_country_code"
    t.index ["employer_code"], name: "idx_foreign_worker_master_cancel_on_employer_code"
    t.index ["status_code"], name: "idx_foreign_worker_master_cancel_on_status_code"
    t.index ["worker_code"], name: "idx_foreign_worker_master_cancel_on_worker_code"
  end

  create_table "foreign_worker_master_delete", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.datetime "creation_date"
    t.string "fathers_name", limit: 50
    t.datetime "date_of_birth"
    t.string "passport_no", limit: 20
    t.string "visa_no", limit: 20
    t.string "sex", limit: 1
    t.string "job_type", limit: 50
    t.datetime "arrival_date"
    t.string "version_no", limit: 10
    t.string "blood_group", limit: 3
    t.string "country_code", limit: 3
    t.datetime "departure_date"
    t.datetime "last_examine_date"
    t.string "employer_pref_ind", limit: 1
    t.string "imm_name", limit: 50
    t.string "agent_code", limit: 10
    t.string "employer_code", limit: 10
    t.string "fit_ind", limit: 1
    t.string "fomema_ind", limit: 1
    t.datetime "renewal_date"
    t.string "bc_worker_code", limit: 13
    t.string "bc_agent_code", limit: 13
    t.string "bc_employer_code", limit: 13
    t.string "can_renew", limit: 5
    t.string "ismonitor", limit: 5
    t.string "isimmblock", limit: 5
    t.decimal "creator_id", precision: 10
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "status_code", limit: 5
    t.decimal "ply_count", precision: 10
    t.string "ply_printed", limit: 5
    t.string "isblacklisted", limit: 5
    t.datetime "blacklisted_date"
    t.datetime "visa_expiry_date"
    t.string "rh", limit: 1
    t.string "classification", limit: 5
    t.string "clinic_code", limit: 10
    t.datetime "clinic_examdate"
    t.string "created_by", limit: 10
    t.datetime "del_date"
    t.index ["agent_code"], name: "idx_foreign_worker_master_delete_on_agent_code"
    t.index ["bc_agent_code"], name: "idx_foreign_worker_master_delete_on_bc_agent_code"
    t.index ["bc_employer_code"], name: "idx_foreign_worker_master_delete_on_bc_employer_code"
    t.index ["bc_worker_code"], name: "idx_foreign_worker_master_delete_on_bc_worker_code"
    t.index ["clinic_code"], name: "idx_foreign_worker_master_delete_on_clinic_code"
    t.index ["country_code"], name: "idx_foreign_worker_master_delete_on_country_code"
    t.index ["employer_code"], name: "idx_foreign_worker_master_delete_on_employer_code"
    t.index ["status_code"], name: "idx_foreign_worker_master_delete_on_status_code"
    t.index ["worker_code"], name: "idx_foreign_worker_master_delete_on_worker_code"
  end

  create_table "fw_appeal", id: false, force: :cascade do |t|
    t.decimal "appealid", precision: 10
    t.string "trans_id", limit: 14
    t.string "bc_worker_code", limit: 13
    t.string "appeal_doctor_code", limit: 13
    t.datetime "letter_apointment_date"
    t.datetime "result_date"
    t.datetime "idemnity_date"
    t.datetime "letter_notification"
    t.string "comments", limit: 4000
    t.string "follow_up", limit: 13
    t.string "status", limit: 5
    t.string "appeal_success", limit: 5
    t.datetime "creation_date"
    t.datetime "modification_date"
    t.string "phase_status", limit: 2
    t.string "blood_group", limit: 3
    t.string "rh", limit: 1
    t.string "appeal_close_comments", limit: 4000
    t.string "officer_incharge", limit: 50
    t.string "iscancelled", limit: 1
    t.string "appeal_type", limit: 3
    t.string "appeal_start_comments", limit: 4000
    t.string "creator_id", limit: 10
    t.string "modification_id", limit: 10
    t.string "appeal_summary_comments", limit: 4000
    t.index ["trans_id"], name: "idx_fw_appeal_on_trans_id"
  end

  create_table "fw_appeal_approval", id: false, force: :cascade do |t|
    t.decimal "appealappid", precision: 10
    t.decimal "appealid", precision: 10
    t.decimal "req_userid", precision: 10
    t.datetime "req_date"
    t.string "req_comments", limit: 4000
    t.decimal "approval_userid", precision: 10
    t.datetime "approval_date"
    t.string "approval_comments", limit: 4000
    t.string "status", limit: 1
    t.string "appeal_result", limit: 1
  end

  create_table "fw_appeal_approval_history", id: false, force: :cascade do |t|
    t.decimal "appealappid", precision: 10
    t.decimal "appealid", precision: 10
    t.decimal "req_userid", precision: 10
    t.datetime "req_date"
    t.string "req_comments", limit: 4000
    t.decimal "approval_userid", precision: 10
    t.datetime "approval_date"
    t.string "approval_comments", limit: 4000
    t.string "status", limit: 1
    t.string "appeal_result", limit: 1
    t.string "action", limit: 10
    t.datetime "action_date"
  end

  create_table "fw_appeal_comment", id: false, force: :cascade do |t|
    t.decimal "appeal_commentid", precision: 10
    t.decimal "appealid", precision: 10
    t.string "comments", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "fw_appeal_doc_change", id: false, force: :cascade do |t|
    t.decimal "appealid", precision: 10
    t.string "comments", limit: 4000
    t.string "old_doctor_code", limit: 13
    t.string "new_doctor_code", limit: 13
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
  end

  create_table "fw_appeal_follow_up", id: false, force: :cascade do |t|
    t.decimal "followupid", precision: 10
    t.decimal "appealid", precision: 10
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.string "comments", limit: 4000
  end

  create_table "fw_appeal_follow_up_detail", id: false, force: :cascade do |t|
    t.decimal "followdetid", precision: 10
    t.decimal "followupid", precision: 10
    t.datetime "followup_date"
    t.string "followed_up", limit: 5
    t.datetime "followed_up_date"
    t.string "comments", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "fw_appeal_history", id: false, force: :cascade do |t|
    t.decimal "appealid", precision: 10
    t.string "trans_id", limit: 14
    t.string "bc_worker_code", limit: 13
    t.string "appeal_doctor_code", limit: 13
    t.datetime "letter_apointment_date"
    t.datetime "result_date"
    t.datetime "idemnity_date"
    t.datetime "letter_notification"
    t.string "comments", limit: 4000
    t.string "follow_up", limit: 13
    t.string "status", limit: 5
    t.string "appeal_success", limit: 5
    t.datetime "creation_date"
    t.datetime "modification_date"
    t.string "phase_status", limit: 2
    t.string "blood_group", limit: 3
    t.string "rh", limit: 1
    t.string "appeal_close_comments", limit: 4000
    t.string "officer_incharge", limit: 50
    t.string "iscancelled", limit: 1
    t.string "action", limit: 10
    t.datetime "action_date"
    t.string "appeal_type", limit: 3
    t.string "appeal_start_comments", limit: 4000
    t.string "creator_id", limit: 10
    t.string "modification_id", limit: 10
    t.string "appeal_summary_comments", limit: 4000
    t.index ["appeal_doctor_code"], name: "idx_fw_appeal_history_on_appeal_doctor_code"
    t.index ["bc_worker_code"], name: "idx_fw_appeal_history_on_bc_worker_code"
    t.index ["trans_id"], name: "idx_fw_appeal_history_on_trans_id"
  end

  create_table "fw_appeal_passfail_reason", id: false, force: :cascade do |t|
    t.decimal "reasonid", precision: 10
    t.string "appeal_param_code", limit: 10
    t.string "reason_code", limit: 10
    t.string "reason_description", limit: 250
    t.string "passfail", limit: 1
  end

  create_table "fw_appeal_todolist", id: false, force: :cascade do |t|
    t.decimal "appeal_todolist_id", precision: 10
    t.decimal "todoid", precision: 10
    t.string "parameter_code", limit: 10
    t.datetime "dr_date"
    t.datetime "fo_date"
    t.string "dr_done", limit: 1
    t.string "fo_done", limit: 1
    t.string "comments", limit: 1000
    t.decimal "appealid", precision: 10
    t.string "createid", limit: 10
    t.datetime "createdate"
    t.string "modifyid", limit: 10
    t.datetime "modifydate"
  end

  create_table "fw_appeal_unfit_details", id: false, force: :cascade do |t|
    t.decimal "appealid", precision: 10
    t.string "merts_param_code", limit: 10
    t.string "appeal_param_code", limit: 10
    t.string "reason_code", limit: 10
    t.string "passfail", limit: 1
    t.string "remarks", limit: 4000
  end

  create_table "fw_biodata_reenrolment", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "afis_id", limit: 15
    t.decimal "error_ind", precision: 10
    t.string "passport_no", limit: 20
    t.string "nationality", limit: 3
    t.string "date_of_birth", limit: 8
    t.string "gender", limit: 1
    t.datetime "insertdate"
    t.decimal "userid", precision: 10
    t.string "sp_code", limit: 10
  end

  create_table "fw_block", id: false, force: :cascade do |t|
    t.decimal "fw_block_id", precision: 10
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.string "passport_no", limit: 20
    t.datetime "date_of_birth"
    t.string "country", limit: 3
    t.string "type", limit: 1
    t.string "employer_code", limit: 13
    t.string "request_comment", limit: 4000
    t.string "imm_send_ind", limit: 1
    t.string "can_renew", limit: 5
    t.string "status", limit: 1
    t.decimal "approved_by", precision: 10
    t.datetime "approved_date"
    t.string "approved_comment", limit: 4000
    t.decimal "unblocked_by"
    t.datetime "unblocked_date"
    t.string "unblocked_comment", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "created_date"
    t.string "isimmblock", limit: 5
    t.decimal "unblock_requestby"
    t.datetime "unblock_requestdate"
    t.string "unblock_request_comment", limit: 4000
  end

  create_table "fw_change_trans", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "trans_id", limit: 14
    t.string "table_name", limit: 50
    t.string "field_name", limit: 50
    t.string "old_value", limit: 100
    t.string "new_value", limit: 100
    t.string "record_version", limit: 10
    t.string "comments", limit: 255
    t.string "userid", limit: 20
    t.datetime "modify_date"
    t.string "ip", limit: 20
    t.decimal "module_id", precision: 9
    t.index ["trans_id"], name: "idx_fw_change_trans_on_trans_id"
  end

  create_table "fw_comment", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "parameter_code", limit: 10
    t.string "comments", limit: 1000
    t.datetime "modification_date"
    t.index ["trans_id"], name: "idx_fw_comment_on_trans_id"
  end

  create_table "fw_comment_history", id: false, force: :cascade do |t|
    t.datetime "log_date"
    t.string "trans_id", limit: 14
    t.string "parameter_code", limit: 10
    t.string "comments", limit: 1000
    t.datetime "modification_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.index ["parameter_code"], name: "idx_fw_comment_history_on_parameter_code"
    t.index ["trans_id"], name: "idx_fw_comment_history_on_trans_id"
  end

  create_table "fw_critical_info", id: false, force: :cascade do |t|
    t.decimal "fw_critical_id", precision: 10
    t.string "worker_code", limit: 10
    t.datetime "request_date"
    t.decimal "reason", precision: 10
    t.string "reason_others", limit: 1000
    t.decimal "approvedby", precision: 10
    t.datetime "approved_date"
    t.string "approved_comment", limit: 1000
    t.string "status", limit: 1
    t.decimal "createby", precision: 10
    t.datetime "createdate"
    t.decimal "modifyby", precision: 10
    t.datetime "modifydate"
    t.string "branch_code", limit: 2
  end

  create_table "fw_critical_info_detail", id: false, force: :cascade do |t|
    t.decimal "fw_critical_id", precision: 10
    t.string "critical_column", limit: 100
    t.string "critical_old", limit: 50
    t.string "critical_new", limit: 50
  end

  create_table "fw_detail", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "parameter_code", limit: 10
    t.string "med_history", limit: 5
    t.datetime "effected_date"
    t.string "parameter_value", limit: 20
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.index ["trans_id"], name: "idx_fw_detail_on_trans_id"
  end

  create_table "fw_detail_history", id: false, force: :cascade do |t|
    t.string "parameter_code", limit: 10
    t.string "trans_id", limit: 14
    t.string "med_history", limit: 5
    t.datetime "effected_date"
    t.datetime "modification_date"
    t.string "parameter_value", limit: 20
    t.string "action", limit: 10
    t.datetime "action_date"
    t.decimal "modify_id", precision: 10
    t.index ["parameter_code"], name: "idx_fw_detail_history_on_parameter_code"
    t.index ["trans_id"], name: "idx_fw_detail_history_on_trans_id"
  end

  create_table "fw_extra_comments", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.datetime "comment_date"
    t.string "comment_time", limit: 8
    t.string "userid", limit: 30
    t.string "comments", limit: 4000
    t.index ["trans_id"], name: "idx_fw_extra_comments_on_trans_id"
  end

  create_table "fw_extra_comments_history", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.datetime "log_date"
    t.datetime "comment_date"
    t.string "comment_time", limit: 8
    t.string "userid", limit: 30
    t.string "action", limit: 10
    t.datetime "action_date"
    t.string "comments", limit: 4000
    t.index ["trans_id"], name: "idx_fw_extra_comments_history_on_trans_id"
  end

  create_table "fw_medblocked", id: false, force: :cascade do |t|
    t.string "blk_tranno", limit: 10
    t.string "receipt_tranno", limit: 10
    t.string "isblock", limit: 1
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
  end

  create_table "fw_monitor", id: false, force: :cascade do |t|
    t.decimal "monitorid", precision: 10
    t.string "bc_worker_code", limit: 13
    t.string "trans_id", limit: 14
    t.string "reason_code", limit: 5
    t.string "comments", limit: 4000
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.string "removal_comments", limit: 4000
    t.index ["trans_id"], name: "idx_fw_monitor_on_trans_id"
  end

  create_table "fw_monitor_reason", id: false, force: :cascade do |t|
    t.string "reason_code", limit: 5
    t.string "description", limit: 100
    t.decimal "capid", precision: 10
    t.string "shortdesc", limit: 10
  end

  create_table "fw_movement", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.string "branch_code", limit: 8
    t.datetime "log_date"
    t.decimal "module_code", precision: 10
    t.string "remarks", limit: 4000
    t.string "trans_id", limit: 56
    t.string "userid", limit: 80
    t.string "worker_code", limit: 1020
    t.index ["trans_id"], name: "idx_fw_movement_on_trans_id"
  end

  create_table "fw_quarantine_reason", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "reason_code", limit: 10
    t.index ["trans_id"], name: "idx_fw_quarantine_reason_on_trans_id"
  end

  create_table "fw_quarantine_reason_history", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "reason_code", limit: 10
    t.datetime "log_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.index ["reason_code"], name: "idx_fw_quarantine_reason_history_on_reason_code"
    t.index ["trans_id"], name: "idx_fw_quarantine_reason_history_on_trans_id"
  end

  create_table "fw_transaction", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "doctor_code", limit: 10
    t.string "employer_code", limit: 10
    t.string "laboratory_code", limit: 10
    t.string "radiologist_code", limit: 10
    t.string "xray_code", limit: 10
    t.string "worker_code", limit: 10
    t.datetime "transdate"
    t.string "org_bit", limit: 1
    t.datetime "certify_date"
    t.datetime "exam_date"
    t.datetime "lab_submit_date"
    t.datetime "xray_submit_date"
    t.string "height", limit: 6
    t.string "weight", limit: 6
    t.string "pulse", limit: 6
    t.string "systolic", limit: 6
    t.string "diastolic", limit: 6
    t.string "bld_grp", limit: 2
    t.string "rh", limit: 1
    t.string "fit_ind", limit: 1
    t.string "imm_ind", limit: 1
    t.string "renew_ind", limit: 1
    t.string "qrtn_ind", limit: 1
    t.string "imm_send_ind", limit: 1
    t.string "lab_notdone_ind", limit: 1
    t.string "xray_notdone_ind", limit: 1
    t.datetime "release_date"
    t.string "invalidate_result", limit: 1
    t.datetime "invalidate_date"
    t.datetime "imm_send_date"
    t.string "user_id", limit: 30
    t.string "bc_doctor_code", limit: 13
    t.string "bc_employer_code", limit: 13
    t.string "bc_laboratory_code", limit: 13
    t.string "bc_radiologist_code", limit: 13
    t.string "bc_xray_code", limit: 13
    t.string "bc_worker_code", limit: 13
    t.string "version_no", limit: 10
    t.datetime "xray_testdone_date"
    t.string "taken_drugs", limit: 1
    t.string "tcupi_ind", limit: 1
    t.datetime "lab_specimen_date"
    t.datetime "last_pms_date"
    t.string "worker_consent", limit: 1
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "created_by", limit: 30
    t.string "ismonitor", limit: 1
    t.string "doctor_state_code", limit: 7
    t.decimal "ply_count"
    t.string "irr_ind", limit: 1
    t.string "imr_ind", limit: 1
    t.decimal "med_ind"
    t.decimal "reg_ind"
    t.string "xray_film_type", limit: 1
    t.decimal "dfit_ind", precision: 1
    t.decimal "mfit_ind", precision: 1
    t.decimal "xfit_ind", precision: 1
    t.decimal "mr", precision: 1
    t.decimal "xr", precision: 1
    t.decimal "revenue_ind", precision: 1
    t.decimal "badpayment_ind", precision: 1
    t.decimal "payment_ind", precision: 1
    t.string "xqrtn_ind", limit: 1
    t.datetime "xrelease_date"
    t.string "unfit_printed", limit: 1
    t.string "sex", limit: 1
    t.decimal "docfp", precision: 1
    t.datetime "docfp_date"
    t.decimal "xrayfp", precision: 1
    t.datetime "xrayfp_date"
    t.decimal "plks_no", precision: 3
    t.decimal "ispra", precision: 1
    t.datetime "lab_specimen_taken_date"
    t.string "blood_barcode_no", limit: 20
    t.string "urine_barcode_no", limit: 20
    t.string "xray_ref_no", limit: 20
    t.decimal "icr_ind", precision: 1
    t.string "provider_id", limit: 3
    t.string "xray_upload_status", limit: 3
    t.index ["trans_id"], name: "idx_fw_transaction_on_trans_id"
    t.index ["transdate"], name: "idx_fw_transaction_on_transdate"
  end

  create_table "fw_transaction_cancel", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "doctor_code", limit: 10
    t.string "employer_code", limit: 10
    t.string "laboratory_code", limit: 10
    t.string "radiologist_code", limit: 10
    t.string "xray_code", limit: 10
    t.string "worker_code", limit: 10
    t.datetime "transdate"
    t.string "org_bit", limit: 1
    t.datetime "certify_date"
    t.datetime "exam_date"
    t.datetime "lab_submit_date"
    t.datetime "xray_submit_date"
    t.string "height", limit: 6
    t.string "weight", limit: 6
    t.string "pulse", limit: 6
    t.string "systolic", limit: 6
    t.string "diastolic", limit: 6
    t.string "bld_grp", limit: 2
    t.string "rh", limit: 1
    t.string "fit_ind", limit: 1
    t.string "imm_ind", limit: 1
    t.string "renew_ind", limit: 1
    t.string "qrtn_ind", limit: 1
    t.string "imm_send_ind", limit: 1
    t.string "lab_notdone_ind", limit: 1
    t.string "xray_notdone_ind", limit: 1
    t.datetime "release_date"
    t.string "invalidate_result", limit: 1
    t.datetime "invalidate_date"
    t.datetime "imm_send_date"
    t.string "user_id", limit: 30
    t.string "bc_doctor_code", limit: 13
    t.string "bc_employer_code", limit: 13
    t.string "bc_laboratory_code", limit: 13
    t.string "bc_radiologist_code", limit: 13
    t.string "bc_xray_code", limit: 13
    t.string "bc_worker_code", limit: 13
    t.string "version_no", limit: 10
    t.datetime "xray_testdone_date"
    t.string "taken_drugs", limit: 1
    t.string "tcupi_ind", limit: 1
    t.datetime "lab_specimen_date"
    t.datetime "last_pms_date"
    t.string "worker_consent", limit: 1
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "created_by", limit: 30
    t.string "ismonitor", limit: 1
    t.string "doctor_state_code", limit: 7
    t.decimal "ply_count"
    t.string "irr_ind", limit: 1
    t.string "imr_ind", limit: 1
    t.decimal "med_ind"
    t.decimal "reg_ind"
    t.string "xray_film_type", limit: 1
    t.decimal "dfit_ind", precision: 1
    t.decimal "mfit_ind", precision: 1
    t.decimal "xfit_ind", precision: 1
    t.decimal "mr", precision: 1
    t.decimal "xr", precision: 1
    t.decimal "revenue_ind", precision: 1
    t.decimal "badpayment_ind", precision: 1
    t.string "xqrtn_ind", limit: 1
    t.decimal "payment_ind", precision: 1
    t.decimal "cancel_by", precision: 10
    t.datetime "cancel_date"
    t.string "sex", limit: 1
    t.index ["trans_id"], name: "idx_fw_transaction_cancel_on_trans_id"
  end

  create_table "fw_transaction_delete", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "doctor_code", limit: 10
    t.string "employer_code", limit: 10
    t.string "laboratory_code", limit: 10
    t.string "radiologist_code", limit: 10
    t.string "xray_code", limit: 10
    t.string "worker_code", limit: 10
    t.datetime "transdate"
    t.string "org_bit", limit: 1
    t.datetime "certify_date"
    t.datetime "exam_date"
    t.datetime "lab_submit_date"
    t.datetime "xray_submit_date"
    t.string "height", limit: 6
    t.string "weight", limit: 6
    t.string "pulse", limit: 6
    t.string "systolic", limit: 6
    t.string "diastolic", limit: 6
    t.string "bld_grp", limit: 2
    t.string "rh", limit: 1
    t.string "fit_ind", limit: 1
    t.string "imm_ind", limit: 1
    t.string "renew_ind", limit: 1
    t.string "qrtn_ind", limit: 1
    t.string "imm_send_ind", limit: 1
    t.string "lab_notdone_ind", limit: 1
    t.string "xray_notdone_ind", limit: 1
    t.datetime "release_date"
    t.string "invalidate_result", limit: 1
    t.datetime "invalidate_date"
    t.datetime "imm_send_date"
    t.string "user_id", limit: 30
    t.string "bc_doctor_code", limit: 13
    t.string "bc_employer_code", limit: 13
    t.string "bc_laboratory_code", limit: 13
    t.string "bc_radiologist_code", limit: 13
    t.string "bc_xray_code", limit: 13
    t.string "bc_worker_code", limit: 13
    t.string "version_no", limit: 10
    t.datetime "xray_testdone_date"
    t.string "taken_drugs", limit: 1
    t.string "tcupi_ind", limit: 1
    t.datetime "lab_specimen_date"
    t.datetime "last_pms_date"
    t.string "worker_consent", limit: 1
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "created_by", limit: 30
    t.index ["trans_id"], name: "idx_fw_transaction_delete_on_trans_id"
  end

  create_table "fw_transaction_history", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.datetime "log_date"
    t.string "worker_code", limit: 10
    t.string "xray_code", limit: 10
    t.string "radiologist_code", limit: 10
    t.string "doctor_code", limit: 10
    t.string "laboratory_code", limit: 10
    t.string "employer_code", limit: 10
    t.datetime "transdate"
    t.string "org_bit", limit: 1
    t.datetime "certify_date"
    t.datetime "exam_date"
    t.datetime "lab_submit_date"
    t.datetime "xray_submit_date"
    t.string "height", limit: 6
    t.string "weight", limit: 6
    t.string "pulse", limit: 6
    t.string "systolic", limit: 6
    t.string "diastolic", limit: 6
    t.string "bld_grp", limit: 2
    t.string "rh", limit: 1
    t.string "fit_ind", limit: 1
    t.string "imm_ind", limit: 1
    t.string "renew_ind", limit: 1
    t.string "qrtn_ind", limit: 1
    t.string "imm_send_ind", limit: 1
    t.string "lab_notdone_ind", limit: 1
    t.string "xray_notdone_ind", limit: 1
    t.datetime "release_date"
    t.string "invalidate_result", limit: 1
    t.datetime "invalidate_date"
    t.datetime "imm_send_date"
    t.string "user_id", limit: 30
    t.datetime "modification_date"
    t.string "bc_doctor_code", limit: 13
    t.string "bc_employer_code", limit: 13
    t.string "bc_laboratory_code", limit: 13
    t.string "bc_radiologist_code", limit: 13
    t.string "bc_xray_code", limit: 13
    t.string "bc_worker_code", limit: 13
    t.string "version_no", limit: 10
    t.datetime "xray_testdone_date"
    t.string "tcupi_ind", limit: 1
    t.string "taken_drugs", limit: 1
    t.datetime "lab_specimen_date"
    t.string "worker_consent", limit: 1
    t.string "action", limit: 10
    t.datetime "action_date"
    t.datetime "last_pms_date"
    t.decimal "modify_id", precision: 10
    t.string "created_by", limit: 30
    t.string "ismonitor", limit: 1
    t.string "doctor_state_code", limit: 7
    t.decimal "ply_count"
    t.string "irr_ind", limit: 1
    t.string "imr_ind", limit: 1
    t.decimal "med_ind"
    t.decimal "reg_ind"
    t.string "xray_film_type", limit: 1
    t.string "xqrtn_ind", limit: 1
    t.decimal "badpayment_ind", precision: 1
    t.datetime "xrelease_date"
    t.string "unfit_printed", limit: 1
    t.decimal "dfit_ind", precision: 1
    t.decimal "mfit_ind", precision: 1
    t.decimal "xfit_ind", precision: 1
    t.decimal "mr", precision: 1
    t.decimal "xr", precision: 1
    t.decimal "payment_ind", precision: 1
    t.string "sex", limit: 1
    t.decimal "plks_no", precision: 3
    t.decimal "ispra", precision: 1
    t.datetime "lab_specimen_taken_date"
    t.string "blood_barcode_no", limit: 20
    t.string "urine_barcode_no", limit: 20
    t.string "xray_ref_no", limit: 20
    t.string "provider_id", limit: 3
    t.string "xray_upload_status", limit: 3
    t.index ["bc_doctor_code"], name: "idx_fw_transaction_history_on_bc_doctor_code"
    t.index ["bc_employer_code"], name: "idx_fw_transaction_history_on_bc_employer_code"
    t.index ["bc_laboratory_code"], name: "idx_fw_transaction_history_on_bc_laboratory_code"
    t.index ["bc_radiologist_code"], name: "idx_fw_transaction_history_on_bc_radiologist_code"
    t.index ["bc_worker_code"], name: "idx_fw_transaction_history_on_bc_worker_code"
    t.index ["bc_xray_code"], name: "idx_fw_transaction_history_on_bc_xray_code"
    t.index ["blood_barcode_no"], name: "idx_fw_transaction_history_on_blood_barcode_no"
    t.index ["doctor_code"], name: "idx_fw_transaction_history_on_doctor_code"
    t.index ["doctor_state_code"], name: "idx_fw_transaction_history_on_doctor_state_code"
    t.index ["employer_code"], name: "idx_fw_transaction_history_on_employer_code"
    t.index ["laboratory_code"], name: "idx_fw_transaction_history_on_laboratory_code"
    t.index ["radiologist_code"], name: "idx_fw_transaction_history_on_radiologist_code"
    t.index ["trans_id"], name: "idx_fw_transaction_history_on_trans_id"
    t.index ["urine_barcode_no"], name: "idx_fw_transaction_history_on_urine_barcode_no"
    t.index ["worker_code"], name: "idx_fw_transaction_history_on_worker_code"
    t.index ["xray_code"], name: "idx_fw_transaction_history_on_xray_code"
  end

  create_table "fw_transaction_update", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "doctor_code", limit: 10
    t.string "laboratory_code", limit: 10
    t.string "xray_code", limit: 10
    t.string "worker_code", limit: 10
    t.datetime "transdate"
    t.datetime "certify_date"
    t.datetime "exam_date"
    t.datetime "lab_submit_date"
    t.datetime "xray_submit_date"
    t.string "height", limit: 6
    t.string "weight", limit: 6
    t.string "pulse", limit: 6
    t.string "bld_grp", limit: 2
    t.string "rh", limit: 1
    t.string "fit_ind", limit: 1
    t.string "invalidate_result", limit: 1
    t.datetime "invalidate_date"
    t.string "username", limit: 30
    t.string "osuser", limit: 30
    t.string "machine", limit: 100
    t.string "action", limit: 9
    t.datetime "audit_date"
    t.string "employer_code", limit: 10
    t.index ["trans_id"], name: "idx_fw_transaction_update_on_trans_id"
  end

  create_table "fw_unsuitable_reasons", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.decimal "unsuitable_id", precision: 10
    t.index ["trans_id"], name: "idx_fw_unsuitable_reasons_on_trans_id"
  end

  create_table "fw_worker_replacement", id: false, force: :cascade do |t|
    t.string "wk_tranno", limit: 10
    t.string "wr_tranno", limit: 10
    t.string "wk_transid", limit: 14
    t.string "wr_transid", limit: 14
    t.string "reason", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "create_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modify_date"
    t.string "status", limit: 1
    t.string "worker_code", limit: 20
  end

  create_table "fwm_change_trans", id: false, force: :cascade do |t|
    t.string "bc_worker_code", limit: 13
    t.string "trans_id", limit: 14
    t.string "old_value", limit: 100
    t.string "new_value", limit: 100
    t.string "reason_code", limit: 5
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.index ["trans_id"], name: "idx_fwm_change_trans_on_trans_id"
  end

  create_table "fwm_change_trans_org", id: false, force: :cascade do |t|
    t.string "bc_worker_code", limit: 13
    t.string "trans_id", limit: 14
    t.string "old_value", limit: 100
    t.string "new_value", limit: 100
    t.string "reason_code", limit: 5
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.index ["trans_id"], name: "idx_fwm_change_trans_org_on_trans_id"
  end

  create_table "fwm_modulecode", id: false, force: :cascade do |t|
    t.decimal "module_code", precision: 5
    t.string "description", limit: 255
    t.decimal "status", precision: 1
    t.string "creator_id", limit: 20
    t.datetime "create_date"
  end

  create_table "fwm_mon", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "ismonitor", limit: 5
    t.string "passport_no", limit: 20
  end

  create_table "fwt_change_clinic_approval", id: false, force: :cascade do |t|
    t.decimal "req_id", precision: 10
    t.string "trans_id", limit: 16
    t.string "worker_code", limit: 10
    t.string "doctor_code", limit: 10
    t.string "payment_mode", limit: 20
    t.decimal "payment_amount", precision: 126
    t.string "foc_reason", limit: 2000
    t.decimal "approval_status"
    t.datetime "creation_date"
    t.decimal "created_by", precision: 10
    t.datetime "modification_date"
    t.decimal "modified_by", precision: 10
    t.string "branch_code", limit: 2
    t.string "approval_comment", limit: 2000
    t.index ["trans_id"], name: "idx_fwt_change_clinic_approval_on_trans_id"
  end

  create_table "fwt_change_journal", id: false, force: :cascade do |t|
    t.string "chgjl_id", limit: 14
    t.datetime "chgjl_date"
    t.string "trans_id", limit: 14
    t.string "userid", limit: 30
    t.index ["trans_id"], name: "idx_fwt_change_journal_on_trans_id"
  end

  create_table "fwt_change_journal_detail", id: false, force: :cascade do |t|
    t.string "chgjl_id", limit: 14
    t.string "chgtype", limit: 1
    t.string "old_code", limit: 10
    t.string "new_code", limit: 10
    t.string "reason", limit: 240
  end

  create_table "fwt_deferred", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.datetime "creation_date"
    t.string "created_by", limit: 30
    t.index ["trans_id"], name: "idx_fwt_deferred_on_trans_id"
  end

  create_table "fwt_examdate_change_trans", id: false, force: :cascade do |t|
    t.decimal "change_id", precision: 9
    t.string "trans_id", limit: 14
    t.datetime "old_exam_date"
    t.datetime "new_exam_date"
    t.string "initiated_by", limit: 20
    t.datetime "date_initiated"
    t.string "status", limit: 1
    t.string "concur_by", limit: 20
    t.datetime "concur_date"
    t.index ["trans_id"], name: "idx_fwt_examdate_change_trans_on_trans_id"
  end

  create_table "fwt_regmed", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.datetime "transdate"
    t.datetime "certify_date"
    t.decimal "med_ind"
    t.decimal "reg_ind"
    t.index ["trans_id"], name: "idx_fwt_regmed_on_trans_id"
  end

  create_table "fwt_regmed_delta", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.datetime "transdate"
    t.datetime "certify_date"
    t.decimal "med_ind"
    t.decimal "reg_ind"
    t.index ["trans_id"], name: "idx_fwt_regmed_delta_on_trans_id"
  end

  create_table "fwt_shadow", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "shadow_id", limit: 14
    t.string "xray_code", limit: 10
    t.datetime "xray_submit_date"
    t.decimal "type", precision: 1
    t.string "radiologist_code", limit: 10
    t.datetime "xray_testdone_date"
    t.string "xray_notdone_ind", limit: 1
    t.string "xray_ref_no", limit: 20
    t.decimal "appeal_id", precision: 10
    t.decimal "retake_id", precision: 10
    t.decimal "pool_id", precision: 19
    t.datetime "creation_date"
    t.string "creator_id", limit: 20
    t.datetime "modify_date"
    t.string "modify_id", limit: 20
    t.decimal "retake_pool_id", precision: 19
    t.string "provider_id", limit: 3
    t.string "xray_upload_status", limit: 3
    t.index ["trans_id"], name: "idx_fwt_shadow_on_trans_id"
  end

  create_table "fwt_update_tcupi", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.string "old_fit_ind", limit: 1
    t.string "new_fit_ind", limit: 1
    t.string "old_tcupi_ind", limit: 1
    t.string "new_tcupi_ind", limit: 1
    t.datetime "mod_date"
    t.string "status", limit: 1
    t.index ["trans_id"], name: "idx_fwt_update_tcupi_on_trans_id"
  end

  create_table "fwt_xray_unmatch", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "bc_worker_code", limit: 14
    t.string "bc_xray_code", limit: 14
    t.string "xray_code", limit: 14
    t.decimal "modify_id"
    t.datetime "modification_date"
    t.decimal "version_no"
    t.index ["trans_id"], name: "idx_fwt_xray_unmatch_on_trans_id"
  end

  create_table "group_details", id: false, force: :cascade do |t|
    t.string "group_code", limit: 6
    t.string "group_name", limit: 50
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 100
    t.string "fax", limit: 100
    t.string "district_name", limit: 40
    t.string "state_name", limit: 15
  end

  create_table "group_doctor_pay", id: false, force: :cascade do |t|
    t.string "group_code", limit: 6
    t.string "pay_ind", limit: 1
    t.string "doctor_code", limit: 10
    t.string "group_status", limit: 1
    t.datetime "create_date"
  end

  create_table "group_doctor_pay_history", id: false, force: :cascade do |t|
    t.string "group_code", limit: 6
    t.string "doctor_code", limit: 10
    t.string "group_status", limit: 1
    t.datetime "create_date"
    t.string "action", limit: 6
    t.datetime "action_date"
    t.index ["doctor_code"], name: "idx_group_doctor_pay_history_on_doctor_code"
    t.index ["group_code"], name: "idx_group_doctor_pay_history_on_group_code"
  end

  create_table "group_worker", id: false, force: :cascade do |t|
    t.string "passport", limit: 20
    t.string "country", limit: 3
    t.datetime "creation_date"
    t.string "name", limit: 60
    t.string "sex", limit: 1
    t.datetime "modify_date"
    t.string "status", limit: 1
  end

  create_table "group_xray_pay", id: false, force: :cascade do |t|
    t.string "group_code", limit: 6
    t.string "pay_ind", limit: 1
    t.string "xray_code", limit: 10
    t.string "group_status", limit: 1
    t.datetime "create_date"
  end

  create_table "group_xray_pay_history", id: false, force: :cascade do |t|
    t.string "group_code", limit: 6
    t.string "pay_ind", limit: 1
    t.string "xray_code", limit: 10
    t.string "group_status", limit: 1
    t.datetime "create_date"
    t.string "action", limit: 6
    t.datetime "action_date"
    t.index ["group_code"], name: "idx_group_xray_pay_history_on_group_code"
    t.index ["xray_code"], name: "idx_group_xray_pay_history_on_xray_code"
  end

  create_table "icon_master", id: false, force: :cascade do |t|
    t.decimal "iconid", precision: 10
    t.decimal "parenticonid", precision: 10
    t.string "isfolder", limit: 5
    t.string "icondesc", limit: 255
    t.decimal "capid", precision: 10
    t.decimal "identifier", precision: 10
    t.string "imagefile1", limit: 50
    t.string "imagefile2", limit: 50
    t.string "contextname", limit: 50
    t.string "indexpage", limit: 50
    t.string "parameter", limit: 200
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "imm_block_workers", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
  end

  create_table "imm_med_receive", id: false, force: :cascade do |t|
    t.string "jim_doc_no", limit: 20
    t.string "jim_nat", limit: 3
    t.datetime "jim_dob"
    t.string "jim_name", limit: 60
    t.string "jim_sex", limit: 1
    t.string "jim_medsts", limit: 1
    t.datetime "jim_meddt"
    t.string "jim_respond_flag", limit: 1
    t.string "jim_respond", limit: 50
    t.datetime "jim_receive"
  end

  create_table "imm_med_send", id: false, force: :cascade do |t|
    t.string "imm_doc_no", limit: 15
    t.string "imm_nat", limit: 3
    t.datetime "imm_dob"
    t.string "imm_name", limit: 60
    t.string "imm_sex", limit: 1
    t.string "imm_medsts", limit: 1
    t.datetime "imm_meddt"
    t.datetime "imm_moddt"
    t.string "imm_send", limit: 1
  end

  create_table "inactive_doctors", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.datetime "date_of_inactive"
    t.string "reason", limit: 500
  end

  create_table "ind_master", id: false, force: :cascade do |t|
    t.string "ind", limit: 1
    t.string "req_type", limit: 2
  end

  create_table "invoice_detail", id: false, force: :cascade do |t|
    t.string "invoice_no", limit: 20
    t.string "service_provider_code", limit: 10
    t.string "trans_id", limit: 14
    t.string "member_code", limit: 10
    t.string "sex", limit: 1
    t.string "creator_id", limit: 20
    t.datetime "creation_date"
    t.string "modify_id", limit: 20
    t.datetime "modification_date"
    t.index ["trans_id"], name: "idx_invoice_detail_on_trans_id"
  end

  create_table "invoice_master", id: false, force: :cascade do |t|
    t.string "invoice_no", limit: 20
    t.string "service_provider_code", limit: 10
    t.string "status", limit: 1
    t.decimal "bill_amount", precision: 10, scale: 2
    t.decimal "gst_amount", precision: 10, scale: 2
    t.decimal "invoice_amount", precision: 10, scale: 2
    t.decimal "invoice_rounding_amount", precision: 10, scale: 2
    t.string "group_invoice", limit: 1
    t.decimal "service_providers_group_id"
    t.decimal "male_rate", precision: 126
    t.decimal "female_rate", precision: 126
    t.string "gst_code", limit: 20
    t.decimal "gst_tax", precision: 126
    t.decimal "gst_type", precision: 10
    t.string "creator_id", limit: 20
    t.datetime "creation_date"
    t.string "modify_id", limit: 20
    t.datetime "modification_date"
    t.decimal "batch_number"
    t.index ["gst_code"], name: "idx_invoice_master_on_gst_code"
    t.index ["service_provider_code"], name: "idx_invoice_master_on_service_provider_code"
  end

  create_table "jobtype_master", id: false, force: :cascade do |t|
    t.string "job_type", limit: 40
    t.string "description", limit: 255
    t.string "status_code", limit: 5
    t.index ["status_code"], name: "idx_jobtype_master_on_status_code"
  end

  create_table "lab_change_request", id: false, force: :cascade do |t|
    t.decimal "lab_cr_id", precision: 10
    t.string "lab_code", limit: 10
    t.datetime "request_date"
    t.string "request_comment", limit: 1000
    t.string "status", limit: 20
    t.decimal "approvedby", precision: 10
    t.datetime "approved_date"
    t.string "approved_comment", limit: 1000
    t.decimal "createby", precision: 10
    t.datetime "createdate"
    t.decimal "modifyby", precision: 10
    t.datetime "modifydate"
  end

  create_table "lab_change_request_detail", id: false, force: :cascade do |t|
    t.decimal "lab_cr_id", precision: 10
    t.string "cr_column", limit: 100
    t.string "cr_old", limit: 100
    t.string "cr_new", limit: 100
  end

  create_table "lab_payment", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "lab_code", limit: 10
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.string "sex", limit: 1
    t.datetime "transdate"
    t.datetime "certify_date"
    t.index ["trans_id"], name: "idx_lab_payment_on_trans_id"
  end

  create_table "lab_rates_master", id: false, force: :cascade do |t|
    t.string "lab_code", limit: 10
    t.decimal "male", precision: 6, scale: 2
    t.decimal "female", precision: 6, scale: 2
    t.index ["lab_code"], name: "idx_lab_rates_master_on_lab_code"
  end

  create_table "laboratory_group", id: false, force: :cascade do |t|
    t.string "lab_group", limit: 2
    t.string "description", limit: 255
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "laboratory_history", id: false, force: :cascade do |t|
    t.string "laboratory_code", limit: 10
    t.string "version_no", limit: 10
    t.datetime "creation_date"
    t.string "laboratory_name", limit: 50
    t.string "registration_no", limit: 20
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 100
    t.string "fax", limit: 100
    t.string "state_code", limit: 7
    t.string "district_code", limit: 7
    t.string "country_code", limit: 3
    t.string "email_id", limit: 100
    t.string "primary_contact_person", limit: 50
    t.string "primary_contact_phone", limit: 20
    t.string "lab_type", limit: 1
    t.string "qualification", limit: 50
    t.string "comments", limit: 4000
    t.string "district_name", limit: 40
    t.datetime "modification_date"
    t.string "bc_laboratory_code", limit: 13
    t.string "status_code", limit: 5
    t.string "nearest_district_office", limit: 7
    t.string "classification", limit: 5
    t.decimal "creator_id", precision: 10
    t.decimal "modify_id", precision: 10
    t.string "lab_group", limit: 2
    t.decimal "grade_point", precision: 3
    t.string "license", limit: 20
    t.string "license_year", limit: 4
    t.decimal "lregid", precision: 10
    t.string "action", limit: 10
    t.datetime "action_date"
    t.string "web_service_access", limit: 1
    t.string "passphrase", limit: 100
    t.string "mobile_no", limit: 20
    t.datetime "renewal_date"
    t.string "gst_code", limit: 20
    t.decimal "gst_tax", precision: 126
    t.decimal "male_rate", precision: 126
    t.decimal "female_rate", precision: 126
    t.string "bank_account_no", limit: 20
    t.string "laboratory_logo", limit: 50
    t.decimal "web_taxinvoice", precision: 1
    t.string "bank_code", limit: 8
    t.decimal "gst_type", precision: 1
    t.datetime "gst_effective_date"
    t.index ["bank_code"], name: "idx_laboratory_history_on_bank_code"
    t.index ["bc_laboratory_code"], name: "idx_laboratory_history_on_bc_laboratory_code"
    t.index ["country_code"], name: "idx_laboratory_history_on_country_code"
    t.index ["district_code"], name: "idx_laboratory_history_on_district_code"
    t.index ["gst_code"], name: "idx_laboratory_history_on_gst_code"
    t.index ["laboratory_code"], name: "idx_laboratory_history_on_laboratory_code"
    t.index ["post_code"], name: "idx_laboratory_history_on_post_code"
    t.index ["state_code"], name: "idx_laboratory_history_on_state_code"
    t.index ["status_code"], name: "idx_laboratory_history_on_status_code"
  end

  create_table "laboratory_master", id: false, force: :cascade do |t|
    t.string "laboratory_code", limit: 10
    t.string "laboratory_name", limit: 50
    t.datetime "creation_date"
    t.string "registration_no", limit: 20
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 100
    t.string "fax", limit: 100
    t.string "state_code", limit: 7
    t.string "district_code", limit: 7
    t.string "country_code", limit: 3
    t.string "email_id", limit: 100
    t.string "primary_contact_person", limit: 50
    t.string "primary_contact_phone", limit: 20
    t.string "lab_type", limit: 1
    t.string "version_no", limit: 10
    t.string "qualification", limit: 50
    t.string "status_code", limit: 5
    t.string "comments", limit: 4000
    t.string "bc_laboratory_code", limit: 13
    t.string "nearest_district_office", limit: 7
    t.string "classification", limit: 5
    t.decimal "creator_id", precision: 10
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "lab_group", limit: 2
    t.decimal "grade_point", precision: 3
    t.string "license", limit: 20
    t.string "license_year", limit: 4
    t.decimal "lregid", precision: 10
    t.string "web_service_access", limit: 1
    t.string "passphrase", limit: 100
    t.string "gst_code", limit: 20
    t.decimal "gst_tax", precision: 126
    t.decimal "male_rate", precision: 126
    t.decimal "female_rate", precision: 126
    t.string "bank_account_no", limit: 20
    t.decimal "gst_type", precision: 10
    t.string "bank_code", limit: 8
    t.string "laboratory_logo", limit: 50
    t.decimal "web_taxinvoice", precision: 1
    t.string "mobile_no", limit: 20
    t.datetime "renewal_date"
    t.datetime "gst_effective_date"
    t.index ["bank_code"], name: "idx_laboratory_master_on_bank_code"
    t.index ["bc_laboratory_code"], name: "idx_laboratory_master_on_bc_laboratory_code"
    t.index ["country_code"], name: "idx_laboratory_master_on_country_code"
    t.index ["district_code"], name: "idx_laboratory_master_on_district_code"
    t.index ["gst_code"], name: "idx_laboratory_master_on_gst_code"
    t.index ["laboratory_code"], name: "idx_laboratory_master_on_laboratory_code"
    t.index ["post_code"], name: "idx_laboratory_master_on_post_code"
    t.index ["state_code"], name: "idx_laboratory_master_on_state_code"
    t.index ["status_code"], name: "idx_laboratory_master_on_status_code"
  end

  create_table "laboratory_registration", id: false, force: :cascade do |t|
    t.decimal "lregid", precision: 10
    t.string "laboratory_name", limit: 50
    t.string "registration_no", limit: 20
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 25
    t.string "fax", limit: 25
    t.string "state_code", limit: 7
    t.string "district_code", limit: 7
    t.string "country_code", limit: 3
    t.string "email_id", limit: 100
    t.string "primary_contact_person", limit: 50
    t.string "primary_contact_phone", limit: 20
    t.string "lab_type", limit: 1
    t.string "lab_group", limit: 2
    t.string "qualification", limit: 50
    t.string "status_code", limit: 5
    t.string "comments", limit: 4000
    t.string "tranno", limit: 10
    t.string "license", limit: 20
    t.string "license_year", limit: 4
    t.string "nearest_district_office", limit: 7
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "laboratory_request", id: false, force: :cascade do |t|
    t.decimal "lregid", precision: 10
    t.decimal "approval_id", precision: 10
    t.string "status", limit: 5
    t.string "comments", limit: 4000
    t.datetime "modification_date"
  end

  create_table "labuan_g_workers", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "created_by", limit: 30
    t.datetime "transdate"
    t.string "trans_id", limit: 14
    t.index ["trans_id"], name: "idx_labuan_g_workers_on_trans_id"
  end

  create_table "labws_applicationid", id: false, force: :cascade do |t|
    t.string "appid", limit: 3
    t.string "active", limit: 1
    t.string "description", limit: 255
  end

  create_table "last_monitor", id: false, force: :cascade do |t|
    t.string "monitor_type", limit: 50
    t.datetime "last_run"
    t.datetime "last_start"
  end

  create_table "last_rev_sync", id: false, force: :cascade do |t|
    t.string "table_name", limit: 100
    t.datetime "sync_start"
    t.datetime "sync_end"
  end

  create_table "last_sync", id: false, force: :cascade do |t|
    t.string "table_name", limit: 100
    t.datetime "sync_start"
    t.datetime "sync_end"
  end

  create_table "letter_monitor", id: false, force: :cascade do |t|
    t.decimal "id"
    t.string "report_id", limit: 20
    t.string "sp_type", limit: 2
    t.string "sp_code", limit: 10
    t.string "sp_name", limit: 50
    t.string "state_code", limit: 20
    t.string "reference_no", limit: 20
    t.string "visit_letter", limit: 2
    t.datetime "visit_date"
    t.string "prepared_by", limit: 20
    t.datetime "creation_date"
    t.string "creator_id", limit: 20
    t.datetime "modify_date"
    t.string "modify_id", limit: 20
    t.string "sp_code2", limit: 10
    t.string "report_id2", limit: 20
  end

  create_table "letter_monitor_detail", id: false, force: :cascade do |t|
    t.decimal "letter_monitor_id"
    t.string "nc_letter", limit: 2
    t.datetime "nc_date"
    t.string "reminder_letter", limit: 2
    t.datetime "reminder_date"
    t.string "reply_letter", limit: 2
    t.datetime "reply_date"
    t.string "mspd_letter", limit: 2
    t.datetime "mspd_date"
    t.string "mspc_letter", limit: 2
    t.datetime "mspc_date"
    t.string "reprimand_letter", limit: 2
    t.datetime "reprimand_date"
    t.string "suspension_letter", limit: 2
    t.datetime "suspension_date"
    t.string "other_letter", limit: 2
    t.datetime "other_date"
    t.string "remarks", limit: 4000
    t.string "id", limit: 20
    t.string "status", limit: 20
  end

  create_table "load_info", id: false, force: :cascade do |t|
    t.datetime "last_exam_date"
    t.string "passport_no", limit: 20
    t.string "fit_ind", limit: 1
    t.datetime "arrival_date"
  end

  create_table "log_master_arc", id: false, force: :cascade do |t|
    t.decimal "uuid", precision: 10
    t.string "ip", limit: 20
    t.decimal "moduleid", precision: 10
    t.decimal "pageid", precision: 10
    t.string "action", limit: 4000
    t.string "action_type", limit: 5
    t.datetime "logdate"
  end

  create_table "lqcc_comments", id: false, force: :cascade do |t|
    t.decimal "lq_commentid", precision: 10
    t.decimal "lqccid", precision: 10
    t.string "comments", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "lqcc_report", id: false, force: :cascade do |t|
    t.decimal "lqccid", precision: 10
    t.string "reference_no", limit: 20
    t.string "trans_id", limit: 14
    t.string "bc_laboratory_code", limit: 13
    t.string "bc_worker_code", limit: 13
    t.datetime "date_received"
    t.string "isquestionable", limit: 5
    t.datetime "date_questionable"
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.index ["trans_id"], name: "idx_lqcc_report_on_trans_id"
  end

  create_table "maxigrid", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "bc_worker_code", limit: 13
    t.string "sex", limit: 1
    t.string "bank_code", limit: 8
    t.string "status", limit: 5
    t.datetime "date_issued"
    t.datetime "date_imported"
    t.datetime "certify_date"
    t.string "bc_doctor_code", limit: 13
    t.decimal "doctor_amount", precision: 10, scale: 2
    t.string "doctor_cheque", limit: 20
    t.string "bc_xray_code", limit: 13
    t.decimal "xray_amount", precision: 10, scale: 2
    t.string "xray_cheque", limit: 20
    t.string "bc_lab_code", limit: 13
    t.decimal "lab_amount", precision: 10, scale: 2
    t.string "lab_cheque", limit: 20
    t.index ["trans_id"], name: "idx_maxigrid_on_trans_id"
  end

  create_table "merts_doc_startpage_stats", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.decimal "delayed_transmission"
    t.decimal "delayed_transmission_14"
    t.decimal "delayed_certification"
    t.decimal "delayed_certification_2"
    t.decimal "delayed_appeal"
    t.decimal "delayed_appeal_21"
    t.decimal "delayed_review"
    t.decimal "delayed_review_14"
    t.datetime "last_updated"
  end

  create_table "merts_lab_startpage_stats", id: false, force: :cascade do |t|
    t.string "lab_code", limit: 10
    t.decimal "delayed_transmission"
    t.datetime "last_updated"
  end

  create_table "merts_xray_startpage_stats", id: false, force: :cascade do |t|
    t.string "xray_code", limit: 10
    t.decimal "delayed_transmission"
    t.decimal "film_notyet_send"
    t.datetime "last_updated"
  end

  create_table "migrations", id: :serial, force: :cascade do |t|
    t.string "migration", limit: 255, null: false
    t.integer "batch", null: false
  end

  create_table "missing_payment", id: false, force: :cascade do |t|
    t.decimal "missingpayment_id"
    t.string "reporter_name", limit: 100
    t.string "reporter_contact", limit: 30
    t.string "reporter_icpassport", limit: 20
    t.string "police_reportno", limit: 30
    t.string "document_no", limit: 20
    t.string "bank_code", limit: 8
    t.datetime "issue_date"
    t.decimal "amount", precision: 10, scale: 2
    t.string "place_of_issue", limit: 50
    t.string "name_on_card", limit: 100
    t.datetime "expiry_date"
    t.string "status", limit: 1
    t.string "insertion_comments", limit: 4000
    t.string "creator_id", limit: 20
    t.datetime "creation_date"
    t.string "removal_comments", limit: 4000
    t.string "modify_id", limit: 20
    t.datetime "modify_date"
    t.string "payment_type", limit: 255
  end

  create_table "module_master", id: false, force: :cascade do |t|
    t.decimal "moduleid", precision: 10
    t.string "modulename", limit: 50
    t.string "description", limit: 255
    t.decimal "capid", precision: 10
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "module_page", id: false, force: :cascade do |t|
    t.decimal "pageid", precision: 10
    t.decimal "moduleid", precision: 10
    t.string "filename", limit: 50
    t.string "description", limit: 255
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "moh_doc_report", id: false, force: :cascade do |t|
    t.string "state_name", limit: 20
    t.decimal "slab0", precision: 6
    t.decimal "slab20", precision: 6
    t.decimal "slab50", precision: 6
    t.decimal "slab100", precision: 6
    t.decimal "slab200", precision: 6
    t.decimal "slab300", precision: 6
    t.decimal "slab400", precision: 6
    t.decimal "slab500", precision: 6
    t.decimal "slab600", precision: 6
    t.decimal "slab700", precision: 6
    t.decimal "slab800", precision: 6
    t.decimal "slab900", precision: 6
    t.decimal "slab1000", precision: 6
    t.decimal "slab1kplus", precision: 6
  end

  create_table "moh_doc_stat", id: false, force: :cascade do |t|
    t.string "state_name", limit: 20
    t.decimal "slab0", precision: 6
    t.decimal "slab20", precision: 6
    t.decimal "slab50", precision: 6
    t.decimal "slab100", precision: 6
    t.decimal "slab200", precision: 6
    t.decimal "slab300", precision: 6
    t.decimal "slab400", precision: 6
    t.decimal "slab500", precision: 6
    t.decimal "slab600", precision: 6
    t.decimal "slab700", precision: 6
    t.decimal "slab800", precision: 6
    t.decimal "slab900", precision: 6
    t.decimal "slab1000", precision: 6
    t.decimal "slab1kplus", precision: 6
  end

  create_table "moh_master_quota", id: false, force: :cascade do |t|
    t.string "quota_type", limit: 20
    t.string "apply_to", limit: 10
    t.decimal "quota"
    t.string "comments", limit: 255
  end

  create_table "monitor_exam", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "trans_id", limit: 14
    t.string "issue_letter_ind", limit: 1
    t.datetime "issue_date"
    t.datetime "ins_date"
    t.index ["trans_id"], name: "idx_monitor_exam_on_trans_id"
  end

  create_table "monitoring", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 30
    t.string "passport_no", limit: 10
    t.datetime "renewal_date"
    t.datetime "certify_date"
    t.string "status", limit: 5
    t.string "remarks", limit: 200
  end

  create_table "myimms_country_master", id: false, force: :cascade do |t|
    t.string "nios_country_code", limit: 3
    t.string "myimms_country_code", limit: 3
    t.string "country_name", limit: 100
    t.index ["myimms_country_code"], name: "idx_myimms_country_master_on_myimms_country_code"
    t.index ["nios_country_code"], name: "idx_myimms_country_master_on_nios_country_code"
  end

  create_table "myimms_mon_tcupi", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "passport_no", limit: 15
    t.index ["trans_id"], name: "idx_myimms_mon_tcupi_on_trans_id"
  end

  create_table "myimms_queue", id: false, force: :cascade do |t|
    t.decimal "batch_num"
    t.string "trans_id", limit: 14
    t.string "passport_no", limit: 20
    t.string "nationality", limit: 3
    t.string "date_of_birth", limit: 8
    t.string "name", limit: 150
    t.string "sex", limit: 1
    t.string "exam_date", limit: 8
    t.string "medical_status", limit: 1
    t.datetime "modify_date"
    t.string "is_labuan", limit: 1
    t.datetime "queue_date"
    t.string "queue_op", limit: 1
    t.string "queue_by", limit: 50
    t.string "myimms_reply", limit: 1
    t.string "myimms_error", limit: 255
    t.datetime "reply_date"
    t.index ["trans_id"], name: "idx_myimms_queue_on_trans_id"
  end

  create_table "myimms_queue_hist", id: false, force: :cascade do |t|
    t.decimal "batch_num"
    t.string "trans_id", limit: 14
    t.string "passport_no", limit: 20
    t.string "nationality", limit: 3
    t.string "date_of_birth", limit: 8
    t.string "name", limit: 150
    t.string "sex", limit: 1
    t.string "exam_date", limit: 8
    t.string "medical_status", limit: 1
    t.datetime "modify_date"
    t.string "is_labuan", limit: 1
    t.datetime "queue_date"
    t.string "queue_op", limit: 1
    t.string "queue_by", limit: 50
    t.string "myimms_reply", limit: 1
    t.string "myimms_error", limit: 255
    t.datetime "reply_date"
    t.datetime "action_date"
    t.index ["trans_id"], name: "idx_myimms_queue_hist_on_trans_id"
  end

  create_table "new_arri", id: false, force: :cascade do |t|
    t.datetime "regn_date"
    t.string "old_clinic", limit: 70
    t.string "new_clinic", limit: 50
    t.string "doctor_code", limit: 10
    t.string "worker_code", limit: 10
    t.string "country_name", limit: 50
    t.string "fitness", limit: 1
  end

  create_table "nios_lab_payment", id: false, force: :cascade do |t|
    t.string "laboratory_code", limit: 10
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.string "sex", limit: 1
    t.datetime "transdate"
    t.datetime "certify_date"
  end

  create_table "nios_setting", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.datetime "create_date"
    t.decimal "creator_id", precision: 10
    t.string "description", limit: 400
    t.string "parameter", limit: 120
    t.string "value", limit: 200
  end

  create_table "non_transmission", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.string "worker_code", limit: 10
    t.datetime "exam_date"
    t.datetime "lab_specimen_date"
    t.datetime "lab_submit_date"
    t.datetime "xray_testdone_date"
    t.datetime "xray_submit_date"
    t.string "transid", limit: 14
    t.datetime "start_date"
    t.decimal "duration", precision: 10
  end

  create_table "notification", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "trans_id", limit: 14
    t.datetime "certify_date"
    t.datetime "transdate"
    t.datetime "creation_date"
    t.string "disease", limit: 8
    t.string "release_flag", limit: 1
    t.datetime "action_date"
    t.string "created_by", limit: 20
    t.string "unknown", limit: 1
    t.string "worker_name", limit: 50
    t.index ["trans_id"], name: "idx_notification_on_trans_id"
  end

  create_table "operation_comments", id: false, force: :cascade do |t|
    t.decimal "commentid", precision: 10
    t.string "bc_user_code", limit: 13
    t.string "category", limit: 5
    t.string "comments", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "oracle_columns", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.datetime "updated_at", precision: 0
    t.integer "table_id", null: false
    t.string "owner", limit: 255, null: false
    t.string "table_name", limit: 255, null: false
    t.string "column_name", limit: 255, null: false
    t.string "data_type", limit: 255, null: false
    t.integer "data_length"
    t.integer "data_precision"
    t.integer "data_scale"
    t.integer "column_id"
    t.boolean "need_migrate", default: true, null: false
    t.text "remark"
    t.boolean "need_index", default: false, null: false
    t.index ["column_name"], name: "oracle_columns_column_name_index"
    t.index ["owner"], name: "oracle_columns_owner_index"
    t.index ["table_name"], name: "oracle_columns_table_name_index"
  end

  create_table "oracle_tables", force: :cascade do |t|
    t.datetime "created_at", precision: 0
    t.datetime "updated_at", precision: 0
    t.string "owner", limit: 255, null: false
    t.string "table_name", limit: 255, null: false
    t.integer "num_rows"
    t.boolean "need_migrate", default: true, null: false
    t.text "remark"
    t.bigint "bytes", default: 0, null: false
    t.index ["owner"], name: "oracle_tables_owner_index"
    t.index ["table_name"], name: "oracle_tables_table_name_index"
  end

  create_table "password_resets", id: false, force: :cascade do |t|
    t.string "email", limit: 255, null: false
    t.string "token", limit: 255, null: false
    t.datetime "created_at", precision: 0
    t.index ["email"], name: "password_resets_email_index"
  end

  create_table "pati_renew", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.datetime "transdate"
    t.decimal "reg_ind"
    t.index ["trans_id"], name: "idx_pati_renew_on_trans_id"
  end

  create_table "pay_trans_manual", id: false, force: :cascade do |t|
    t.decimal "id"
    t.string "sp_code", limit: 10
    t.string "trans_id", limit: 14
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.decimal "amount", precision: 6
    t.string "sp_type", limit: 1
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.string "sex", limit: 1
    t.datetime "payment_date"
    t.index ["trans_id"], name: "idx_pay_trans_manual_on_trans_id"
  end

  create_table "pay_transaction", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.string "doctor_code", limit: 10
    t.string "name", limit: 50
    t.datetime "certify_date"
    t.decimal "doc_amount", precision: 6
    t.decimal "doc_ded", precision: 3
    t.string "xray_code", limit: 10
    t.decimal "xray_amount", precision: 6
    t.decimal "xray_ded", precision: 3
    t.string "doc_pb_ind", limit: 1
    t.string "xray_pb_ind", limit: 1
    t.datetime "doc_pb_date"
    t.datetime "xray_pb_date"
    t.datetime "doc_unb_date"
    t.datetime "xray_unb_date"
    t.string "sex", limit: 1
    t.index ["trans_id"], name: "idx_pay_transaction_on_trans_id"
  end

  create_table "payment", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "amount", precision: 126
    t.string "bank_account_no", limit: 80
    t.string "bank_code", limit: 32
    t.datetime "certify_date"
    t.datetime "create_date"
    t.string "creator_id", limit: 40
    t.string "reference_id", limit: 1020
    t.datetime "request_date"
    t.string "sp_code", limit: 40
    t.string "sp_type", limit: 4
    t.decimal "trans_type", precision: 10
    t.string "gst_code", limit: 80
    t.decimal "gst_tax", precision: 126
    t.datetime "invoice_date"
    t.string "invoice_no", limit: 120
    t.decimal "gst_type", precision: 1
    t.string "service_provider_group_id", limit: 30
    t.decimal "gstamount", precision: 126
    t.decimal "fin_batch_no"
  end

  create_table "payment_method", id: false, force: :cascade do |t|
    t.decimal "payment_type", precision: 4
    t.string "description", limit: 255
    t.string "service_type", limit: 2
    t.decimal "status", precision: 1
    t.decimal "isfoc"
    t.decimal "surcharge", precision: 126
  end

  create_table "payment_refund", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "amount", precision: 126
    t.decimal "ap_group_id", precision: 19
    t.string "old_bank_account_no", limit: 80
    t.string "old_bank_code", limit: 32
    t.string "branch_code", limit: 8
    t.string "old_company_regno", limit: 60
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.string "old_email_id", limit: 400
    t.string "employer_code", limit: 40
    t.string "old_ic_no", limit: 80
    t.datetime "modification_date"
    t.decimal "modify_id", precision: 10
    t.decimal "refund_method", precision: 10
    t.decimal "status", precision: 10
    t.decimal "gst_amount", precision: 126
    t.string "old_bank_account_holder_name", limit: 50
    t.decimal "refund_fee", precision: 126
    t.decimal "refund_type", precision: 10
    t.decimal "payment_type", precision: 10
    t.datetime "payment_date"
    t.string "reference_no", limit: 50
    t.string "comments", limit: 255
    t.string "new_bank_account_no", limit: 80
    t.string "new_bank_code", limit: 32
    t.string "new_bank_account_holder_name", limit: 50
    t.string "new_company_regno", limit: 60
    t.string "new_email_id", limit: 400
    t.string "new_ic_no", limit: 20
    t.decimal "finance_id", precision: 10
    t.datetime "finance_approve_date"
  end

  create_table "payment_refund_approval", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "approval_id", precision: 10
    t.string "approve_status", limit: 1020
    t.string "comments", limit: 1600
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.datetime "modification_date"
    t.decimal "modify_id", precision: 10
    t.decimal "refund_id", precision: 19
  end

  create_table "payment_reject", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.string "reject_code", limit: 5
    t.string "reference_id", limit: 20
    t.string "service_provider", limit: 1500
    t.string "group_pay", limit: 1
    t.decimal "payable_amount", precision: 126
    t.decimal "gst_amount", precision: 126
    t.decimal "isread"
    t.datetime "read_date"
    t.string "creator_id", limit: 7
    t.datetime "create_date"
    t.string "modify_id", limit: 7
    t.datetime "modification_date"
    t.decimal "type", precision: 19
    t.string "employer_code", limit: 10
  end

  create_table "payment_reject_log", id: false, force: :cascade do |t|
    t.decimal "log_id", precision: 19
    t.decimal "payment_reject_id", precision: 19
    t.datetime "logdate"
    t.decimal "err#", precision: 6
    t.string "errm", limit: 250
    t.string "msg", limit: 250
    t.decimal "status", precision: 1
  end

  create_table "payment_req", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "amount", precision: 126
    t.string "branch_code", limit: 8
    t.datetime "certify_date"
    t.datetime "create_date"
    t.string "creator_id", limit: 40
    t.datetime "request_date"
    t.string "sp_code", limit: 40
    t.string "sp_type", limit: 4
    t.decimal "status", precision: 10
    t.decimal "trans_type", precision: 10
    t.string "transid", limit: 56
    t.string "invoice_no", limit: 20
    t.datetime "invoice_date"
    t.decimal "gst_tax", precision: 3, scale: 2
    t.string "gst_code", limit: 20
    t.string "service_provider_group_id", limit: 120
    t.decimal "gst_type", precision: 1
    t.string "service_provider_code", limit: 10
    t.decimal "gstamount", precision: 126
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.string "sex", limit: 1
    t.decimal "fin_batch_no"
  end

  create_table "payment_req_history", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "amount", precision: 126
    t.string "branch_code", limit: 8
    t.datetime "certify_date"
    t.datetime "create_date"
    t.string "creator_id", limit: 40
    t.decimal "fin_batch_no", precision: 10
    t.string "gst_code", limit: 80
    t.decimal "gst_tax", precision: 126
    t.decimal "gst_type", precision: 10
    t.decimal "gstamount", precision: 126
    t.datetime "invoice_date"
    t.string "invoice_no", limit: 120
    t.decimal "payment_req_id", precision: 10
    t.string "reference_id", limit: 1020
    t.datetime "request_date"
    t.string "service_provider_code", limit: 40
    t.string "service_provider_group_id", limit: 120
    t.string "sex", limit: 4
    t.string "sp_code", limit: 40
    t.string "sp_type", limit: 4
    t.decimal "status", precision: 10
    t.decimal "trans_type", precision: 10
    t.string "transid", limit: 56
    t.string "worker_code", limit: 40
    t.string "worker_name", limit: 200
    t.decimal "isread"
    t.datetime "read_date"
    t.string "read_by", limit: 7
    t.index ["branch_code"], name: "idx_payment_req_history_on_branch_code"
    t.index ["gst_code"], name: "idx_payment_req_history_on_gst_code"
    t.index ["service_provider_code"], name: "idx_payment_req_history_on_service_provider_code"
    t.index ["sp_code"], name: "idx_payment_req_history_on_sp_code"
    t.index ["worker_code"], name: "idx_payment_req_history_on_worker_code"
  end

  create_table "payment_status", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "doctor_code", limit: 10
    t.string "doc_pay_ind", limit: 1
    t.datetime "doctor_paid"
    t.string "xray_code", limit: 10
    t.string "xray_pay_ind", limit: 1
    t.datetime "xray_paid"
    t.string "lab_code", limit: 10
    t.string "lab_pay_ind", limit: 1
    t.datetime "lab_paid"
    t.datetime "certify_date"
    t.index ["trans_id"], name: "idx_payment_status_on_trans_id"
  end

  create_table "pbcatcol", id: false, force: :cascade do |t|
    t.string "pbc_tnam", limit: 30
    t.decimal "pbc_tid"
    t.string "pbc_ownr", limit: 30
    t.string "pbc_cnam", limit: 30
    t.decimal "pbc_cid"
    t.string "pbc_labl", limit: 254
    t.decimal "pbc_lpos"
    t.string "pbc_hdr", limit: 254
    t.decimal "pbc_hpos"
    t.decimal "pbc_jtfy"
    t.string "pbc_mask", limit: 31
    t.decimal "pbc_case"
    t.decimal "pbc_hght"
    t.decimal "pbc_wdth"
    t.string "pbc_ptrn", limit: 31
    t.string "pbc_bmap", limit: 1
    t.string "pbc_init", limit: 254
    t.string "pbc_cmnt", limit: 254
    t.string "pbc_edit", limit: 31
    t.string "pbc_tag", limit: 254
  end

  create_table "pbcatedt", id: false, force: :cascade do |t|
    t.string "pbe_name", limit: 30
    t.string "pbe_edit", limit: 254
    t.decimal "pbe_type"
    t.decimal "pbe_cntr"
    t.decimal "pbe_seqn"
    t.decimal "pbe_flag"
    t.string "pbe_work", limit: 32
  end

  create_table "pbcatfmt", id: false, force: :cascade do |t|
    t.string "pbf_name", limit: 30
    t.string "pbf_frmt", limit: 254
    t.decimal "pbf_type"
    t.decimal "pbf_cntr"
  end

  create_table "pbcattbl", id: false, force: :cascade do |t|
    t.string "pbt_tnam", limit: 30
    t.decimal "pbt_tid"
    t.string "pbt_ownr", limit: 30
    t.decimal "pbd_fhgt"
    t.decimal "pbd_fwgt"
    t.string "pbd_fitl", limit: 1
    t.string "pbd_funl", limit: 1
    t.decimal "pbd_fchr"
    t.decimal "pbd_fptc"
    t.string "pbd_ffce", limit: 18
    t.decimal "pbh_fhgt"
    t.decimal "pbh_fwgt"
    t.string "pbh_fitl", limit: 1
    t.string "pbh_funl", limit: 1
    t.decimal "pbh_fchr"
    t.decimal "pbh_fptc"
    t.string "pbh_ffce", limit: 18
    t.decimal "pbl_fhgt"
    t.decimal "pbl_fwgt"
    t.string "pbl_fitl", limit: 1
    t.string "pbl_funl", limit: 1
    t.decimal "pbl_fchr"
    t.decimal "pbl_fptc"
    t.string "pbl_ffce", limit: 18
    t.string "pbt_cmnt", limit: 254
  end

  create_table "pbcatvld", id: false, force: :cascade do |t|
    t.string "pbv_name", limit: 30
    t.string "pbv_vald", limit: 254
    t.decimal "pbv_type"
    t.decimal "pbv_cntr"
    t.string "pbv_msg", limit: 254
  end

  create_table "pcr_trans_comments", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "parameter_code", limit: 10
    t.string "comments", limit: 1000
    t.index ["trans_id"], name: "idx_pcr_trans_comments_on_trans_id"
  end

  create_table "pcr_trans_detail", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "parameter_code", limit: 10
    t.string "parameter_value", limit: 20
    t.index ["trans_id"], name: "idx_pcr_trans_detail_on_trans_id"
  end

  create_table "pcr_transaction", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 15
    t.string "radiologist_code", limit: 10
    t.string "xray_code", limit: 10
    t.string "worker_code", limit: 10
    t.datetime "date_sent2pcr"
    t.datetime "date_audited"
    t.string "audit_ind", limit: 1
    t.decimal "version_no"
    t.datetime "create_date"
    t.decimal "creator_id"
    t.datetime "modify_date"
    t.decimal "modify_id"
    t.decimal "pcr_trans_id"
    t.index ["trans_id"], name: "idx_pcr_transaction_on_trans_id"
  end

  create_table "pincode_req", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "approved_id", precision: 10
    t.string "branch_code", limit: 8
    t.datetime "creation_date"
    t.string "employer_code", limit: 40
    t.datetime "expired_time"
    t.datetime "modify_date"
    t.string "pin_code", limit: 40
    t.datetime "request_time"
    t.decimal "status", precision: 10
    t.decimal "uuid", precision: 10
  end

  create_table "ply_transaction", id: false, force: :cascade do |t|
    t.decimal "plyid", precision: 10
    t.string "tranno", limit: 10
    t.string "bc_worker_code", limit: 13
    t.string "trans_id", limit: 14
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.string "status", limit: 5
    t.string "employer_code", limit: 10
    t.index ["trans_id"], name: "idx_ply_transaction_on_trans_id"
  end

  create_table "ply_transaction_hist", id: false, force: :cascade do |t|
    t.decimal "plyid", precision: 10
    t.string "tranno", limit: 10
    t.string "bc_worker_code", limit: 13
    t.string "trans_id", limit: 14
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.string "status", limit: 5
    t.index ["trans_id"], name: "idx_ply_transaction_hist_on_trans_id"
  end

  create_table "post_master", id: false, force: :cascade do |t|
    t.string "district", limit: 100
    t.string "post_code", limit: 6
    t.string "post_office", limit: 100
    t.string "state", limit: 50
    t.index ["post_code"], name: "idx_post_master_on_post_code"
  end

  create_table "provider_history", id: false, force: :cascade do |t|
    t.string "service_provider", limit: 10
    t.datetime "action_date"
    t.string "old_status", limit: 5
    t.string "new_status", limit: 5
    t.string "old_state", limit: 7
    t.string "new_state", limit: 7
    t.string "action", limit: 20
  end

  create_table "quarantine_fw_doc", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "fw_code", limit: 13
    t.string "doc_code", limit: 13
    t.string "d1_hiv", limit: 1
    t.datetime "d1_hiv_date"
    t.string "d1_tb", limit: 1
    t.datetime "d1_tb_date"
    t.string "d1_leprosy", limit: 1
    t.datetime "d1_leprosy_date"
    t.string "d1_hepatitis", limit: 1
    t.datetime "d1_hepatitis_date"
    t.string "d1_psych", limit: 1
    t.datetime "d1_psych_date"
    t.string "d1_epilepsy", limit: 1
    t.datetime "d1_epilepsy_date"
    t.string "d1_cancer", limit: 1
    t.datetime "d1_cancer_date"
    t.string "d1_std", limit: 1
    t.datetime "d1_std_date"
    t.string "d1_malaria", limit: 1
    t.datetime "d1_malaria_date"
    t.string "d2_hypertension", limit: 1
    t.datetime "d2_hypertension_date"
    t.string "d2_heartdisease", limit: 1
    t.datetime "d2_heartdisease_date"
    t.string "d2_asthma", limit: 1
    t.datetime "d2_asthma_date"
    t.string "d2_diabetes", limit: 1
    t.datetime "d2_diabetes_date"
    t.string "d2_ulcer", limit: 1
    t.datetime "d2_ulcer_date"
    t.string "d2_kidney", limit: 1
    t.datetime "d2_kidney_date"
    t.string "d2_others", limit: 1
    t.datetime "d2_others_date"
    t.string "d2_comments", limit: 4000
    t.string "d3_heartsize", limit: 1
    t.string "d3_heartsound", limit: 1
    t.string "d3_othercardio", limit: 1
    t.string "d3_breathsound", limit: 1
    t.string "d3_otherrespiratory", limit: 1
    t.string "d3_liver", limit: 1
    t.string "d3_spleen", limit: 1
    t.string "d3_swelling", limit: 1
    t.string "d3_lymphnodes", limit: 1
    t.string "d3_rectal", limit: 1
    t.string "d4_mental", limit: 1
    t.string "d4_speech", limit: 1
    t.string "d4_cognitive", limit: 1
    t.string "d4_peripheralnerves", limit: 1
    t.string "d4_motorpower", limit: 1
    t.string "d4_sensory", limit: 1
    t.string "d4_reflexes", limit: 1
    t.string "d4_kidney", limit: 1
    t.string "d4_gendischarge", limit: 1
    t.string "d4_gensores", limit: 1
    t.string "d4_comments", limit: 4000
    t.decimal "d5_height", precision: 10, scale: 2
    t.decimal "d5_weight", precision: 10, scale: 2
    t.decimal "d5_pulse", precision: 10, scale: 2
    t.decimal "d5_systolic", precision: 10, scale: 2
    t.decimal "d5_diastolic", precision: 10, scale: 2
    t.string "d5_skinrash", limit: 1
    t.string "d5_skinpatch", limit: 1
    t.string "d5_deformities", limit: 1
    t.string "d5_anaemia", limit: 1
    t.string "d5_jaundice", limit: 1
    t.string "d5_enlargement", limit: 1
    t.string "d5_vision_unaidedleft", limit: 1
    t.string "d5_vision_unaidedright", limit: 1
    t.string "d5_vision_aidedleft", limit: 1
    t.string "d5_vision_aidedright", limit: 1
    t.string "d5_hearingleft", limit: 1
    t.string "d5_hearingright", limit: 1
    t.string "d5_others", limit: 1
    t.string "d5_comments", limit: 4000
    t.string "d6_hiv", limit: 1
    t.string "d6_tb", limit: 1
    t.string "d6_malaria", limit: 1
    t.string "d6_leprosy", limit: 1
    t.string "d6_std", limit: 1
    t.string "d6_hepatitis", limit: 1
    t.string "d6_cancer", limit: 1
    t.string "d6_epilepsy", limit: 1
    t.string "d6_psych", limit: 1
    t.string "d6_others", limit: 1
    t.string "d6_pregnant", limit: 1
    t.string "d6_opiates", limit: 1
    t.string "d6_cannabis", limit: 1
    t.string "d7_fw_medstatus", limit: 1
    t.string "d7_comments", limit: 4000
    t.string "d7_unfit_reason", limit: 4000
    t.string "d8_notifymoh", limit: 1
    t.datetime "d8_notifymoh_date"
    t.string "d8_refergh", limit: 1
    t.datetime "d8_refergh_date"
    t.string "d8_referph", limit: 1
    t.datetime "d8_referph_date"
    t.string "d8_treatpatient", limit: 1
    t.datetime "d8_treatpatient_date"
    t.string "d8_ongoingtreatment", limit: 1
    t.datetime "d8_ongoingtreatment_date"
    t.datetime "examination_date"
    t.datetime "certification_date"
    t.string "l1_flag", limit: 1
    t.string "l1_bloodgroup", limit: 2
    t.string "l1_bloodrh", limit: 1
    t.string "l1_elisa", limit: 1
    t.string "l1_hbsag", limit: 1
    t.string "l1_vdrltpha", limit: 1
    t.string "l1_malaria", limit: 1
    t.string "l1_urineopiates", limit: 1
    t.string "l1_urinecannabis", limit: 1
    t.string "l1_urinepregnancy", limit: 1
    t.string "l1_urinecolor", limit: 1
    t.string "l1_urinegravity", limit: 1
    t.string "l1_urinesugar", limit: 1
    t.string "l1_urinesugar1plus", limit: 1
    t.string "l1_urinesugar2plus", limit: 1
    t.string "l1_urinesugar3plus", limit: 1
    t.string "l1_urinesugar4plus", limit: 1
    t.string "l1_sugarmilimoles", limit: 7
    t.string "l1_urinealbumin", limit: 1
    t.string "l1_urinealbumin1plus", limit: 1
    t.string "l1_urinealbumin2plus", limit: 1
    t.string "l1_urinealbumin3plus", limit: 1
    t.string "l1_urinealbumin4plus", limit: 1
    t.string "l1_albuminmilimoles", limit: 5
    t.string "l1_urinemicroexam", limit: 1
    t.string "l1_reason", limit: 4000
    t.datetime "l1_labresultdate"
    t.datetime "l1_specimendate"
    t.string "r1_flag", limit: 1
    t.string "r1_thoraciccage", limit: 1
    t.string "r1_heartszshape", limit: 1
    t.string "r1_lungfields", limit: 1
    t.datetime "r1_xrayresultdate"
    t.datetime "r1_xraydonedate"
    t.string "fw_name", limit: 50
    t.datetime "fw_dateofbirth"
    t.string "fw_sex", limit: 1
    t.string "fw_jobtype", limit: 50
    t.string "fw_passportno", limit: 30
    t.string "employer_code", limit: 10
    t.string "fw_countryname", limit: 50
    t.string "lab_code", limit: 13
    t.string "rad_code", limit: 13
    t.string "xray_code", limit: 13
    t.string "quarantine_reason", limit: 4000
    t.string "status", limit: 5
    t.string "inspstatus", limit: 1
    t.datetime "time_inserted"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.datetime "last_pms_date"
    t.string "d2_taken_drugs", limit: 1
    t.string "r1_focallesion", limit: 1
    t.string "r1_otherabnormalities", limit: 1
    t.string "r1_impression", limit: 4000
    t.string "r1_mediastinum", limit: 1
    t.string "r1_pleura", limit: 1
    t.string "r1_thoraciccage_detail", limit: 1000
    t.string "r1_heartszshape_detail", limit: 1000
    t.string "r1_lungfields_detail", limit: 1000
    t.string "r1_mediastinum_detail", limit: 1000
    t.string "r1_pleura_detail", limit: 1000
    t.string "r1_focallesion_detail", limit: 1000
    t.string "r1_otherabnormalities_detail", limit: 1000
    t.string "l1_tpha", limit: 1
    t.string "l1_sgvalue", limit: 20
    t.string "l1_urinemicroexam_reason", limit: 4000
    t.string "source", limit: 1
    t.string "l1_ibtv2", limit: 1
    t.string "l1_batchnum", limit: 10
    t.decimal "tcupi_letter_refid", precision: 10
    t.decimal "tcupi_xrayletter_refid", precision: 10
    t.decimal "qrtn_source", precision: 1
    t.datetime "l1_specimentakendate"
    t.string "l1_blood_barcodeno", limit: 20
    t.string "l1_urine_barcodeno", limit: 20
    t.string "r1_xrayrefno", limit: 20
    t.string "d3_other", limit: 1
    t.string "d4_appearance", limit: 1
    t.string "d4_speechquality", limit: 1
    t.string "d4_coherent", limit: 1
    t.string "d4_relevant", limit: 1
    t.string "d4_mood", limit: 1
    t.string "d4_depressed", limit: 1
    t.string "d4_depressed1", limit: 1
    t.string "d4_depressed2", limit: 1
    t.string "d4_anxious", limit: 1
    t.string "d4_irritable", limit: 1
    t.string "d4_affect", limit: 1
    t.string "d4_thought", limit: 1
    t.string "d4_delusion", limit: 1
    t.string "d4_suicidality", limit: 1
    t.string "d4_suicidality1", limit: 1
    t.string "d4_suicidality2", limit: 1
    t.string "d4_perception", limit: 1
    t.string "d4_orientation", limit: 1
    t.string "d4_time", limit: 1
    t.string "d4_place", limit: 1
    t.string "d4_person", limit: 1
    t.string "d4_other", limit: 1
    t.string "d4_discharge", limit: 1
    t.string "d4_lump", limit: 1
    t.string "d4_axillary", limit: 1
    t.string "d4_other6", limit: 1
    t.string "l1_bloodgroup_reason", limit: 4000
    t.string "l1_bfmp", limit: 1
    t.string "l1_hcg", limit: 1
    t.string "d6_hypertension", limit: 1
    t.string "d6_heart_diseases", limit: 1
    t.string "d6_asthma", limit: 1
    t.string "d6_diabetes", limit: 1
    t.string "d6_ulcer", limit: 1
    t.string "d6_kidney", limit: 1
    t.string "d6_others6", limit: 1
    t.index ["trans_id"], name: "idx_quarantine_fw_doc_on_trans_id"
  end

  create_table "quarantine_fw_doc_hist", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "fw_code", limit: 13
    t.string "doc_code", limit: 13
    t.string "d1_hiv", limit: 1
    t.datetime "d1_hiv_date"
    t.string "d1_tb", limit: 1
    t.datetime "d1_tb_date"
    t.string "d1_leprosy", limit: 1
    t.datetime "d1_leprosy_date"
    t.string "d1_hepatitis", limit: 1
    t.datetime "d1_hepatitis_date"
    t.string "d1_psych", limit: 1
    t.datetime "d1_psych_date"
    t.string "d1_epilepsy", limit: 1
    t.datetime "d1_epilepsy_date"
    t.string "d1_cancer", limit: 1
    t.datetime "d1_cancer_date"
    t.string "d1_std", limit: 1
    t.datetime "d1_std_date"
    t.string "d1_malaria", limit: 1
    t.datetime "d1_malaria_date"
    t.string "d2_hypertension", limit: 1
    t.datetime "d2_hypertension_date"
    t.string "d2_heartdisease", limit: 1
    t.datetime "d2_heartdisease_date"
    t.string "d2_asthma", limit: 1
    t.datetime "d2_asthma_date"
    t.string "d2_diabetes", limit: 1
    t.datetime "d2_diabetes_date"
    t.string "d2_ulcer", limit: 1
    t.datetime "d2_ulcer_date"
    t.string "d2_kidney", limit: 1
    t.datetime "d2_kidney_date"
    t.string "d2_others", limit: 1
    t.datetime "d2_others_date"
    t.string "d2_comments", limit: 4000
    t.string "d3_heartsize", limit: 1
    t.string "d3_heartsound", limit: 1
    t.string "d3_othercardio", limit: 1
    t.string "d3_breathsound", limit: 1
    t.string "d3_otherrespiratory", limit: 1
    t.string "d3_liver", limit: 1
    t.string "d3_spleen", limit: 1
    t.string "d3_swelling", limit: 1
    t.string "d3_lymphnodes", limit: 1
    t.string "d3_rectal", limit: 1
    t.string "d4_mental", limit: 1
    t.string "d4_speech", limit: 1
    t.string "d4_cognitive", limit: 1
    t.string "d4_peripheralnerves", limit: 1
    t.string "d4_motorpower", limit: 1
    t.string "d4_sensory", limit: 1
    t.string "d4_reflexes", limit: 1
    t.string "d4_kidney", limit: 1
    t.string "d4_gendischarge", limit: 1
    t.string "d4_gensores", limit: 1
    t.string "d4_comments", limit: 4000
    t.decimal "d5_height", precision: 10, scale: 2
    t.decimal "d5_weight", precision: 10, scale: 2
    t.decimal "d5_pulse", precision: 10, scale: 2
    t.decimal "d5_systolic", precision: 10, scale: 2
    t.decimal "d5_diastolic", precision: 10, scale: 2
    t.string "d5_skinrash", limit: 1
    t.string "d5_skinpatch", limit: 1
    t.string "d5_deformities", limit: 1
    t.string "d5_anaemia", limit: 1
    t.string "d5_jaundice", limit: 1
    t.string "d5_enlargement", limit: 1
    t.string "d5_vision_unaidedleft", limit: 1
    t.string "d5_vision_unaidedright", limit: 1
    t.string "d5_vision_aidedleft", limit: 1
    t.string "d5_vision_aidedright", limit: 1
    t.string "d5_hearingleft", limit: 1
    t.string "d5_hearingright", limit: 1
    t.string "d5_others", limit: 1
    t.string "d5_comments", limit: 4000
    t.string "d6_hiv", limit: 1
    t.string "d6_tb", limit: 1
    t.string "d6_malaria", limit: 1
    t.string "d6_leprosy", limit: 1
    t.string "d6_std", limit: 1
    t.string "d6_hepatitis", limit: 1
    t.string "d6_cancer", limit: 1
    t.string "d6_epilepsy", limit: 1
    t.string "d6_psych", limit: 1
    t.string "d6_others", limit: 1
    t.string "d6_pregnant", limit: 1
    t.string "d6_opiates", limit: 1
    t.string "d6_cannabis", limit: 1
    t.string "d7_fw_medstatus", limit: 1
    t.string "d7_comments", limit: 4000
    t.string "d7_unfit_reason", limit: 4000
    t.string "d8_notifymoh", limit: 1
    t.datetime "d8_notifymoh_date"
    t.string "d8_refergh", limit: 1
    t.datetime "d8_refergh_date"
    t.string "d8_referph", limit: 1
    t.datetime "d8_referph_date"
    t.string "d8_treatpatient", limit: 1
    t.datetime "d8_treatpatient_date"
    t.string "d8_ongoingtreatment", limit: 1
    t.datetime "d8_ongoingtreatment_date"
    t.datetime "examination_date"
    t.datetime "certification_date"
    t.string "l1_flag", limit: 1
    t.string "l1_bloodgroup", limit: 2
    t.string "l1_bloodrh", limit: 1
    t.string "l1_elisa", limit: 1
    t.string "l1_hbsag", limit: 1
    t.string "l1_vdrltpha", limit: 1
    t.string "l1_malaria", limit: 1
    t.string "l1_urineopiates", limit: 1
    t.string "l1_urinecannabis", limit: 1
    t.string "l1_urinepregnancy", limit: 1
    t.string "l1_urinecolor", limit: 1
    t.string "l1_urinegravity", limit: 1
    t.string "l1_urinesugar", limit: 1
    t.string "l1_urinesugar1plus", limit: 1
    t.string "l1_urinesugar2plus", limit: 1
    t.string "l1_urinesugar3plus", limit: 1
    t.string "l1_urinesugar4plus", limit: 1
    t.string "l1_sugarmilimoles", limit: 7
    t.string "l1_urinealbumin", limit: 1
    t.string "l1_urinealbumin1plus", limit: 1
    t.string "l1_urinealbumin2plus", limit: 1
    t.string "l1_urinealbumin3plus", limit: 1
    t.string "l1_urinealbumin4plus", limit: 1
    t.string "l1_albuminmilimoles", limit: 5
    t.string "l1_urinemicroexam", limit: 1
    t.string "l1_reason", limit: 4000
    t.datetime "l1_labresultdate"
    t.datetime "l1_specimendate"
    t.string "r1_flag", limit: 1
    t.string "r1_thoraciccage", limit: 1
    t.string "r1_heartszshape", limit: 1
    t.string "r1_lungfields", limit: 1
    t.datetime "r1_xrayresultdate"
    t.datetime "r1_xraydonedate"
    t.string "fw_name", limit: 50
    t.datetime "fw_dateofbirth"
    t.string "fw_sex", limit: 1
    t.string "fw_jobtype", limit: 50
    t.string "fw_passportno", limit: 30
    t.string "employer_code", limit: 10
    t.string "fw_countryname", limit: 50
    t.string "lab_code", limit: 13
    t.string "rad_code", limit: 13
    t.string "xray_code", limit: 13
    t.string "quarantine_reason", limit: 4000
    t.string "status", limit: 5
    t.string "inspstatus", limit: 1
    t.datetime "time_inserted"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.datetime "last_pms_date"
    t.string "d2_taken_drugs", limit: 1
    t.string "r1_focallesion", limit: 1
    t.string "r1_otherabnormalities", limit: 1
    t.string "r1_impression", limit: 4000
    t.string "r1_mediastinum", limit: 1
    t.string "r1_pleura", limit: 1
    t.string "r1_thoraciccage_detail", limit: 1000
    t.string "r1_heartszshape_detail", limit: 1000
    t.string "r1_lungfields_detail", limit: 1000
    t.string "r1_mediastinum_detail", limit: 1000
    t.string "r1_pleura_detail", limit: 1000
    t.string "r1_focallesion_detail", limit: 1000
    t.string "r1_otherabnormalities_detail", limit: 1000
    t.datetime "delete_date"
    t.string "delete_by", limit: 10
    t.index ["trans_id"], name: "idx_quarantine_fw_doc_hist_on_trans_id"
  end

  create_table "quarantine_fw_reason", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "bc_worker_code", limit: 13
    t.string "reason_code", limit: 10
    t.datetime "creation_date"
    t.index ["trans_id"], name: "idx_quarantine_fw_reason_on_trans_id"
  end

  create_table "quarantine_fw_reason_hist", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "bc_worker_code", limit: 13
    t.string "reason_code", limit: 10
    t.datetime "creation_date"
    t.datetime "delete_date"
    t.string "delete_by", limit: 10
    t.index ["trans_id"], name: "idx_quarantine_fw_reason_hist_on_trans_id"
  end

  create_table "quarantine_insp_findings", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "fw_code", limit: 13
    t.string "d6_hiv", limit: 1
    t.string "d6_tb", limit: 1
    t.string "d6_malaria", limit: 1
    t.string "d6_leprosy", limit: 1
    t.string "d6_std", limit: 1
    t.string "d6_hepatitis", limit: 1
    t.string "d6_cancer", limit: 1
    t.string "d6_epilepsy", limit: 1
    t.string "d6_psych", limit: 1
    t.string "d6_others", limit: 1
    t.string "d6_pregnant", limit: 1
    t.string "d6_opiates", limit: 1
    t.string "d6_cannabis", limit: 1
    t.decimal "modify_id", precision: 10
    t.datetime "modify_date"
    t.string "d6_hypertension", limit: 1
    t.string "d6_heart_diseases", limit: 1
    t.string "d6_asthma", limit: 1
    t.string "d6_diabetes", limit: 1
    t.string "d6_ulcer", limit: 1
    t.string "d6_kidney", limit: 1
    t.string "d6_others6", limit: 1
    t.index ["trans_id"], name: "idx_quarantine_insp_findings_on_trans_id"
  end

  create_table "quarantine_insp_findings_hist", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "fw_code", limit: 13
    t.string "d6_hiv", limit: 1
    t.string "d6_tb", limit: 1
    t.string "d6_malaria", limit: 1
    t.string "d6_leprosy", limit: 1
    t.string "d6_std", limit: 1
    t.string "d6_hepatitis", limit: 1
    t.string "d6_cancer", limit: 1
    t.string "d6_epilepsy", limit: 1
    t.string "d6_psych", limit: 1
    t.string "d6_others", limit: 1
    t.string "d6_pregnant", limit: 1
    t.string "d6_opiates", limit: 1
    t.string "d6_cannabis", limit: 1
    t.decimal "modify_id", precision: 10
    t.datetime "modify_date"
    t.datetime "action_date"
    t.index ["trans_id"], name: "idx_quarantine_insp_findings_hist_on_trans_id"
  end

  create_table "quarantine_reason", id: false, force: :cascade do |t|
    t.string "reason_code", limit: 10
    t.string "reason", limit: 1000
    t.string "active", limit: 1
  end

  create_table "quarantine_reason_group", id: false, force: :cascade do |t|
    t.decimal "capid", precision: 18
    t.string "reason_code", limit: 10
    t.datetime "creation_date"
  end

  create_table "quarantine_release_approval", id: false, force: :cascade do |t|
    t.decimal "qrreqid", precision: 10
    t.decimal "qrrid", precision: 10
    t.string "status", limit: 1
    t.string "comments", limit: 4000
    t.decimal "approval_id", precision: 10
    t.datetime "approval_date"
  end

  create_table "quarantine_release_req_history", id: false, force: :cascade do |t|
    t.decimal "qrrid", precision: 18
    t.string "trans_id", limit: 14
    t.string "comments", limit: 4000
    t.string "status", limit: 5
    t.string "medstatus", limit: 1
    t.decimal "request_by", precision: 10
    t.datetime "creation_date"
    t.string "ismonitor", limit: 1
    t.decimal "mle", precision: 10
    t.datetime "assessment_date"
    t.datetime "release_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modify_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.index ["trans_id"], name: "idx_quarantine_release_req_history_on_trans_id"
  end

  create_table "quarantine_release_request", id: false, force: :cascade do |t|
    t.decimal "qrrid", precision: 18
    t.string "trans_id", limit: 14
    t.string "comments", limit: 4000
    t.string "status", limit: 5
    t.string "medstatus", limit: 1
    t.decimal "request_by", precision: 10
    t.datetime "creation_date"
    t.string "ismonitor", limit: 1
    t.decimal "mle", precision: 10
    t.datetime "assessment_date"
    t.datetime "release_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modify_date"
    t.string "remove_mon_comment", limit: 4000
    t.index ["trans_id"], name: "idx_quarantine_release_request_on_trans_id"
  end

  create_table "quarantine_status_history", id: false, force: :cascade do |t|
    t.string "bc_worker_code", limit: 13
    t.string "old_status", limit: 1
    t.string "new_status", limit: 1
    t.decimal "userid", precision: 10
    t.datetime "mod_date"
    t.index ["bc_worker_code"], name: "idx_quarantine_status_history_on_bc_worker_code"
  end

  create_table "quarantine_status_pending", id: false, force: :cascade do |t|
    t.string "bc_worker_code", limit: 13
    t.string "old_status", limit: 1
    t.string "new_status", limit: 1
    t.decimal "userid", precision: 10
    t.datetime "mod_date"
  end

  create_table "quarantine_tcupi_todolist", id: false, force: :cascade do |t|
    t.decimal "quarantine_todolist_id", precision: 20
    t.decimal "tcupi_todolist_id", precision: 20
    t.decimal "qrrid", precision: 20
    t.datetime "date_completed"
    t.string "comments", limit: 255
    t.decimal "createby", precision: 20
    t.datetime "create_date"
    t.string "modify_by", limit: 20
    t.datetime "modify_date"
    t.string "testdone", limit: 1
    t.string "others_comments", limit: 4000
  end

  create_table "quarantine_transfer", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 13
    t.decimal "transfer_mode", precision: 1
    t.string "comments", limit: 1000
    t.string "creator_id", limit: 50
    t.datetime "create_date"
    t.string "modifier_id", limit: 50
    t.datetime "modify_date"
    t.index ["trans_id"], name: "idx_quarantine_transfer_on_trans_id"
  end

  create_table "quest_com_product_privs", id: false, force: :cascade do |t|
    t.decimal "product_id"
    t.string "privilege_id", limit: 60
    t.string "privilege_description", limit: 256
    t.string "validation_routine", limit: 2000
    t.string "privilege_level", limit: 256
    t.string "install_user", limit: 30
  end

  create_table "quest_com_products", id: false, force: :cascade do |t|
    t.decimal "product_id"
    t.string "product_name", limit: 30
    t.string "product_prefix", limit: 8
    t.string "install_user", limit: 30
    t.string "grant_procedure", limit: 2000
    t.string "revoke_procedure", limit: 2000
    t.string "product_version", limit: 20
    t.string "deinstall_script"
    t.string "grant_priv_procedure", limit: 2000
    t.string "revoke_priv_procedure", limit: 2000
    t.string "installed_by", limit: 30
    t.string "product_schema_version", limit: 20
    t.string "product_base_version", limit: 20
    t.string "stand_alone_product_flag", limit: 1
  end

  create_table "quest_com_products_used_by", id: false, force: :cascade do |t|
    t.decimal "product_id"
    t.decimal "used_by_product_id"
    t.string "product_version", limit: 20
    t.string "install_user", limit: 30
  end

  create_table "quest_com_user_privileges", id: false, force: :cascade do |t|
    t.decimal "product_id"
    t.decimal "user_id"
    t.string "privilege_id", limit: 60
    t.string "privilege_level", limit: 2000
    t.string "install_user", limit: 30
  end

  create_table "quest_com_users", id: false, force: :cascade do |t|
    t.decimal "user_id"
    t.decimal "product_id"
    t.string "authorization_level", limit: 60
    t.string "install_user", limit: 30
  end

  create_table "r_del_dup", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.decimal "tot"
  end

  create_table "radiographer_master", id: false, force: :cascade do |t|
    t.decimal "radiographer_id", precision: 10
    t.string "radiographer_name", limit: 50
    t.string "status", limit: 1
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "radiologist_master", id: false, force: :cascade do |t|
    t.string "radiologist_code", limit: 10
    t.string "radiologist_name", limit: 50
    t.datetime "creation_date"
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 100
    t.string "fax", limit: 100
    t.string "district_code", limit: 7
    t.string "state_code", limit: 7
    t.string "country_code", limit: 3
    t.string "email_id", limit: 100
    t.string "primary_contact_person", limit: 50
    t.string "primary_contact_phone_no", limit: 20
    t.string "version_no", limit: 10
    t.string "qualification", limit: 50
    t.string "xray_regn_no", limit: 20
    t.string "status_code", limit: 5
    t.string "comments", limit: 4000
    t.string "bc_radiologist_code", limit: 13
    t.decimal "creator_id", precision: 10
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.decimal "rdregid", precision: 10
    t.string "nearest_district_office", limit: 7
    t.string "radiologist_ic_new", limit: 20
    t.string "radiologist_ic_old", limit: 20
    t.string "is_pcr", limit: 1
    t.string "apc_year", limit: 4
    t.decimal "nios_uuid"
    t.string "apc_no", limit: 20
    t.string "nsr_no", limit: 20
    t.string "xray_name", limit: 50
    t.string "gst_code", limit: 20
    t.decimal "gst_tax", precision: 126
    t.decimal "male_rate", precision: 126
    t.decimal "female_rate", precision: 126
    t.string "bank_account_no", limit: 20
    t.decimal "gst_type", precision: 10
    t.string "bank_code", limit: 8
    t.string "mobile_no", limit: 20
    t.datetime "renewal_date"
    t.decimal "quota", precision: 10
    t.decimal "quota_use", precision: 10
    t.index ["bank_code"], name: "idx_radiologist_master_on_bank_code"
    t.index ["bc_radiologist_code"], name: "idx_radiologist_master_on_bc_radiologist_code"
    t.index ["country_code"], name: "idx_radiologist_master_on_country_code"
    t.index ["district_code"], name: "idx_radiologist_master_on_district_code"
    t.index ["gst_code"], name: "idx_radiologist_master_on_gst_code"
    t.index ["post_code"], name: "idx_radiologist_master_on_post_code"
    t.index ["radiologist_code"], name: "idx_radiologist_master_on_radiologist_code"
    t.index ["state_code"], name: "idx_radiologist_master_on_state_code"
    t.index ["status_code"], name: "idx_radiologist_master_on_status_code"
  end

  create_table "receipt", id: false, force: :cascade do |t|
    t.string "tranno", limit: 10
    t.string "oldtranno", limit: 10
    t.string "status", limit: 10
    t.decimal "no_male", precision: 5
    t.decimal "no_female", precision: 5
    t.decimal "amount", precision: 10, scale: 2
    t.decimal "amount_paid", precision: 10, scale: 2
    t.string "service_type", limit: 2
    t.string "isfoc", limit: 5
    t.string "isrefunded", limit: 5
    t.string "foc_reason", limit: 4000
    t.string "void_reason", limit: 4000
    t.string "printed", limit: 5
    t.decimal "print_count", precision: 5
    t.string "contact_name", limit: 50
    t.string "contact_phone", limit: 100
    t.string "contact_fax", limit: 100
    t.string "contact_address1", limit: 50
    t.string "contact_address2", limit: 50
    t.string "contact_address3", limit: 50
    t.string "contact_address4", limit: 50
    t.string "contact_post_code", limit: 10
    t.string "contact_state_code", limit: 7
    t.string "contact_district_code", limit: 7
    t.string "branch_code", limit: 2
    t.string "received_by", limit: 100
    t.datetime "trandate"
    t.datetime "expirydate"
    t.string "version_no", limit: 10
    t.string "comments", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.decimal "no_uses", precision: 5
    t.decimal "no_uses_count", precision: 5
    t.string "service_provider", limit: 13
    t.datetime "kivexpiry_date"
    t.decimal "gst_amount", precision: 10, scale: 2
    t.decimal "isgstmigrated", precision: 1
  end

  create_table "receipt_change_reason", id: false, force: :cascade do |t|
    t.decimal "rregid", precision: 10
    t.string "tranno", limit: 10
    t.string "reason_type", limit: 5
    t.string "reason", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
  end

  create_table "receipt_change_type", id: false, force: :cascade do |t|
    t.decimal "reason_type", precision: 10
    t.string "description", limit: 255
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
  end

  create_table "receipt_detail", id: false, force: :cascade do |t|
    t.string "tranno", limit: 10
    t.decimal "payment_type", precision: 3
    t.string "payment_no", limit: 16
    t.decimal "payment_amount", precision: 10, scale: 2
    t.string "bank_code", limit: 8
    t.string "branch_area", limit: 100
    t.string "zone_code", limit: 2
    t.string "version_no", limit: 10
    t.datetime "date_issue"
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "name_on_card", limit: 100
    t.datetime "expiry_date"
    t.string "approval_code", limit: 20
    t.string "ref_no", limit: 50
    t.decimal "payment_surcharge", precision: 10, scale: 2
    t.string "card_type", limit: 20
  end

  create_table "receipt_detail_history", id: false, force: :cascade do |t|
    t.string "tranno", limit: 10
    t.decimal "payment_type", precision: 3
    t.string "payment_no", limit: 16
    t.decimal "payment_amount", precision: 10, scale: 2
    t.string "bank_code", limit: 8
    t.string "branch_area", limit: 100
    t.string "zone_code", limit: 2
    t.string "version_no", limit: 10
    t.datetime "date_issue"
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.string "name_on_card", limit: 100
    t.datetime "expiry_date"
    t.string "approval_code", limit: 20
    t.string "ref_no", limit: 50
    t.decimal "payment_surcharge", precision: 10, scale: 2
    t.string "card_type", limit: 20
    t.index ["approval_code"], name: "idx_receipt_detail_history_on_approval_code"
    t.index ["bank_code"], name: "idx_receipt_detail_history_on_bank_code"
    t.index ["zone_code"], name: "idx_receipt_detail_history_on_zone_code"
  end

  create_table "receipt_detail_sabah", id: false, force: :cascade do |t|
    t.string "tranno", limit: 10
    t.decimal "payment_type", precision: 2
    t.string "payment_no", limit: 10
    t.decimal "payment_amount", precision: 10, scale: 2
    t.string "bank_code", limit: 8
    t.string "branch_area", limit: 30
    t.string "zone_code", limit: 2
    t.string "version_no", limit: 10
    t.datetime "date_issue"
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "receipt_gender_change", id: false, force: :cascade do |t|
    t.decimal "receipt_gender_id", precision: 10
    t.string "tranno", limit: 10
    t.decimal "male_diff", precision: 5
    t.decimal "female_diff", precision: 5
    t.decimal "amount_diff", precision: 10
    t.decimal "create_by", precision: 10
    t.datetime "create_date"
  end

  create_table "receipt_history", id: false, force: :cascade do |t|
    t.string "tranno", limit: 10
    t.string "oldtranno", limit: 10
    t.string "status", limit: 10
    t.decimal "no_male", precision: 5
    t.decimal "no_female", precision: 5
    t.decimal "amount", precision: 10, scale: 2
    t.decimal "amount_paid", precision: 10, scale: 2
    t.string "service_type", limit: 2
    t.string "isfoc", limit: 5
    t.string "isrefunded", limit: 5
    t.string "foc_reason", limit: 4000
    t.string "void_reason", limit: 4000
    t.string "printed", limit: 5
    t.decimal "print_count", precision: 5
    t.string "contact_name", limit: 50
    t.string "contact_phone", limit: 100
    t.string "contact_fax", limit: 100
    t.string "contact_address1", limit: 50
    t.string "contact_address2", limit: 50
    t.string "contact_address3", limit: 50
    t.string "contact_address4", limit: 50
    t.string "contact_post_code", limit: 10
    t.string "contact_state_code", limit: 7
    t.string "contact_district_code", limit: 7
    t.string "branch_code", limit: 2
    t.string "received_by", limit: 100
    t.datetime "trandate"
    t.datetime "expirydate"
    t.string "version_no", limit: 10
    t.string "comments", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.decimal "no_uses", precision: 5
    t.decimal "no_uses_count", precision: 5
    t.string "service_provider", limit: 13
    t.string "action", limit: 10
    t.datetime "action_date"
    t.datetime "kivexpiry_date"
    t.index ["branch_code"], name: "idx_receipt_history_on_branch_code"
    t.index ["contact_district_code"], name: "idx_receipt_history_on_contact_district_code"
    t.index ["contact_post_code"], name: "idx_receipt_history_on_contact_post_code"
    t.index ["contact_state_code"], name: "idx_receipt_history_on_contact_state_code"
  end

  create_table "receipt_history_medcon", id: false, force: :cascade do |t|
    t.datetime "trandate"
    t.string "tranno", limit: 10
    t.string "cancel", limit: 1
    t.string "employer", limit: 50
    t.string "company", limit: 50
    t.decimal "no_male", precision: 5
    t.decimal "no_female", precision: 5
    t.string "received_by", limit: 10
    t.decimal "amount", precision: 10, scale: 2
    t.string "service_type", limit: 2
    t.datetime "deleted_date"
  end

  create_table "receipt_kiv_request", id: false, force: :cascade do |t|
    t.decimal "request_id"
    t.string "tranno", limit: 20
    t.string "branch_code", limit: 2
    t.datetime "creation_date"
    t.decimal "created_by"
    t.string "approve_status", limit: 20
    t.string "approve_comment", limit: 255
    t.datetime "approve_date"
    t.string "approve_by", limit: 20
    t.decimal "kiv_male"
    t.decimal "kiv_female"
  end

  create_table "receipt_medcon", id: false, force: :cascade do |t|
    t.datetime "trandate"
    t.string "tranno", limit: 10
    t.string "cancel", limit: 1
    t.string "employer", limit: 50
    t.string "company", limit: 50
    t.decimal "no_male", precision: 5
    t.decimal "no_female", precision: 5
    t.string "received_by", limit: 10
    t.decimal "amount", precision: 10, scale: 2
    t.string "service_type", limit: 2
  end

  create_table "receipt_prefer_doctor", id: false, force: :cascade do |t|
    t.string "tranno", limit: 10
    t.datetime "trandate"
    t.string "bc_doctor_code", limit: 13
    t.decimal "allocation", precision: 10
    t.decimal "allocation_use", precision: 10
    t.string "version_no", limit: 10
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "receipt_prefer_doctor_history", id: false, force: :cascade do |t|
    t.string "tranno", limit: 10
    t.datetime "trandate"
    t.string "bc_doctor_code", limit: 13
    t.decimal "allocation", precision: 10
    t.decimal "allocation_use", precision: 10
    t.string "version_no", limit: 10
    t.datetime "log_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.index ["bc_doctor_code"], name: "idx_receipt_prefer_doctor_history_on_bc_doctor_code"
  end

  create_table "receipt_sabah", id: false, force: :cascade do |t|
    t.string "tranno", limit: 10
    t.string "oldtranno", limit: 10
    t.string "status", limit: 10
    t.decimal "no_male", precision: 5
    t.decimal "no_female", precision: 5
    t.decimal "amount", precision: 10, scale: 2
    t.decimal "amount_paid", precision: 10, scale: 2
    t.string "service_type", limit: 2
    t.string "isfoc", limit: 5
    t.string "isrefunded", limit: 5
    t.string "foc_reason", limit: 4000
    t.string "void_reason", limit: 4000
    t.string "printed", limit: 5
    t.decimal "print_count", precision: 5
    t.string "contact_name", limit: 50
    t.string "contact_phone", limit: 100
    t.string "contact_fax", limit: 100
    t.string "contact_address1", limit: 50
    t.string "contact_address2", limit: 50
    t.string "contact_address3", limit: 50
    t.string "contact_address4", limit: 50
    t.string "contact_post_code", limit: 10
    t.string "contact_state_code", limit: 7
    t.string "contact_district_code", limit: 7
    t.string "branch_code", limit: 2
    t.string "received_by", limit: 100
    t.datetime "trandate"
    t.datetime "expirydate"
    t.string "version_no", limit: 10
    t.string "comments", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.decimal "no_uses", precision: 5
    t.decimal "no_uses_count", precision: 5
    t.string "service_provider", limit: 13
  end

  create_table "receipt_service", id: false, force: :cascade do |t|
    t.string "service_type", limit: 2
    t.string "description", limit: 255
    t.string "status", limit: 5
    t.decimal "service_charge"
    t.string "use_by", limit: 10
  end

  create_table "receipt_usage", id: false, force: :cascade do |t|
    t.datetime "trandate"
    t.string "tranno", limit: 10
    t.string "bc_worker_code", limit: 13
    t.string "version_no", limit: 5
    t.string "status_code", limit: 5
    t.string "trans_id", limit: 14
    t.string "trans_version_no", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "oldtranno", limit: 10
    t.index ["trans_id"], name: "idx_receipt_usage_on_trans_id"
  end

  create_table "receipt_usage_history", id: false, force: :cascade do |t|
    t.datetime "trandate"
    t.string "tranno", limit: 10
    t.string "trans_id", limit: 14
    t.string "bc_worker_code", limit: 13
    t.string "status_code", limit: 5
    t.string "comments", limit: 4000
    t.string "version_no", limit: 5
    t.string "trans_version_no", limit: 5
    t.datetime "log_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.index ["bc_worker_code"], name: "idx_receipt_usage_history_on_bc_worker_code"
    t.index ["status_code"], name: "idx_receipt_usage_history_on_status_code"
    t.index ["trans_id"], name: "idx_receipt_usage_history_on_trans_id"
  end

  create_table "ref_double", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.decimal "count"
  end

  create_table "refund", id: false, force: :cascade do |t|
    t.string "refundid", limit: 15
    t.decimal "total_amount", precision: 10, scale: 2
    t.datetime "date_received_document"
    t.string "cheque_number", limit: 20
    t.datetime "cheque_payment_date"
    t.datetime "cheque_release_date"
    t.string "contact_name", limit: 50
    t.string "contact_phone", limit: 100
    t.string "contact_address1", limit: 50
    t.string "contact_address2", limit: 50
    t.string "contact_address3", limit: 50
    t.string "contact_address4", limit: 50
    t.decimal "admin_charges", precision: 10, scale: 2
    t.string "comments", limit: 4000
    t.string "status_code", limit: 10
    t.string "version_no", limit: 10
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "refundee_name", limit: 50
    t.string "refundee_address1", limit: 50
    t.string "refundee_address2", limit: 50
    t.string "refundee_address3", limit: 50
    t.string "refundee_address4", limit: 50
    t.string "refundee_phone", limit: 100
    t.string "service_provider", limit: 13
    t.string "branch_code", limit: 2
    t.decimal "cheque_amount", precision: 10, scale: 2
  end

  create_table "refund_detail", id: false, force: :cascade do |t|
    t.string "refund_detailid", limit: 15
    t.string "refundid", limit: 15
    t.string "refund_type", limit: 5
    t.decimal "amount", precision: 10, scale: 2
    t.decimal "admin_charges", precision: 10, scale: 2
    t.string "trans_id", limit: 14
    t.string "bc_worker_code", limit: 13
    t.string "worker_name", limit: 40
    t.string "bc_employer_code", limit: 13
    t.string "receipt_tranno", limit: 10
    t.datetime "receipt_trandate"
    t.datetime "registration_date"
    t.string "doc_4ply_employer", limit: 1
    t.string "doc_4ply_doctor", limit: 1
    t.string "doc_4ply_laboratory", limit: 1
    t.string "doc_4ply_xray", limit: 1
    t.decimal "total_male", precision: 5
    t.decimal "total_female", precision: 5
    t.decimal "total_worker", precision: 10
    t.decimal "total_kiv_male", precision: 5
    t.decimal "total_kiv_female", precision: 5
    t.decimal "unutilised_amount", precision: 10, scale: 2
    t.string "payment_mode", limit: 5
    t.decimal "payment_amount", precision: 10, scale: 2
    t.string "doc_letter", limit: 1
    t.string "doc_receipt", limit: 1
    t.string "comments", limit: 4000
    t.string "status_code", limit: 10
    t.decimal "ply_reprint_count", precision: 10
    t.string "version_no", limit: 10
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "receipt_oldno", limit: 10
    t.datetime "transdate"
    t.string "sex", limit: 1
    t.index ["trans_id"], name: "idx_refund_detail_on_trans_id"
  end

  create_table "refund_detail_history", id: false, force: :cascade do |t|
    t.string "refund_detailid", limit: 15
    t.string "refundid", limit: 15
    t.string "refund_type", limit: 5
    t.decimal "amount", precision: 10, scale: 2
    t.decimal "admin_charges", precision: 10, scale: 2
    t.string "trans_id", limit: 14
    t.string "bc_worker_code", limit: 13
    t.string "worker_name", limit: 40
    t.string "bc_employer_code", limit: 13
    t.string "receipt_tranno", limit: 10
    t.datetime "receipt_trandate"
    t.datetime "registration_date"
    t.string "doc_4ply_employer", limit: 1
    t.string "doc_4ply_doctor", limit: 1
    t.string "doc_4ply_laboratory", limit: 1
    t.string "doc_4ply_xray", limit: 1
    t.decimal "total_male", precision: 5
    t.decimal "total_female", precision: 5
    t.decimal "total_worker", precision: 10
    t.decimal "total_kiv_male", precision: 5
    t.decimal "total_kiv_female", precision: 5
    t.decimal "unutilised_amount", precision: 10, scale: 2
    t.string "payment_mode", limit: 5
    t.decimal "payment_amount", precision: 10, scale: 2
    t.string "doc_letter", limit: 1
    t.string "doc_receipt", limit: 1
    t.string "comments", limit: 4000
    t.string "status_code", limit: 10
    t.decimal "ply_reprint_count", precision: 10
    t.string "version_no", limit: 10
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.string "receipt_oldno", limit: 10
    t.datetime "transdate"
    t.string "sex", limit: 1
    t.index ["bc_employer_code"], name: "idx_refund_detail_history_on_bc_employer_code"
    t.index ["bc_worker_code"], name: "idx_refund_detail_history_on_bc_worker_code"
    t.index ["status_code"], name: "idx_refund_detail_history_on_status_code"
    t.index ["trans_id"], name: "idx_refund_detail_history_on_trans_id"
  end

  create_table "refund_fomic", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "trans_id", limit: 14
    t.datetime "transdate"
    t.datetime "invalidate_date"
    t.index ["trans_id"], name: "idx_refund_fomic_on_trans_id"
  end

  create_table "refund_fomic_final", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "trans_id", limit: 14
    t.datetime "transdate"
    t.datetime "invalidate_date"
    t.index ["trans_id"], name: "idx_refund_fomic_final_on_trans_id"
  end

  create_table "refund_history", id: false, force: :cascade do |t|
    t.string "refundid", limit: 15
    t.decimal "total_amount", precision: 10, scale: 2
    t.datetime "date_received_document"
    t.string "cheque_number", limit: 20
    t.datetime "cheque_payment_date"
    t.datetime "cheque_release_date"
    t.string "contact_name", limit: 50
    t.string "contact_phone", limit: 100
    t.string "contact_address1", limit: 50
    t.string "contact_address2", limit: 50
    t.string "contact_address3", limit: 50
    t.string "contact_address4", limit: 50
    t.decimal "admin_charges", precision: 10, scale: 2
    t.string "comments", limit: 4000
    t.string "status_code", limit: 10
    t.string "version_no", limit: 10
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.string "refundee_name", limit: 50
    t.string "refundee_phone", limit: 100
    t.string "refundee_address1", limit: 50
    t.string "refundee_address2", limit: 50
    t.string "refundee_address3", limit: 50
    t.string "refundee_address4", limit: 50
    t.string "service_provider", limit: 13
    t.string "branch_code", limit: 2
    t.decimal "cheque_amount", precision: 10, scale: 2
    t.index ["branch_code"], name: "idx_refund_history_on_branch_code"
    t.index ["status_code"], name: "idx_refund_history_on_status_code"
  end

  create_table "rel_qrtn", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.datetime "release_date"
    t.datetime "transdate"
  end

  create_table "renewal_comments", id: false, force: :cascade do |t|
    t.string "bc_worker_code", limit: 13
    t.string "comments", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.decimal "renew_type"
    t.string "trans_id", limit: 14
    t.index ["trans_id"], name: "idx_renewal_comments_on_trans_id"
  end

  create_table "renewal_worker", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "doctor_code", limit: 10
    t.string "agent_code", limit: 10
    t.string "name", limit: 50
    t.string "father_name", limit: 50
    t.string "sex", limit: 1
    t.datetime "dob"
    t.string "passport_nbr", limit: 10
    t.string "job_type_classification", limit: 50
    t.string "origin_country", limit: 25
    t.datetime "date_of_arrival"
    t.string "fitness", limit: 1
    t.string "blood_group", limit: 3
    t.string "work_permit_number", limit: 10
    t.datetime "last_examined_date"
    t.string "employer_code", limit: 10
    t.datetime "date_reg_rev"
    t.string "updated", limit: 1
    t.string "created_by", limit: 10
    t.datetime "renewal_date"
    t.string "branch_code", limit: 2
  end

  create_table "replace_table", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
  end

  create_table "reply_table", id: false, force: :cascade do |t|
    t.string "req_id", limit: 16
    t.string "error_code", limit: 5
    t.string "response_to_query", limit: 2000
    t.string "reply_read", limit: 1
    t.datetime "reply_date"
  end

  create_table "reply_table_arc", id: false, force: :cascade do |t|
    t.string "req_id", limit: 16
    t.string "error_code", limit: 5
    t.string "response_to_query", limit: 2000
    t.string "reply_read", limit: 1
    t.datetime "reply_date"
  end

  create_table "reply_table_old", id: false, force: :cascade do |t|
    t.string "req_id", limit: 16
    t.string "error_code", limit: 5
    t.string "response_to_query", limit: 2000
    t.string "reply_read", limit: 1
  end

  create_table "report_diff_bloodgroup", id: false, force: :cascade do |t|
    t.decimal "report_id", precision: 10
    t.datetime "report_lastdate"
    t.string "report_doccode", limit: 10
    t.decimal "created_by", precision: 10
    t.datetime "created_date"
    t.string "doctor_code_me1", limit: 10
    t.string "blood_group_me1", limit: 2
    t.string "trans_id_me1", limit: 14
    t.string "doctor_code_me2", limit: 10
    t.string "blood_group_me2", limit: 2
    t.string "trans_id_me2", limit: 14
    t.string "doctor_code_me3", limit: 10
    t.string "blood_group_me3", limit: 2
    t.string "trans_id_me3", limit: 14
    t.string "worker_code", limit: 10
    t.string "rh_me1", limit: 1
    t.string "rh_me2", limit: 1
    t.string "rh_me3", limit: 1
  end

  create_table "report_group", id: false, force: :cascade do |t|
    t.decimal "groupid", precision: 10
    t.decimal "capid", precision: 10
    t.decimal "seq", precision: 10
    t.string "reportname", limit: 255
    t.string "contextname", limit: 50
    t.string "indexpage", limit: 100
  end

  create_table "report_group_master", id: false, force: :cascade do |t|
    t.decimal "groupid", precision: 10
    t.decimal "iconid", precision: 10
    t.string "description", limit: 50
    t.decimal "seq", precision: 10
    t.string "status", limit: 1
    t.decimal "width", precision: 5
  end

  create_table "report_receive", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.string "lab_status", limit: 1
    t.datetime "lab_receive_date"
    t.string "xray_status", limit: 1
    t.datetime "xray_receive_date"
    t.string "lab_receive_id", limit: 6
    t.string "xray_receive_id", limit: 6
    t.string "lab_wrong_reporting", limit: 1
    t.string "xray_wrong_reporting", limit: 1
    t.index ["trans_id"], name: "idx_report_receive_on_trans_id"
  end

  create_table "request_table", id: false, force: :cascade do |t|
    t.string "req_id", limit: 16
    t.string "req_type", limit: 2
    t.string "participants_details", limit: 2000
    t.string "request_read", limit: 1
    t.datetime "request_date"
  end

  create_table "request_table_arc", id: false, force: :cascade do |t|
    t.string "req_id", limit: 16
    t.string "req_type", limit: 2
    t.string "participants_details", limit: 2000
    t.string "request_read", limit: 1
    t.datetime "request_date"
  end

  create_table "request_table_hist", id: false, force: :cascade do |t|
    t.string "req_id", limit: 16
    t.string "req_type", limit: 2
    t.string "participants_details", limit: 2000
    t.string "request_read", limit: 1
  end

  create_table "request_table_old", id: false, force: :cascade do |t|
    t.string "req_id", limit: 16
    t.string "req_type", limit: 2
    t.string "participants_details", limit: 2000
    t.string "request_read", limit: 1
  end

  create_table "rev_sync_table", id: false, force: :cascade do |t|
    t.string "table_name", limit: 100
    t.decimal "sequence"
  end

  create_table "rfw_batch_transaction", id: false, force: :cascade do |t|
    t.string "rbatch_id", limit: 14
    t.string "laboratory_code_a", limit: 10
    t.string "bc_laboratory_code_a", limit: 13
    t.string "laboratory_code_b", limit: 10
    t.string "bc_laboratory_code_b", limit: 13
    t.string "status_code", limit: 1
    t.string "version_no", limit: 10
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.string "laboratory_code_ori", limit: 10
    t.string "bc_laboratory_code_ori", limit: 13
  end

  create_table "rfw_batch_transaction_history", id: false, force: :cascade do |t|
    t.string "rbatch_id", limit: 14
    t.string "laboratory_code_a", limit: 10
    t.string "bc_laboratory_code_a", limit: 13
    t.string "laboratory_code_b", limit: 10
    t.string "bc_laboratory_code_b", limit: 13
    t.string "status_code", limit: 1
    t.string "version_no", limit: 10
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.string "laboratory_code_ori", limit: 10
    t.string "bc_laboratory_code_ori", limit: 13
    t.index ["bc_laboratory_code_a"], name: "idx_rfw_batch_transaction_history_on_bc_laboratory_code_a"
    t.index ["bc_laboratory_code_b"], name: "idx_rfw_batch_transaction_history_on_bc_laboratory_code_b"
    t.index ["bc_laboratory_code_ori"], name: "idx_rfw_batch_transaction_history_on_bc_laboratory_code_ori"
    t.index ["laboratory_code_a"], name: "idx_rfw_batch_transaction_history_on_laboratory_code_a"
    t.index ["laboratory_code_b"], name: "idx_rfw_batch_transaction_history_on_laboratory_code_b"
    t.index ["laboratory_code_ori"], name: "idx_rfw_batch_transaction_history_on_laboratory_code_ori"
    t.index ["status_code"], name: "idx_rfw_batch_transaction_history_on_status_code"
  end

  create_table "rfw_case_transaction", id: false, force: :cascade do |t|
    t.string "rtrans_id", limit: 14
    t.string "rbatch_id", limit: 14
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.string "bc_worker_code", limit: 13
    t.string "comments", limit: 4000
    t.string "specimen_type", limit: 5
    t.datetime "f1_specimen_takenbygp_date"
    t.datetime "f1_specimen_tested_date"
    t.string "f1_comments", limit: 4000
    t.string "f2_bloodgroup", limit: 1
    t.string "f2_elisa", limit: 1
    t.string "f2_hbsag", limit: 1
    t.string "f2_vdrltpha", limit: 1
    t.string "f2_tpha", limit: 1
    t.string "f2_malaria", limit: 1
    t.string "f2_urineopiates", limit: 1
    t.string "f2_urinecannabis", limit: 1
    t.string "f2_urinepregnancy", limit: 1
    t.string "f2_urinecolor", limit: 1
    t.string "f2_urinegravity", limit: 1
    t.string "f2_urinesugar", limit: 1
    t.string "f2_urinealbumin", limit: 1
    t.string "f2_urinemicroexam", limit: 1
    t.datetime "specimen_surrender_date"
    t.string "status_code", limit: 1
    t.string "version_no", limit: 10
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.string "tag_ind", limit: 1
    t.index ["trans_id"], name: "idx_rfw_case_transaction_on_trans_id"
  end

  create_table "rfw_case_transaction_history", id: false, force: :cascade do |t|
    t.string "rtrans_id", limit: 14
    t.string "rbatch_id", limit: 14
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.string "bc_worker_code", limit: 13
    t.string "comments", limit: 4000
    t.string "specimen_type", limit: 5
    t.datetime "f1_specimen_takenbygp_date"
    t.datetime "f1_specimen_tested_date"
    t.string "f1_comments", limit: 4000
    t.string "f2_bloodgroup", limit: 1
    t.string "f2_elisa", limit: 1
    t.string "f2_hbsag", limit: 1
    t.string "f2_vdrltpha", limit: 1
    t.string "f2_tpha", limit: 1
    t.string "f2_malaria", limit: 1
    t.string "f2_urineopiates", limit: 1
    t.string "f2_urinecannabis", limit: 1
    t.string "f2_urinepregnancy", limit: 1
    t.string "f2_urinecolor", limit: 1
    t.string "f2_urinegravity", limit: 1
    t.string "f2_urinesugar", limit: 1
    t.string "f2_urinealbumin", limit: 1
    t.string "f2_urinemicroexam", limit: 1
    t.datetime "specimen_surrender_date"
    t.string "status_code", limit: 1
    t.string "version_no", limit: 10
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.string "tag_ind", limit: 1
    t.index ["bc_worker_code"], name: "idx_rfw_case_transaction_history_on_bc_worker_code"
    t.index ["status_code"], name: "idx_rfw_case_transaction_history_on_status_code"
    t.index ["trans_id"], name: "idx_rfw_case_transaction_history_on_trans_id"
    t.index ["worker_code"], name: "idx_rfw_case_transaction_history_on_worker_code"
  end

  create_table "rfw_comment", id: false, force: :cascade do |t|
    t.string "rfwtrans_id", limit: 14
    t.string "parameter_code", limit: 10
    t.string "comments", limit: 1000
  end

  create_table "rfw_comment_history", id: false, force: :cascade do |t|
    t.string "rfwtrans_id", limit: 14
    t.string "parameter_code", limit: 10
    t.string "comments", limit: 1000
    t.string "action", limit: 10
    t.datetime "action_date"
    t.index ["parameter_code"], name: "idx_rfw_comment_history_on_parameter_code"
  end

  create_table "rfw_detail", id: false, force: :cascade do |t|
    t.string "rfwtrans_id", limit: 14
    t.string "parameter_code", limit: 10
    t.string "parameter_value", limit: 20
    t.string "med_history", limit: 1
    t.datetime "effected_date"
  end

  create_table "rfw_detail_history", id: false, force: :cascade do |t|
    t.string "rfwtrans_id", limit: 14
    t.string "parameter_code", limit: 10
    t.string "parameter_value", limit: 20
    t.string "med_history", limit: 1
    t.datetime "effected_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.index ["parameter_code"], name: "idx_rfw_detail_history_on_parameter_code"
  end

  create_table "rfw_fw_transaction", id: false, force: :cascade do |t|
    t.string "rfwtrans_id", limit: 14
    t.string "rtrans_id", limit: 14
    t.string "laboratory_code", limit: 10
    t.string "bc_laboratory_code", limit: 13
    t.datetime "lab_submit_date"
    t.datetime "lab_specimen_date"
    t.string "bld_grp", limit: 2
    t.string "rh", limit: 1
    t.string "version_no", limit: 10
  end

  create_table "rfw_fw_transaction_history", id: false, force: :cascade do |t|
    t.string "rfwtrans_id", limit: 14
    t.string "rtrans_id", limit: 14
    t.string "laboratory_code", limit: 10
    t.string "bc_laboratory_code", limit: 13
    t.datetime "lab_submit_date"
    t.datetime "lab_specimen_date"
    t.string "bld_grp", limit: 2
    t.string "rh", limit: 1
    t.string "version_no", limit: 10
    t.string "action", limit: 10
    t.datetime "action_date"
    t.index ["bc_laboratory_code"], name: "idx_rfw_fw_transaction_history_on_bc_laboratory_code"
    t.index ["laboratory_code"], name: "idx_rfw_fw_transaction_history_on_laboratory_code"
  end

  create_table "rfw_labchange_trans", id: false, force: :cascade do |t|
    t.string "rfwtrans_id", limit: 14
    t.string "bc_laboratory_code", limit: 13
    t.string "bc_old_laboratory_code", limit: 13
    t.string "comments", limit: 4000
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "role_capability", id: false, force: :cascade do |t|
    t.decimal "roleid", precision: 10
    t.decimal "capid", precision: 10
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "role_master", id: false, force: :cascade do |t|
    t.decimal "roleid", precision: 10
    t.string "description", limit: 100
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "rp", id: false, force: :cascade do |t|
    t.decimal "capid", precision: 10
    t.string "description", limit: 100
    t.decimal "category", precision: 10
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "longdesc", limit: 255
  end

  create_table "sabah_doc_post", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.string "doctor_name", limit: 50
    t.string "clinic_name", limit: 50
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "post_code", limit: 10
    t.string "state_code", limit: 7
    t.string "district_code", limit: 7
  end

  create_table "sabah_transid", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "new_trans_id", limit: 14
    t.index ["trans_id"], name: "idx_sabah_transid_on_trans_id"
  end

  create_table "scb_hp_dx", id: false, force: :cascade do |t|
    t.string "doc_xray_code", limit: 10
    t.string "doc_xray_ind", limit: 1
  end

  create_table "scb_pay_master", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "doctor_code", limit: 10
    t.datetime "date_reg_rev"
    t.string "name", limit: 50
    t.datetime "entry_date"
    t.decimal "amount", precision: 6
    t.decimal "amt_ded", precision: 3
    t.string "xray_clinic_code", limit: 10
    t.decimal "xray_amount", precision: 6
    t.string "doc_payblock_ind", limit: 1
    t.string "xray_payblock_ind", limit: 1
    t.datetime "doc_payblock_date"
    t.datetime "doc_unblock_date"
    t.datetime "xray_payblock_date"
    t.datetime "xray_unblock_date"
    t.decimal "xray_ded", precision: 3
    t.index ["doctor_code"], name: "idx_scb_pay_master_on_doctor_code"
    t.index ["worker_code"], name: "idx_scb_pay_master_on_worker_code"
    t.index ["xray_clinic_code"], name: "idx_scb_pay_master_on_xray_clinic_code"
  end

  create_table "scb_pay_master_upload", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "doctor_code", limit: 10
    t.datetime "date_reg_rev"
    t.string "name", limit: 50
    t.datetime "entry_date"
    t.decimal "amount", precision: 6
    t.decimal "amt_ded", precision: 3
    t.string "xray_clinic_code", limit: 10
    t.decimal "xray_amount", precision: 6
    t.string "doc_payblock_ind", limit: 1
    t.string "xray_payblock_ind", limit: 1
    t.datetime "doc_payblock_date"
    t.datetime "doc_unblock_date"
    t.datetime "xray_payblock_date"
    t.datetime "xray_unblock_date"
    t.decimal "xray_ded", precision: 3
    t.index ["doctor_code"], name: "idx_scb_pay_master_upload_on_doctor_code"
    t.index ["worker_code"], name: "idx_scb_pay_master_upload_on_worker_code"
    t.index ["xray_clinic_code"], name: "idx_scb_pay_master_upload_on_xray_clinic_code"
  end

  create_table "scb_pay_xray_nameandadd", id: false, force: :cascade do |t|
    t.string "xray_code", limit: 10
    t.string "xray_payee_name", limit: 50
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "post_code", limit: 10
    t.string "district_code", limit: 7
    t.string "state_code", limit: 7
  end

  create_table "scb_sabah_doc_post", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.string "doctor_name", limit: 50
    t.string "clinic_name", limit: 50
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "post_code", limit: 10
    t.string "state_code", limit: 7
    t.string "district_code", limit: 7
  end

  create_table "scb_xray_not_done", id: false, force: :cascade do |t|
    t.string "xray_code", limit: 10
    t.string "worker_code", limit: 10
    t.datetime "transdate"
    t.datetime "certify_date"
    t.datetime "xray_submit_date"
    t.datetime "release_date"
    t.decimal "xray_ded", precision: 3
  end

  create_table "scb_xray_pay_new_address", id: false, force: :cascade do |t|
    t.string "xray_code", limit: 10
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "post_code", limit: 10
    t.string "district_code", limit: 7
    t.string "state_code", limit: 7
  end

  create_table "scb_xray_payin_list", id: false, force: :cascade do |t|
    t.string "xray_code", limit: 10
    t.string "xray_payee_name", limit: 50
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "post_code", limit: 10
    t.string "district_code", limit: 7
    t.string "state_code", limit: 7
  end

  create_table "seminar", id: false, force: :cascade do |t|
    t.string "id", limit: 20
    t.string "sp_type", limit: 2
    t.string "seminar_name", limit: 50
    t.string "venue", limit: 50
    t.string "state_code", limit: 20
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "status", limit: 20
    t.string "comments", limit: 4000
    t.datetime "creation_date"
    t.string "creator_id", limit: 20
    t.datetime "modify_date"
    t.string "modify_id", limit: 20
    t.string "remarks1", limit: 4000
    t.string "remarks2", limit: 4000
  end

  create_table "seminar_detail", id: false, force: :cascade do |t|
    t.string "seminar_id", limit: 20
    t.string "sp_code", limit: 10
    t.string "phone_no", limit: 20
    t.datetime "payment_date"
    t.decimal "amount", precision: 126
    t.decimal "payment_type", precision: 4
    t.string "invoice_no", limit: 20
    t.string "email", limit: 100
    t.string "remarks", limit: 4000
    t.string "attended", limit: 1
    t.string "laboratory_personnel_name", limit: 50
    t.string "ic_no", limit: 20
    t.string "designation", limit: 50
    t.datetime "creation_date"
    t.string "creator_id", limit: 20
    t.datetime "modify_date"
    t.string "modify_id", limit: 20
    t.string "reference_number", limit: 20
    t.string "id", limit: 20
    t.string "sp_name", limit: 50
    t.string "clinic_name", limit: 100
    t.string "address", limit: 4000
    t.string "district_code", limit: 7
    t.string "state_code", limit: 7
    t.string "sp_code2", limit: 10
  end

  create_table "send_mail_ind", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.datetime "send_date"
    t.string "status", limit: 20
    t.decimal "email_type", precision: 1
    t.index ["trans_id"], name: "idx_send_mail_ind_on_trans_id"
  end

  create_table "sequence_master", id: false, force: :cascade do |t|
    t.string "sequencename", limit: 30
    t.decimal "lastvalue", precision: 28
    t.string "description", limit: 100
    t.string "moduleid", limit: 50
    t.datetime "modification_date"
  end

  create_table "service_provide_pay_rate", id: false, force: :cascade do |t|
    t.decimal "sp_id", precision: 10
    t.string "service_type", limit: 5
    t.string "service_provider", limit: 13
    t.decimal "male_rate"
    t.decimal "female_rate"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "description", limit: 255
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "service_provider_group_history", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.string "address1", limit: 1020
    t.string "address2", limit: 1020
    t.string "address3", limit: 1020
    t.string "address4", limit: 1020
    t.string "bank_account_holder_name", limit: 1020
    t.string "bank_account_no", limit: 80
    t.string "district_code", limit: 1020
    t.string "fax", limit: 1020
    t.string "group_code", limit: 10
    t.string "group_name", limit: 200
    t.string "isactive", limit: 1020
    t.string "phone", limit: 1020
    t.string "postcode", limit: 1020
    t.string "service_type", limit: 4
    t.string "state_code", limit: 1020
    t.string "roc", limit: 1020
    t.decimal "female_rate", precision: 126
    t.decimal "male_rate", precision: 126
    t.string "business_reg_no", limit: 80
    t.string "email_address", limit: 100
    t.string "gst_code", limit: 20
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.decimal "gst_tax", precision: 126
    t.decimal "gst_type", precision: 10
    t.string "bank_code", limit: 8
    t.string "group_logo", limit: 50
    t.string "service_provider_master_code", limit: 10
    t.decimal "web_taxinvoice", precision: 1
    t.datetime "gst_effective_date"
    t.string "comments", limit: 4000
    t.string "action", limit: 10
    t.datetime "action_date"
    t.index ["bank_code"], name: "idx_service_provider_group_history_on_bank_code"
    t.index ["district_code"], name: "idx_service_provider_group_history_on_district_code"
    t.index ["group_code"], name: "idx_service_provider_group_history_on_group_code"
    t.index ["gst_code"], name: "idx_service_provider_group_history_on_gst_code"
    t.index ["postcode"], name: "idx_service_provider_group_history_on_postcode"
    t.index ["service_provider_master_code"], name: "idx_service_provider_group_history_on_service_provider_master_c"
    t.index ["state_code"], name: "idx_service_provider_group_history_on_state_code"
  end

  create_table "service_providers_bank_master", id: false, force: :cascade do |t|
    t.string "bank_code", limit: 8
    t.string "bank_name", limit: 100
    t.string "isactive", limit: 1
    t.string "swift_code", limit: 20
    t.index ["bank_code"], name: "idx_service_providers_bank_master_on_bank_code"
    t.index ["swift_code"], name: "idx_service_providers_bank_master_on_swift_code"
  end

  create_table "service_providers_group", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.string "address1", limit: 1020
    t.string "address2", limit: 1020
    t.string "address3", limit: 1020
    t.string "address4", limit: 1020
    t.string "bank_account_holder_name", limit: 1020
    t.string "bank_account_no", limit: 80
    t.string "district_code", limit: 1020
    t.string "fax", limit: 1020
    t.string "group_code", limit: 10
    t.string "group_name", limit: 200
    t.string "isactive", limit: 1020
    t.string "phone", limit: 1020
    t.string "postcode", limit: 1020
    t.string "service_type", limit: 4
    t.string "state_code", limit: 1020
    t.string "roc", limit: 1020
    t.decimal "female_rate", precision: 126
    t.decimal "male_rate", precision: 126
    t.string "business_reg_no", limit: 80
    t.string "email_address", limit: 100
    t.string "gst_code", limit: 20
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.decimal "gst_tax", precision: 126
    t.decimal "gst_type", precision: 10
    t.string "bank_code", limit: 8
    t.string "group_logo", limit: 50
    t.string "service_provider_master_code", limit: 10
    t.decimal "web_taxinvoice", precision: 1
    t.datetime "gst_effective_date"
  end

  create_table "service_providers_group_member", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.datetime "modification_date"
    t.decimal "modify_id", precision: 10
    t.string "service_member", limit: 40
    t.decimal "service_providers_group_id", precision: 19
  end

  create_table "shadow_xray_radio_assignment", id: false, force: :cascade do |t|
    t.string "bc_xray_code", limit: 13
    t.string "bc_radiologist_code", limit: 13
    t.string "trans_id", limit: 14
    t.string "status", limit: 1
    t.datetime "assignment_date"
    t.datetime "lock_date"
    t.datetime "report_date"
    t.datetime "acknowledge_date"
    t.datetime "create_date"
    t.datetime "modify_date"
    t.decimal "retake_source", precision: 1
    t.index ["trans_id"], name: "idx_shadow_xray_radio_assignment_on_trans_id"
  end

  create_table "special_renewal_request", id: false, force: :cascade do |t|
    t.decimal "request_id"
    t.string "worker_code", limit: 20
    t.string "worker_name", limit: 50
    t.string "user_id", limit: 30
    t.string "father_name", limit: 50
    t.datetime "date_of_birth"
    t.string "passport_no", limit: 20
    t.datetime "arrival_date"
    t.datetime "examination_date"
    t.string "foregin_clinic_name", limit: 100
    t.string "worker_permit_no", limit: 20
    t.datetime "last_examine_date"
    t.string "blood_group", limit: 3
    t.string "fit_ind", limit: 1
    t.string "employer_code", limit: 10
    t.string "agent_code", limit: 10
    t.string "doctor_code", limit: 10
    t.string "employer_name", limit: 150
    t.string "agent_name", limit: 50
    t.string "doctor_name", limit: 50
    t.string "preferred_doctor_name", limit: 50
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "reason", limit: 255
    t.decimal "modify_id"
    t.datetime "modification_date"
    t.decimal "creator_id", precision: 10
    t.string "created_by", limit: 10
    t.string "approve_comment", limit: 4000
    t.string "approve_status", limit: 10
    t.datetime "approve_date"
    t.decimal "approve_id"
    t.decimal "justification"
    t.string "tranno", limit: 10
    t.string "country_name", limit: 50
    t.string "approve_type", limit: 50
    t.string "country_code", limit: 3
    t.string "job_type", limit: 50
    t.string "state_name", limit: 50
    t.string "district_name", limit: 50
    t.string "duration_last_exam", limit: 30
    t.string "branch_code", limit: 2
    t.string "remark", limit: 4000
    t.string "pati", limit: 1
    t.decimal "plks_no", precision: 3
    t.decimal "ispra", precision: 1
  end

  create_table "sppayment_reference", id: false, force: :cascade do |t|
    t.decimal "id", precision: 19
    t.decimal "version", precision: 19
    t.decimal "amount", precision: 126
    t.decimal "batchid", precision: 10
    t.datetime "certify_date"
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.decimal "payment_req_id", precision: 10
    t.string "transid", limit: 56
    t.string "branch_code", limit: 2
    t.string "service_provider_code", limit: 40
  end

  create_table "state_master", id: false, force: :cascade do |t|
    t.string "state_code", limit: 7
    t.string "state_name", limit: 15
    t.string "state_longname", limit: 30
    t.index ["state_code"], name: "idx_state_master_on_state_code"
  end

  create_table "state_master_rpt", id: false, force: :cascade do |t|
    t.string "state_code", limit: 7
    t.string "state_name", limit: 15
    t.string "state_ref", limit: 3
    t.index ["state_code"], name: "idx_state_master_rpt_on_state_code"
  end

  create_table "state_post_master", id: false, force: :cascade do |t|
    t.string "state_code", limit: 7
    t.string "post_code", limit: 2
    t.index ["post_code"], name: "idx_state_post_master_on_post_code"
    t.index ["state_code"], name: "idx_state_post_master_on_state_code"
  end

  create_table "status_change_history", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "trans_id", limit: 14
    t.string "old_status", limit: 1
    t.string "new_status", limit: 1
    t.string "userid", limit: 20
    t.datetime "mod_date"
    t.string "bc_worker_code", limit: 13
    t.decimal "source"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.string "wrongtrans_ind", limit: 3
    t.decimal "source_id"
    t.string "decision", limit: 20
    t.index ["bc_worker_code"], name: "idx_status_change_history_on_bc_worker_code"
    t.index ["trans_id"], name: "idx_status_change_history_on_trans_id"
    t.index ["worker_code"], name: "idx_status_change_history_on_worker_code"
  end

  create_table "status_change_pending", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "trans_id", limit: 14
    t.string "old_status", limit: 1
    t.string "new_status", limit: 1
    t.string "userid", limit: 20
    t.datetime "mod_date"
    t.string "bc_worker_code", limit: 13
    t.decimal "source"
    t.string "wrongtrans_ind", limit: 3
    t.decimal "source_id"
    t.string "decision", limit: 20
    t.index ["trans_id"], name: "idx_status_change_pending_on_trans_id"
  end

  create_table "suspension_comments", id: false, force: :cascade do |t|
    t.decimal "suspendid", precision: 10
    t.string "bc_user_code", limit: 13
    t.string "category", limit: 5
    t.string "message_type", limit: 5
    t.string "comments", limit: 1000
    t.string "old_status", limit: 5
    t.string "new_status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.datetime "suspend_start"
    t.datetime "suspend_end"
  end

  create_table "sync_table", id: false, force: :cascade do |t|
    t.string "table_name", limit: 100
    t.decimal "sequence"
  end

  create_table "t_cnv_agent_district", id: false, force: :cascade do |t|
    t.string "agent_code", limit: 10
    t.string "district_name", limit: 50
  end

  create_table "t_cnv_doctor_district", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.string "district_name", limit: 50
  end

  create_table "t_cnv_doctorh_district", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.string "version_no", limit: 10
    t.string "district_name", limit: 50
  end

  create_table "t_cnv_employer_district", id: false, force: :cascade do |t|
    t.string "employer_code", limit: 10
    t.string "district_name", limit: 50
  end

  create_table "t_cnv_employerh_district", id: false, force: :cascade do |t|
    t.string "employer_code", limit: 10
    t.string "version_no", limit: 10
    t.string "district_name", limit: 50
  end

  create_table "t_cnv_laboratory_district", id: false, force: :cascade do |t|
    t.string "laboratory_code", limit: 10
    t.string "district_name", limit: 50
  end

  create_table "t_cnv_laboratoryh_district", id: false, force: :cascade do |t|
    t.string "laboratory_code", limit: 10
    t.string "version_no", limit: 10
    t.string "district_name", limit: 50
  end

  create_table "t_cnv_worker_doctor", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "doctor_code", limit: 10
    t.datetime "certify_date"
    t.datetime "allocation_date"
  end

  create_table "t_cnv_worker_doctor_a", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "doctor_code", limit: 10
    t.datetime "certify_date"
    t.datetime "allocation_date"
  end

  create_table "t_cnv_xray_district", id: false, force: :cascade do |t|
    t.string "xray_code", limit: 10
    t.string "district_name", limit: 50
  end

  create_table "t_cnv_xrayh_district", id: false, force: :cascade do |t|
    t.string "xray_code", limit: 10
    t.string "version_no", limit: 10
    t.string "district_name", limit: 50
  end

  create_table "t_conv_fin_nongroup_doctor", id: false, force: :cascade do |t|
    t.string "nongroup_doctor", limit: 1000
    t.string "state_ref", limit: 3
    t.string "doctor_code", limit: 10
  end

  create_table "t_conv_fin_nongroup_doctor_dtl", id: false, force: :cascade do |t|
    t.string "nongroup_result", limit: 124
    t.string "state_ref", limit: 3
    t.string "doctor_code", limit: 10
  end

  create_table "t_conv_fin_nongroup_doctor_ttl", id: false, force: :cascade do |t|
    t.string "state_ref", limit: 3
    t.decimal "cnt"
    t.decimal "total"
  end

  create_table "t_conv_fin_nongroup_xray", id: false, force: :cascade do |t|
    t.string "nongroup_xray", limit: 1000
    t.string "state_ref", limit: 3
    t.string "xray_code", limit: 10
  end

  create_table "t_conv_fin_nongroup_xray_dtl", id: false, force: :cascade do |t|
    t.string "nongroup_result", limit: 124
    t.string "state_ref", limit: 3
    t.string "xray_code", limit: 10
  end

  create_table "t_conv_fin_nongroup_xray_ttl", id: false, force: :cascade do |t|
    t.string "state_ref", limit: 3
    t.decimal "cnt"
    t.decimal "total"
  end

  create_table "t_obj_migrated", id: false, force: :cascade do |t|
    t.string "object_name", limit: 30
    t.datetime "date_migrated"
  end

  create_table "t_wpc", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.string "passport_no", limit: 20
    t.string "country_name", limit: 50
    t.string "req_id", limit: 16
    t.string "err_code", limit: 5
    t.string "old_worker_code", limit: 10
    t.string "old_worker_name", limit: 50
    t.string "old_passport_no", limit: 20
    t.string "old_country_name", limit: 50
    t.string "employer_code", limit: 10
    t.string "old_employer_code", limit: 10
    t.string "emp_req_id", limit: 16
    t.string "old_emp_req_id", limit: 16
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "taggable_id", null: false
    t.string "taggable_type", limit: 255, null: false
    t.string "tag", limit: 255, null: false
    t.datetime "created_at", precision: 0
    t.datetime "updated_at", precision: 0
    t.index ["tag"], name: "tags_tag_index"
    t.index ["taggable_id", "taggable_type"], name: "tags_taggable_id_taggable_type_index"
  end

  create_table "tcupi_todolist", id: false, force: :cascade do |t|
    t.decimal "tcupi_todolist_id"
    t.string "tcupi_todolist_desc", limit: 1000
  end

  create_table "temp_pending_review_resend", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.index ["trans_id"], name: "idx_temp_pending_review_resend_on_trans_id"
  end

  create_table "temp_quarantine_fw_doc", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "fw_code", limit: 13
    t.string "doc_code", limit: 13
    t.string "d1_hiv", limit: 1
    t.datetime "d1_hiv_date"
    t.string "d1_tb", limit: 1
    t.datetime "d1_tb_date"
    t.string "d1_leprosy", limit: 1
    t.datetime "d1_leprosy_date"
    t.string "d1_hepatitis", limit: 1
    t.datetime "d1_hepatitis_date"
    t.string "d1_psych", limit: 1
    t.datetime "d1_psych_date"
    t.string "d1_epilepsy", limit: 1
    t.datetime "d1_epilepsy_date"
    t.string "d1_cancer", limit: 1
    t.datetime "d1_cancer_date"
    t.string "d1_std", limit: 1
    t.datetime "d1_std_date"
    t.string "d1_malaria", limit: 1
    t.datetime "d1_malaria_date"
    t.string "d2_hypertension", limit: 1
    t.datetime "d2_hypertension_date"
    t.string "d2_heartdisease", limit: 1
    t.datetime "d2_heartdisease_date"
    t.string "d2_asthma", limit: 1
    t.datetime "d2_asthma_date"
    t.string "d2_diabetes", limit: 1
    t.datetime "d2_diabetes_date"
    t.string "d2_ulcer", limit: 1
    t.datetime "d2_ulcer_date"
    t.string "d2_kidney", limit: 1
    t.datetime "d2_kidney_date"
    t.string "d2_others", limit: 1
    t.datetime "d2_others_date"
    t.string "d2_comments", limit: 4000
    t.string "d3_heartsize", limit: 1
    t.string "d3_heartsound", limit: 1
    t.string "d3_othercardio", limit: 1
    t.string "d3_breathsound", limit: 1
    t.string "d3_otherrespiratory", limit: 1
    t.string "d3_liver", limit: 1
    t.string "d3_spleen", limit: 1
    t.string "d3_swelling", limit: 1
    t.string "d3_lymphnodes", limit: 1
    t.string "d3_rectal", limit: 1
    t.string "d4_mental", limit: 1
    t.string "d4_speech", limit: 1
    t.string "d4_cognitive", limit: 1
    t.string "d4_peripheralnerves", limit: 1
    t.string "d4_motorpower", limit: 1
    t.string "d4_sensory", limit: 1
    t.string "d4_reflexes", limit: 1
    t.string "d4_kidney", limit: 1
    t.string "d4_gendischarge", limit: 1
    t.string "d4_gensores", limit: 1
    t.string "d4_comments", limit: 4000
    t.decimal "d5_height", precision: 10, scale: 2
    t.decimal "d5_weight", precision: 10, scale: 2
    t.decimal "d5_pulse", precision: 10, scale: 2
    t.decimal "d5_systolic", precision: 10, scale: 2
    t.decimal "d5_diastolic", precision: 10, scale: 2
    t.string "d5_skinrash", limit: 1
    t.string "d5_skinpatch", limit: 1
    t.string "d5_deformities", limit: 1
    t.string "d5_anaemia", limit: 1
    t.string "d5_jaundice", limit: 1
    t.string "d5_enlargement", limit: 1
    t.string "d5_vision_unaidedleft", limit: 1
    t.string "d5_vision_unaidedright", limit: 1
    t.string "d5_vision_aidedleft", limit: 1
    t.string "d5_vision_aidedright", limit: 1
    t.string "d5_hearingleft", limit: 1
    t.string "d5_hearingright", limit: 1
    t.string "d5_others", limit: 1
    t.string "d5_comments", limit: 4000
    t.string "d6_hiv", limit: 1
    t.string "d6_tb", limit: 1
    t.string "d6_malaria", limit: 1
    t.string "d6_leprosy", limit: 1
    t.string "d6_std", limit: 1
    t.string "d6_hepatitis", limit: 1
    t.string "d6_cancer", limit: 1
    t.string "d6_epilepsy", limit: 1
    t.string "d6_psych", limit: 1
    t.string "d6_others", limit: 1
    t.string "d6_pregnant", limit: 1
    t.string "d6_opiates", limit: 1
    t.string "d6_cannabis", limit: 1
    t.string "d7_fw_medstatus", limit: 1
    t.string "d7_comments", limit: 4000
    t.string "d7_unfit_reason", limit: 4000
    t.string "d8_notifymoh", limit: 1
    t.datetime "d8_notifymoh_date"
    t.string "d8_refergh", limit: 1
    t.datetime "d8_refergh_date"
    t.string "d8_referph", limit: 1
    t.datetime "d8_referph_date"
    t.string "d8_treatpatient", limit: 1
    t.datetime "d8_treatpatient_date"
    t.string "d8_ongoingtreatment", limit: 1
    t.datetime "d8_ongoingtreatment_date"
    t.datetime "examination_date"
    t.datetime "certification_date"
    t.string "l1_flag", limit: 1
    t.string "l1_bloodgroup", limit: 2
    t.string "l1_bloodrh", limit: 1
    t.string "l1_elisa", limit: 1
    t.string "l1_hbsag", limit: 1
    t.string "l1_vdrltpha", limit: 1
    t.string "l1_malaria", limit: 1
    t.string "l1_urineopiates", limit: 1
    t.string "l1_urinecannabis", limit: 1
    t.string "l1_urinepregnancy", limit: 1
    t.string "l1_urinecolor", limit: 1
    t.string "l1_urinegravity", limit: 1
    t.string "l1_urinesugar", limit: 1
    t.string "l1_urinesugar1plus", limit: 1
    t.string "l1_urinesugar2plus", limit: 1
    t.string "l1_urinesugar3plus", limit: 1
    t.string "l1_urinesugar4plus", limit: 1
    t.string "l1_sugarmilimoles", limit: 7
    t.string "l1_urinealbumin", limit: 1
    t.string "l1_urinealbumin1plus", limit: 1
    t.string "l1_urinealbumin2plus", limit: 1
    t.string "l1_urinealbumin3plus", limit: 1
    t.string "l1_urinealbumin4plus", limit: 1
    t.string "l1_albuminmilimoles", limit: 5
    t.string "l1_urinemicroexam", limit: 1
    t.string "l1_reason", limit: 4000
    t.datetime "l1_labresultdate"
    t.datetime "l1_specimendate"
    t.string "r1_flag", limit: 1
    t.string "r1_thoraciccage", limit: 1
    t.string "r1_heartszshape", limit: 1
    t.string "r1_lungfields", limit: 1
    t.datetime "r1_xrayresultdate"
    t.datetime "r1_xraydonedate"
    t.string "fw_name", limit: 50
    t.datetime "fw_dateofbirth"
    t.string "fw_sex", limit: 1
    t.string "fw_jobtype", limit: 50
    t.string "fw_passportno", limit: 30
    t.string "employer_code", limit: 10
    t.string "fw_countryname", limit: 50
    t.string "lab_code", limit: 13
    t.string "rad_code", limit: 13
    t.string "xray_code", limit: 13
    t.string "quarantine_reason", limit: 4000
    t.string "status", limit: 5
    t.string "inspstatus", limit: 1
    t.datetime "time_inserted"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.datetime "last_pms_date"
    t.string "d2_taken_drugs", limit: 1
    t.string "r1_focallesion", limit: 1
    t.string "r1_otherabnormalities", limit: 1
    t.string "r1_impression", limit: 4000
    t.string "r1_mediastinum", limit: 1
    t.string "r1_pleura", limit: 1
    t.string "r1_thoraciccage_detail", limit: 1000
    t.string "r1_heartszshape_detail", limit: 1000
    t.string "r1_lungfields_detail", limit: 1000
    t.string "r1_mediastinum_detail", limit: 1000
    t.string "r1_pleura_detail", limit: 1000
    t.string "r1_focallesion_detail", limit: 1000
    t.string "r1_otherabnormalities_detail", limit: 1000
    t.string "l1_tpha", limit: 1
    t.string "l1_sgvalue", limit: 20
    t.string "l1_urinemicroexam_reason", limit: 4000
    t.string "source", limit: 1
    t.string "l1_ibtv2", limit: 1
    t.string "l1_batchnum", limit: 10
    t.decimal "tcupi_letter_refid", precision: 10
    t.decimal "tcupi_xrayletter_refid", precision: 10
    t.decimal "qrtn_source", precision: 1
    t.string "process", limit: 1
    t.datetime "process_date"
    t.decimal "process_xfit_ind"
    t.index ["trans_id"], name: "idx_temp_quarantine_fw_doc_on_trans_id"
  end

  create_table "um_module_master", id: false, force: :cascade do |t|
    t.decimal "mod_id"
    t.decimal "parent_mod_id"
    t.string "mod_desc", limit: 50
    t.string "description", limit: 250
    t.datetime "modified_date"
    t.datetime "created_date"
    t.decimal "sort_order"
    t.decimal "isactive"
    t.string "url", limit: 250
  end

  create_table "um_user_capability", id: false, force: :cascade do |t|
    t.decimal "uuid", precision: 10
    t.decimal "mod_id", precision: 38
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "um_user_master", id: false, force: :cascade do |t|
    t.decimal "uuid", precision: 10
    t.decimal "passwordcount"
    t.datetime "attempdate"
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "undefine_doctor", id: false, force: :cascade do |t|
    t.string "doctor_code", limit: 10
    t.string "doctor_name", limit: 50
    t.string "clinic_name", limit: 50
    t.datetime "creation_date"
    t.string "doctor_ic_new", limit: 20
    t.string "doctor_ic_old", limit: 20
    t.string "annual_practice_certificate", limit: 20
    t.string "application_number", limit: 7
    t.string "application_year", limit: 4
    t.string "kdm_member", limit: 10
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 100
    t.string "fax", limit: 100
    t.string "state_code", limit: 7
    t.string "district_code", limit: 7
    t.string "country_code", limit: 3
    t.string "radiologist_code", limit: 10
    t.string "xray_code", limit: 10
    t.string "laboratory_code", limit: 10
    t.string "email_id", limit: 100
    t.string "xray_regn_no", limit: 20
    t.string "version_no", limit: 10
    t.string "own_xray_clinic", limit: 1
    t.string "qualification", limit: 50
    t.string "no_of_solo_clinics", limit: 2
    t.string "no_of_group_clinics", limit: 2
    t.string "status_code", limit: 5
    t.string "comments", limit: 40
    t.decimal "numquarantine", precision: 4
    t.string "district_name", limit: 15
  end

  create_table "unsuitable_reasons", id: false, force: :cascade do |t|
    t.decimal "unsuitable_id", precision: 10
    t.string "reason_eng", limit: 100
    t.string "reason_bm", limit: 100
    t.decimal "priority", precision: 10
  end

  create_table "unsuitable_reasons_map", id: false, force: :cascade do |t|
    t.string "parameter_code", limit: 10
    t.decimal "unsuitable_id", precision: 10
  end

  create_table "user_branches", id: false, force: :cascade do |t|
    t.decimal "uuid", precision: 10
    t.string "branch_code", limit: 2
  end

  create_table "user_capability", id: false, force: :cascade do |t|
    t.decimal "uuid", precision: 10
    t.decimal "capid", precision: 18
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "user_comments", id: false, force: :cascade do |t|
    t.string "msgno", limit: 10
    t.datetime "logdatetime"
    t.string "usercode", limit: 15
    t.string "subject", limit: 100
    t.string "message", limit: 4000
    t.string "email", limit: 50
  end

  create_table "user_master", id: false, force: :cascade do |t|
    t.decimal "uuid", precision: 10
    t.string "userid", limit: 20
    t.string "empid", limit: 20
    t.string "password", limit: 100
    t.decimal "passwordcount"
    t.datetime "attempdate"
    t.string "displayname", limit: 100
    t.string "gender", limit: 1
    t.string "status", limit: 5
    t.string "companyemail", limit: 100
    t.string "personalemail", limit: 100
    t.datetime "employmentdate"
    t.string "designation", limit: 50
    t.string "usertype", limit: 5
    t.decimal "roleid", precision: 10
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "branch_code", limit: 2
    t.index ["branch_code"], name: "idx_user_master_on_branch_code"
  end

  create_table "user_session", id: false, force: :cascade do |t|
    t.string "sessionid", limit: 50
    t.string "remote_address", limit: 50
    t.datetime "last_access"
    t.string "request_uri", limit: 4000
    t.decimal "timeout", precision: 10
    t.string "module", limit: 5
    t.string "userid", limit: 20
    t.string "branch_code", limit: 2
  end

  create_table "user_session_history", id: false, force: :cascade do |t|
    t.string "sessionid", limit: 50
    t.string "remote_address", limit: 50
    t.datetime "last_access"
    t.string "request_uri", limit: 4000
    t.decimal "timeout", precision: 10
  end

  create_table "usercap_detail", id: false, force: :cascade do |t|
    t.string "cap_id", limit: 10
    t.string "module_id", limit: 30
    t.string "allow_action", limit: 15
  end

  create_table "usercap_master", id: false, force: :cascade do |t|
    t.string "cap_id", limit: 10
    t.string "description", limit: 50
  end

  create_table "usermaster", id: false, force: :cascade do |t|
    t.string "userid", limit: 10
    t.string "fullname", limit: 50
    t.string "cap_id", limit: 10
    t.string "password", limit: 20
  end

  create_table "useroldpass", id: false, force: :cascade do |t|
    t.string "usercode", limit: 13
    t.string "userpass", limit: 50
    t.datetime "changedate"
  end

  create_table "userpassword_trans", id: false, force: :cascade do |t|
    t.string "uuid", limit: 20
    t.string "password", limit: 100
    t.datetime "date_change"
  end

  create_table "users", id: false, force: :cascade do |t|
    t.string "usercode", limit: 13
    t.string "username", limit: 100
    t.string "userpass", limit: 100
    t.datetime "lastlogindate"
    t.datetime "logoutdate"
    t.string "status", limit: 10
    t.string "inetuser", limit: 2
    t.decimal "loginaccess", precision: 10
    t.decimal "ismerts"
    t.decimal "islogin"
    t.string "isnewpass", limit: 1
    t.datetime "newpassdate"
    t.string "reset_sessid", limit: 100
    t.datetime "reset_date"
    t.index ["email"], name: "users_email_unique", unique: true
  end

  create_table "users", id: false, force: :cascade do |t|
    t.string "usercode", limit: 13
    t.string "username", limit: 100
    t.string "userpass", limit: 100
    t.datetime "lastlogindate"
    t.datetime "logoutdate"
    t.string "status", limit: 10
    t.string "inetuser", limit: 2
    t.decimal "loginaccess", precision: 10
    t.decimal "ismerts"
    t.decimal "islogin"
    t.string "isnewpass", limit: 1
    t.datetime "newpassdate"
    t.string "reset_sessid", limit: 100
    t.datetime "reset_date"
    t.index ["email"], name: "users_email_unique", unique: true
  end

  create_table "v_appeal_master", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "name", limit: 50
    t.string "passport_nbr", limit: 10
    t.string "employer_state", limit: 15
    t.string "certify_date", limit: 19
    t.string "officer", limit: 20
    t.string "appeal_ind", limit: 15
    t.string "comments", limit: 100
    t.string "create_date", limit: 19
    t.string "trans_id", limit: 14
    t.index ["trans_id"], name: "idx_v_appeal_master_on_trans_id"
    t.index ["worker_code"], name: "idx_v_appeal_master_on_worker_code"
  end

  create_table "v_appeal_status", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "name", limit: 50
    t.string "passport_nbr", limit: 10
    t.string "employer_state", limit: 15
    t.string "certify_date", limit: 19
    t.string "successful_date", limit: 19
    t.string "unsuccessful_date", limit: 19
    t.string "followup_date", limit: 19
    t.string "case", limit: 15
    t.string "followup_ind", limit: 1
    t.string "appeal_ind", limit: 1
    t.string "comments", limit: 100
    t.string "decision_date", limit: 19
    t.string "trans_id", limit: 14
    t.index ["trans_id"], name: "idx_v_appeal_status_on_trans_id"
  end

  create_table "v_foreign_worker_history", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "version_no", limit: 10
    t.datetime "creation_date"
    t.string "worker_name", limit: 50
    t.string "employer_code", limit: 10
    t.string "fathers_name", limit: 50
    t.string "country_code", limit: 3
    t.datetime "date_of_birth"
    t.string "passport_no", limit: 20
    t.string "visa_no", limit: 20
    t.string "sex", limit: 1
    t.string "job_type", limit: 50
    t.datetime "arrival_date"
    t.datetime "departure_date"
    t.string "agent_code", limit: 10
    t.string "blood_group", limit: 3
    t.datetime "last_examine_date"
    t.string "employer_pref_ind", limit: 1
    t.string "imm_name", limit: 50
    t.string "fomema_ind", limit: 1
    t.datetime "renewal_date"
    t.datetime "modification_date"
    t.string "bc_worker_code", limit: 13
    t.string "bc_agent_code", limit: 13
    t.string "bc_employer_code", limit: 13
    t.string "fit_ind", limit: 1
    t.string "can_renew", limit: 5
    t.string "ismonitor", limit: 5
    t.string "isimmblock", limit: 5
    t.decimal "creator_id", precision: 10
    t.decimal "modify_id", precision: 10
    t.string "status_code", limit: 5
    t.decimal "ply_count", precision: 10
    t.string "ply_printed", limit: 5
    t.string "isblacklisted", limit: 5
    t.datetime "blacklisted_date"
    t.datetime "visa_expiry_date"
    t.string "rh", limit: 1
    t.string "classification", limit: 5
    t.string "action", limit: 10
    t.datetime "action_date"
    t.string "clinic_code", limit: 10
    t.datetime "clinic_examdate"
    t.string "created_by", limit: 10
    t.string "immblocked_by", limit: 3
    t.string "pati", limit: 1
    t.index ["agent_code"], name: "idx_v_foreign_worker_history_on_agent_code"
    t.index ["bc_agent_code"], name: "idx_v_foreign_worker_history_on_bc_agent_code"
    t.index ["bc_employer_code"], name: "idx_v_foreign_worker_history_on_bc_employer_code"
    t.index ["bc_worker_code"], name: "idx_v_foreign_worker_history_on_bc_worker_code"
    t.index ["clinic_code"], name: "idx_v_foreign_worker_history_on_clinic_code"
    t.index ["country_code"], name: "idx_v_foreign_worker_history_on_country_code"
    t.index ["employer_code"], name: "idx_v_foreign_worker_history_on_employer_code"
    t.index ["status_code"], name: "idx_v_foreign_worker_history_on_status_code"
    t.index ["worker_code"], name: "idx_v_foreign_worker_history_on_worker_code"
  end

  create_table "v_foreign_worker_master", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.datetime "creation_date"
    t.string "fathers_name", limit: 50
    t.datetime "date_of_birth"
    t.string "passport_no", limit: 20
    t.string "visa_no", limit: 20
    t.string "sex", limit: 1
    t.string "job_type", limit: 50
    t.datetime "arrival_date"
    t.string "version_no", limit: 10
    t.string "blood_group", limit: 3
    t.string "country_code", limit: 3
    t.datetime "departure_date"
    t.datetime "last_examine_date"
    t.string "employer_pref_ind", limit: 1
    t.string "imm_name", limit: 50
    t.string "agent_code", limit: 10
    t.string "employer_code", limit: 10
    t.string "fit_ind", limit: 1
    t.string "fomema_ind", limit: 1
    t.datetime "renewal_date"
    t.string "bc_worker_code", limit: 13
    t.string "bc_agent_code", limit: 13
    t.string "bc_employer_code", limit: 13
    t.string "can_renew", limit: 5
    t.string "ismonitor", limit: 5
    t.string "isimmblock", limit: 5
    t.decimal "creator_id", precision: 10
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "status_code", limit: 5
    t.decimal "ply_count", precision: 10
    t.string "ply_printed", limit: 5
    t.string "isblacklisted", limit: 5
    t.datetime "blacklisted_date"
    t.datetime "visa_expiry_date"
    t.string "rh", limit: 1
    t.string "classification", limit: 5
    t.string "clinic_code", limit: 10
    t.datetime "clinic_examdate"
    t.string "created_by", limit: 10
    t.string "immblocked_by", limit: 3
    t.string "pati", limit: 1
    t.index ["agent_code"], name: "idx_v_foreign_worker_master_on_agent_code"
    t.index ["bc_agent_code"], name: "idx_v_foreign_worker_master_on_bc_agent_code"
    t.index ["bc_employer_code"], name: "idx_v_foreign_worker_master_on_bc_employer_code"
    t.index ["bc_worker_code"], name: "idx_v_foreign_worker_master_on_bc_worker_code"
    t.index ["clinic_code"], name: "idx_v_foreign_worker_master_on_clinic_code"
    t.index ["country_code"], name: "idx_v_foreign_worker_master_on_country_code"
    t.index ["employer_code"], name: "idx_v_foreign_worker_master_on_employer_code"
    t.index ["status_code"], name: "idx_v_foreign_worker_master_on_status_code"
    t.index ["worker_code"], name: "idx_v_foreign_worker_master_on_worker_code"
  end

  create_table "v_user_master", id: false, force: :cascade do |t|
    t.decimal "uuid", precision: 10
    t.string "userid", limit: 20
    t.string "empid", limit: 20
    t.string "password", limit: 100
    t.decimal "passwordcount"
    t.datetime "attempdate"
    t.string "displayname", limit: 100
    t.string "gender", limit: 1
    t.string "status", limit: 5
    t.string "email_id", limit: 100
    t.datetime "employmentdate"
    t.string "designation", limit: 50
    t.string "usertype", limit: 5
    t.decimal "roleid", precision: 10
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.string "branch_code", limit: 2
  end

  create_table "v_worker_clinic", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.string "country_code", limit: 3
    t.string "clinic_code", limit: 10
    t.datetime "exam_date"
  end

  create_table "visit_plan_detail", id: false, force: :cascade do |t|
    t.decimal "plan_id"
    t.string "provider_id", limit: 10
    t.string "state_code", limit: 20
    t.string "district_code", limit: 20
    t.string "creator_id", limit: 20
    t.datetime "creation_date"
    t.string "modify_id", limit: 20
    t.datetime "modify_date"
  end

  create_table "visit_plan_master", id: false, force: :cascade do |t|
    t.decimal "plan_id"
    t.string "plan_status", limit: 1
    t.string "category", limit: 1
    t.string "creator_id", limit: 20
    t.datetime "creation_date"
    t.string "modify_id", limit: 20
    t.datetime "modify_date"
  end

  create_table "visit_rpt_docxray", id: false, force: :cascade do |t|
    t.string "provider_code", limit: 10
    t.string "facility_name", limit: 100
    t.datetime "visit_date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "fomema_officer1", limit: 50
    t.decimal "fw_present_count"
    t.string "fw_id_verification", limit: 2
    t.string "apc_serial_no", limit: 50
    t.string "healthact_regno", limit: 50
    t.string "xray_centre_lic", limit: 50
    t.datetime "xray_centre_expirydate"
    t.string "fw_written_consent", limit: 2
    t.string "disease_notification", limit: 2
    t.string "clinic_facility_adequate", limit: 2
    t.string "clinic_facility_comment", limit: 4000
    t.string "fw_medical_record", limit: 2
    t.string "lab_coc_adequate", limit: 2
    t.string "lab_coc_comment", limit: 4000
    t.string "xray_xqcc_doc_adequate", limit: 2
    t.string "xray_xqcc_doc_comment", limit: 4000
    t.string "others_comment", limit: 4000
    t.string "recommendation", limit: 4000
    t.string "fomema_officer3", limit: 50
    t.string "fomema_officer2", limit: 50
    t.string "xray_centre_storage", limit: 2
    t.string "xray_centre_operate", limit: 2
    t.datetime "report_submit_date"
    t.decimal "report_id"
    t.string "doc_rad_name", limit: 50
    t.string "cfm_apc_original", limit: 2
    t.string "healthact_registered", limit: 2
    t.datetime "creation_date"
    t.datetime "modify_date"
    t.string "creator_id", limit: 20
    t.string "modify_id", limit: 20
    t.string "insp_others", limit: 50
    t.string "moh_representative", limit: 50
    t.string "apc_year", limit: 4
    t.string "remarks", limit: 4000
    t.string "doctor_comment", limit: 4000
    t.string "type_visit", limit: 50
    t.string "interactedwith", limit: 50
    t.decimal "visit_checklist_num", precision: 19
    t.datetime "vacutainer_expirydate"
    t.string "vacutainer", limit: 2
    t.string "radiographer_name", limit: 50
    t.string "type_visit_others", limit: 50
    t.string "operation_hrs", limit: 2
    t.string "mon_hrs", limit: 50
    t.string "tue_hrs", limit: 50
    t.string "wed_hrs", limit: 50
    t.string "thu_hrs", limit: 50
    t.string "fri_hrs", limit: 50
    t.string "sat_hrs", limit: 50
    t.string "sun_hrs", limit: 50
    t.string "operation_hrs_comment", limit: 4000
    t.string "verify_fw_comment", limit: 4000
    t.string "apc_comment", limit: 4000
    t.string "xray_license_comment", limit: 4000
    t.string "fw_medical_comment", limit: 4000
    t.string "healthact_comment", limit: 4000
    t.string "fw_written_comment", limit: 4000
    t.string "disease_notification_comment", limit: 4000
    t.string "vacutainer_comment", limit: 4000
    t.string "no_disease_notify", limit: 2
    t.string "prepared_by", limit: 20
    t.datetime "prepared_date"
  end

  create_table "visit_rpt_followup", id: false, force: :cascade do |t|
    t.decimal "followup_id"
    t.decimal "visit_report_id"
    t.string "service_provider_code", limit: 10
    t.string "type", limit: 10
    t.datetime "modify_date"
    t.string "modify_id", limit: 20
  end

  create_table "visit_rpt_followup_comments", id: false, force: :cascade do |t|
    t.decimal "followup_id"
    t.datetime "createdate"
    t.decimal "addedby"
    t.string "comments", limit: 255
  end

  create_table "visit_rpt_labdetail", id: false, force: :cascade do |t|
    t.string "rpt_seq", limit: 20
    t.string "datavalue", limit: 4000
    t.decimal "report_id"
  end

  create_table "visit_rpt_labmaster", id: false, force: :cascade do |t|
    t.string "laboratory_code", limit: 10
    t.datetime "visit_date"
    t.string "visit_type", limit: 30
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "lab_category", limit: 30
    t.string "cov_districtcode", limit: 500
    t.string "attd_lab_personnel", limit: 500
    t.string "staff_pathologist", limit: 500
    t.decimal "staff_degholder_cnt"
    t.decimal "staff_dipholder_cnt"
    t.decimal "staff_technician_cnt"
    t.decimal "staff_despatch_cnt"
    t.decimal "staff_others_cnt"
    t.string "staffing", limit: 1000
    t.decimal "report_id"
    t.string "creator_id", limit: 20
    t.datetime "creation_date"
    t.string "modify_id", limit: 20
    t.datetime "modify_date"
    t.string "moh_representative", limit: 50
    t.datetime "report_submit_date"
    t.string "insp_others", limit: 50
    t.string "insp_team", limit: 500
    t.decimal "nontechnical_degree_cnt"
    t.decimal "nontechnical_diploma_cnt"
    t.decimal "nontechnical_cert_cnt"
    t.decimal "technical_degree_cnt"
    t.decimal "technical_diploma_cnt"
    t.decimal "technical_cert_cnt"
    t.decimal "despatch_degree_cnt"
    t.decimal "despatch_diploma_cnt"
    t.decimal "despatch_cert_cnt"
    t.decimal "others_degree_cnt"
    t.decimal "others_diploma_cnt"
    t.decimal "others_cert_cnt"
    t.string "referral_lab", limit: 4000
    t.index ["cov_districtcode"], name: "idx_visit_rpt_labmaster_on_cov_districtcode"
    t.index ["laboratory_code"], name: "idx_visit_rpt_labmaster_on_laboratory_code"
  end

  create_table "visit_rpt_sop_compliance", id: false, force: :cascade do |t|
    t.decimal "report_id"
    t.string "sopcomp_ind", limit: 2
    t.string "sopcomp_comments", limit: 4000
  end

  create_table "visit_rpt_xqcc", id: false, force: :cascade do |t|
    t.string "provider_code", limit: 10
    t.string "facility_name", limit: 100
    t.datetime "visit_date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "fomema_officer1", limit: 50
    t.decimal "fw_present_count"
    t.string "fw_id_verification", limit: 2
    t.string "apc_serial_no", limit: 50
    t.string "healthact_regno", limit: 50
    t.string "xray_centre_lic", limit: 50
    t.datetime "xray_centre_expirydate"
    t.string "fw_written_consent", limit: 2
    t.string "disease_notification", limit: 2
    t.string "clinic_facility_adequate", limit: 2
    t.string "clinic_facility_comment", limit: 4000
    t.string "fw_medical_record", limit: 2
    t.string "lab_coc_adequate", limit: 2
    t.string "lab_coc_comment", limit: 4000
    t.string "xray_xqcc_doc_adequate", limit: 2
    t.string "xray_xqcc_doc_comment", limit: 4000
    t.string "others_comment", limit: 4000
    t.string "recommendation", limit: 4000
    t.string "fomema_officer3", limit: 50
    t.string "fomema_officer2", limit: 50
    t.string "xray_centre_storage", limit: 2
    t.string "xray_centre_operate", limit: 2
    t.datetime "report_submit_date"
    t.decimal "report_id"
    t.string "doc_rad_name", limit: 50
    t.string "cfm_apc_original", limit: 2
    t.string "healthact_registered", limit: 2
    t.datetime "creation_date"
    t.datetime "modify_date"
    t.string "creator_id", limit: 20
    t.string "modify_id", limit: 20
    t.string "insp_others", limit: 50
    t.string "moh_representative", limit: 50
    t.string "apc_year", limit: 4
    t.string "remarks", limit: 4000
    t.string "radiographer_name", limit: 100
    t.string "rad_xray_documentation", limit: 2
    t.string "image_self_submit", limit: 2
    t.string "image_assign_radiologist", limit: 2
    t.string "duration_upload_more24h", limit: 2
    t.string "duration_upload_less24h", limit: 2
    t.string "size_of_ip_plate", limit: 20
    t.string "cr_dr_system", limit: 4000
    t.string "history_of_facility", limit: 4000
    t.string "seminar_attendees", limit: 4000
    t.string "unit_size_ip_plate", limit: 10
  end

  create_table "worker_cancel", id: false, force: :cascade do |t|
    t.string "fwcancelid", limit: 15
    t.string "admin_charge", limit: 5
    t.decimal "admin_fee", precision: 10, scale: 2
    t.decimal "refund_amount", precision: 10, scale: 2
    t.string "status", limit: 10
    t.string "version_no", limit: 10
    t.decimal "cancelled_by", precision: 10
    t.datetime "cancelled_date"
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "worker_cancel_detail", id: false, force: :cascade do |t|
    t.string "fwcancelid", limit: 15
    t.string "refundid", limit: 15
    t.string "refund_detailid", limit: 15
    t.string "trans_id", limit: 14
    t.decimal "cancelled_by", precision: 10
    t.datetime "cancelled_date"
    t.string "status", limit: 5
    t.index ["trans_id"], name: "idx_worker_cancel_detail_on_trans_id"
  end

  create_table "worker_cancel_history", id: false, force: :cascade do |t|
    t.string "fwcancelid", limit: 15
    t.string "admin_charge", limit: 5
    t.decimal "admin_fee", precision: 10, scale: 2
    t.decimal "refund_amount", precision: 10, scale: 2
    t.string "status", limit: 10
    t.string "version_no", limit: 10
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.decimal "cancelled_by", precision: 10
    t.datetime "cancelled_date"
    t.string "action", limit: 10
    t.datetime "action_date"
  end

  create_table "worker_certify_fitind", id: false, force: :cascade do |t|
    t.decimal "logid"
    t.datetime "logdate"
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.decimal "dfit_ind", precision: 1
    t.string "fit_ind", limit: 1
    t.index ["trans_id"], name: "idx_worker_certify_fitind_on_trans_id"
  end

  create_table "worker_country_dist", id: false, force: :cascade do |t|
    t.string "country_code", limit: 3
    t.decimal "fwcount"
  end

  create_table "worker_doctor_change", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "bc_worker_code", limit: 13
    t.string "bc_new_doctor_code", limit: 13
    t.string "bc_old_doctor_code", limit: 13
    t.string "bc_new_laboratory_code", limit: 13
    t.string "bc_old_laboratory_code", limit: 13
    t.string "bc_new_xray_code", limit: 13
    t.string "bc_old_xray_code", limit: 13
    t.string "bc_new_radiologist_code", limit: 13
    t.string "bc_old_radiologist_code", limit: 13
    t.string "modification_id", limit: 30
    t.datetime "modification_date"
    t.index ["trans_id"], name: "idx_worker_doctor_change_on_trans_id"
  end

  create_table "worker_doctor_change_hist", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "bc_worker_code", limit: 13
    t.string "bc_new_doctor_code", limit: 13
    t.string "bc_old_doctor_code", limit: 13
    t.string "bc_new_laboratory_code", limit: 13
    t.string "bc_old_laboratory_code", limit: 13
    t.string "bc_new_xray_code", limit: 13
    t.string "bc_old_xray_code", limit: 13
    t.string "bc_new_radiologist_code", limit: 13
    t.string "bc_old_radiologist_code", limit: 13
    t.string "modification_id", limit: 30
    t.datetime "modification_date"
    t.index ["trans_id"], name: "idx_worker_doctor_change_hist_on_trans_id"
  end

  create_table "worker_fitind_change", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "bc_worker_code", limit: 13
    t.string "change_type", limit: 2
    t.string "modification_id", limit: 30
    t.datetime "modification_date"
    t.index ["trans_id"], name: "idx_worker_fitind_change_on_trans_id"
  end

  create_table "worker_upd", id: false, force: :cascade do |t|
    t.string "old_passport_no", limit: 20
    t.string "old_worker_name", limit: 50
    t.string "old_country_name", limit: 25
    t.string "worker_code", limit: 10
    t.datetime "mod_date"
    t.string "status", limit: 1
  end

  create_table "wrong_transmission", id: false, force: :cascade do |t|
    t.decimal "case_id"
    t.string "provider_code", limit: 10
    t.string "trans_id", limit: 14
    t.datetime "trans_date"
    t.datetime "result_date"
    t.decimal "fwt_version_no"
    t.string "comments", limit: 255
    t.string "modify_id", limit: 20
    t.datetime "modify_date"
    t.decimal "version_no"
    t.index ["trans_id"], name: "idx_wrong_transmission_on_trans_id"
  end

  create_table "wrong_transmission_history", id: false, force: :cascade do |t|
    t.decimal "case_id"
    t.string "provider_code", limit: 10
    t.string "trans_id", limit: 14
    t.datetime "trans_date"
    t.datetime "result_date"
    t.decimal "fwt_version_no"
    t.string "comments", limit: 4000
    t.string "modify_id", limit: 20
    t.datetime "modify_date"
    t.decimal "version_no"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.index ["provider_code"], name: "idx_wrong_transmission_history_on_provider_code"
    t.index ["trans_id"], name: "idx_wrong_transmission_history_on_trans_id"
  end

  create_table "ws_access_token", id: false, force: :cascade do |t|
    t.datetime "last_access"
    t.string "token", limit: 50
    t.datetime "created_date"
    t.string "usercode", limit: 10
    t.string "provider_id", limit: 3
  end

  create_table "xqcc_certificate", id: false, force: :cascade do |t|
    t.string "bc_xray_code", limit: 13
    t.string "status", limit: 1
    t.string "meet_sop", limit: 1
    t.string "acceptable_quality", limit: 1
    t.string "correct_report", limit: 1
    t.string "regular_submission", limit: 1
    t.datetime "date_approval"
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "xqcc_certificate_history", id: false, force: :cascade do |t|
    t.string "bc_xray_code", limit: 13
    t.string "status", limit: 1
    t.string "meet_sop", limit: 1
    t.string "acceptable_quality", limit: 1
    t.string "correct_report", limit: 1
    t.string "regular_submission", limit: 1
    t.datetime "date_approval"
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.index ["bc_xray_code"], name: "idx_xqcc_certificate_history_on_bc_xray_code"
  end

  create_table "xqcc_comment", id: false, force: :cascade do |t|
    t.string "worker_code", limit: 10
    t.datetime "certify_date"
  end

  create_table "xqcc_comments", id: false, force: :cascade do |t|
    t.decimal "xqccid", precision: 10
    t.string "comments", limit: 4000
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "xqcc_followup", id: false, force: :cascade do |t|
    t.string "case_id", limit: 20
    t.string "action_taken", limit: 4000
    t.datetime "action_takendate"
    t.datetime "creation_date"
    t.string "creator_id", limit: 20
    t.datetime "modify_date"
    t.string "modify_id", limit: 20
    t.string "id", limit: 20
  end

  create_table "xqcc_fw_extra_comments", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.datetime "comment_date"
    t.string "comment_time", limit: 8
    t.string "userid", limit: 30
    t.string "source", limit: 1
    t.string "type", limit: 1
    t.string "comments", limit: 4000
    t.index ["trans_id"], name: "idx_xqcc_fw_extra_comments_on_trans_id"
  end

  create_table "xqcc_mle_retake", id: false, force: :cascade do |t|
    t.decimal "reason_id", precision: 10
    t.string "status", limit: 1
    t.datetime "creation_date"
    t.string "creator_id", limit: 20
    t.datetime "approval_date"
    t.string "approval_id", limit: 20
    t.string "remarks", limit: 1000
    t.string "shadow_id", limit: 14
    t.decimal "id", precision: 19
    t.string "pool_id", limit: 20
    t.string "assign_to_pcr", limit: 10
    t.string "reassign_to_pcr", limit: 10
  end

  create_table "xqcc_performance", id: false, force: :cascade do |t|
    t.decimal "letterid", precision: 10
    t.string "bc_xray_code", limit: 13
    t.decimal "letter_type"
    t.datetime "date_sent"
    t.decimal "sent_version"
    t.decimal "sent_count"
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "xqcc_quarantine_fw_doc", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "fw_code", limit: 13
    t.string "doc_code", limit: 13
    t.string "d1_hiv", limit: 1
    t.datetime "d1_hiv_date"
    t.string "d1_tb", limit: 1
    t.datetime "d1_tb_date"
    t.string "d1_leprosy", limit: 1
    t.datetime "d1_leprosy_date"
    t.string "d1_hepatitis", limit: 1
    t.datetime "d1_hepatitis_date"
    t.string "d1_psych", limit: 1
    t.datetime "d1_psych_date"
    t.string "d1_epilepsy", limit: 1
    t.datetime "d1_epilepsy_date"
    t.string "d1_cancer", limit: 1
    t.datetime "d1_cancer_date"
    t.string "d1_std", limit: 1
    t.datetime "d1_std_date"
    t.string "d1_malaria", limit: 1
    t.datetime "d1_malaria_date"
    t.string "d2_hypertension", limit: 1
    t.datetime "d2_hypertension_date"
    t.string "d2_heartdisease", limit: 1
    t.datetime "d2_heartdisease_date"
    t.string "d2_asthma", limit: 1
    t.datetime "d2_asthma_date"
    t.string "d2_diabetes", limit: 1
    t.datetime "d2_diabetes_date"
    t.string "d2_ulcer", limit: 1
    t.datetime "d2_ulcer_date"
    t.string "d2_kidney", limit: 1
    t.datetime "d2_kidney_date"
    t.string "d2_others", limit: 1
    t.datetime "d2_others_date"
    t.string "d2_comments", limit: 4000
    t.string "d3_heartsize", limit: 1
    t.string "d3_heartsound", limit: 1
    t.string "d3_othercardio", limit: 1
    t.string "d3_breathsound", limit: 1
    t.string "d3_otherrespiratory", limit: 1
    t.string "d3_liver", limit: 1
    t.string "d3_spleen", limit: 1
    t.string "d3_swelling", limit: 1
    t.string "d3_lymphnodes", limit: 1
    t.string "d3_rectal", limit: 1
    t.string "d4_mental", limit: 1
    t.string "d4_speech", limit: 1
    t.string "d4_cognitive", limit: 1
    t.string "d4_peripheralnerves", limit: 1
    t.string "d4_motorpower", limit: 1
    t.string "d4_sensory", limit: 1
    t.string "d4_reflexes", limit: 1
    t.string "d4_kidney", limit: 1
    t.string "d4_gendischarge", limit: 1
    t.string "d4_gensores", limit: 1
    t.string "d4_comments", limit: 4000
    t.decimal "d5_height", precision: 10, scale: 2
    t.decimal "d5_weight", precision: 10, scale: 2
    t.decimal "d5_pulse", precision: 10, scale: 2
    t.decimal "d5_systolic", precision: 10, scale: 2
    t.decimal "d5_diastolic", precision: 10, scale: 2
    t.string "d5_skinrash", limit: 1
    t.string "d5_skinpatch", limit: 1
    t.string "d5_deformities", limit: 1
    t.string "d5_anaemia", limit: 1
    t.string "d5_jaundice", limit: 1
    t.string "d5_enlargement", limit: 1
    t.string "d5_vision_unaidedleft", limit: 1
    t.string "d5_vision_unaidedright", limit: 1
    t.string "d5_vision_aidedleft", limit: 1
    t.string "d5_vision_aidedright", limit: 1
    t.string "d5_hearingleft", limit: 1
    t.string "d5_hearingright", limit: 1
    t.string "d5_others", limit: 1
    t.string "d5_comments", limit: 4000
    t.string "d6_hiv", limit: 1
    t.string "d6_tb", limit: 1
    t.string "d6_malaria", limit: 1
    t.string "d6_leprosy", limit: 1
    t.string "d6_std", limit: 1
    t.string "d6_hepatitis", limit: 1
    t.string "d6_cancer", limit: 1
    t.string "d6_epilepsy", limit: 1
    t.string "d6_psych", limit: 1
    t.string "d6_others", limit: 1
    t.string "d6_pregnant", limit: 1
    t.string "d6_opiates", limit: 1
    t.string "d6_cannabis", limit: 1
    t.string "d7_fw_medstatus", limit: 1
    t.string "d7_comments", limit: 4000
    t.string "d7_unfit_reason", limit: 4000
    t.string "d8_notifymoh", limit: 1
    t.datetime "d8_notifymoh_date"
    t.string "d8_refergh", limit: 1
    t.datetime "d8_refergh_date"
    t.string "d8_referph", limit: 1
    t.datetime "d8_referph_date"
    t.string "d8_treatpatient", limit: 1
    t.datetime "d8_treatpatient_date"
    t.string "d8_ongoingtreatment", limit: 1
    t.datetime "d8_ongoingtreatment_date"
    t.datetime "examination_date"
    t.datetime "certification_date"
    t.string "l1_flag", limit: 1
    t.string "l1_bloodgroup", limit: 2
    t.string "l1_bloodrh", limit: 1
    t.string "l1_elisa", limit: 1
    t.string "l1_hbsag", limit: 1
    t.string "l1_vdrltpha", limit: 1
    t.string "l1_malaria", limit: 1
    t.string "l1_urineopiates", limit: 1
    t.string "l1_urinecannabis", limit: 1
    t.string "l1_urinepregnancy", limit: 1
    t.string "l1_urinecolor", limit: 1
    t.string "l1_urinegravity", limit: 1
    t.string "l1_urinesugar", limit: 1
    t.string "l1_urinesugar1plus", limit: 1
    t.string "l1_urinesugar2plus", limit: 1
    t.string "l1_urinesugar3plus", limit: 1
    t.string "l1_urinesugar4plus", limit: 1
    t.string "l1_sugarmilimoles", limit: 6
    t.string "l1_urinealbumin", limit: 1
    t.string "l1_urinealbumin1plus", limit: 1
    t.string "l1_urinealbumin2plus", limit: 1
    t.string "l1_urinealbumin3plus", limit: 1
    t.string "l1_urinealbumin4plus", limit: 1
    t.string "l1_albuminmilimoles", limit: 5
    t.string "l1_urinemicroexam", limit: 1
    t.string "l1_reason", limit: 4000
    t.datetime "l1_labresultdate"
    t.datetime "l1_specimendate"
    t.string "r1_flag", limit: 1
    t.string "r1_thoraciccage", limit: 1
    t.string "r1_heartszshape", limit: 1
    t.string "r1_lungfields", limit: 1
    t.datetime "r1_xrayresultdate"
    t.datetime "r1_xraydonedate"
    t.string "fw_name", limit: 50
    t.datetime "fw_dateofbirth"
    t.string "fw_sex", limit: 1
    t.string "fw_jobtype", limit: 50
    t.string "fw_passportno", limit: 30
    t.string "employer_code", limit: 10
    t.string "fw_countryname", limit: 50
    t.string "lab_code", limit: 13
    t.string "rad_code", limit: 13
    t.string "xray_code", limit: 13
    t.string "quarantine_reason", limit: 4000
    t.string "status", limit: 5
    t.string "inspstatus", limit: 1
    t.datetime "time_inserted"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.datetime "last_pms_date"
    t.string "d2_taken_drugs", limit: 1
    t.string "r1_focallesion", limit: 1
    t.string "r1_otherabnormalities", limit: 1
    t.string "r1_impression", limit: 4000
    t.string "r1_mediastinum", limit: 1
    t.string "r1_pleura", limit: 1
    t.string "r1_thoraciccage_detail", limit: 1000
    t.string "r1_heartszshape_detail", limit: 1000
    t.string "r1_lungfields_detail", limit: 1000
    t.string "r1_mediastinum_detail", limit: 1000
    t.string "r1_pleura_detail", limit: 1000
    t.string "r1_focallesion_detail", limit: 1000
    t.string "r1_otherabnormalities_detail", limit: 1000
    t.string "l1_tpha", limit: 1
    t.string "l1_sgvalue", limit: 20
    t.string "l1_urinemicroexam_reason", limit: 4000
    t.string "source", limit: 1
    t.string "l1_ibtv2", limit: 1
    t.string "l1_batchnum", limit: 10
    t.decimal "tcupi_letter_refid", precision: 10
    t.decimal "tcupi_xrayletter_refid", precision: 10
    t.decimal "qrtn_source", precision: 1
    t.datetime "l1_specimentakendate"
    t.string "l1_blood_barcodeno", limit: 20
    t.string "l1_urine_barcodeno", limit: 20
    t.string "r1_xrayrefno", limit: 20
    t.string "d3_other", limit: 1
    t.string "d4_appearance", limit: 1
    t.string "d4_speechquality", limit: 1
    t.string "d4_coherent", limit: 1
    t.string "d4_relevant", limit: 1
    t.string "d4_mood", limit: 1
    t.string "d4_depressed", limit: 1
    t.string "d4_depressed1", limit: 1
    t.string "d4_depressed2", limit: 1
    t.string "d4_anxious", limit: 1
    t.string "d4_irritable", limit: 1
    t.string "d4_affect", limit: 1
    t.string "d4_thought", limit: 1
    t.string "d4_delusion", limit: 1
    t.string "d4_suicidality", limit: 1
    t.string "d4_suicidality1", limit: 1
    t.string "d4_suicidality2", limit: 1
    t.string "d4_perception", limit: 1
    t.string "d4_orientation", limit: 1
    t.string "d4_time", limit: 1
    t.string "d4_place", limit: 1
    t.string "d4_person", limit: 1
    t.string "d4_other", limit: 1
    t.string "d4_discharge", limit: 1
    t.string "d4_lump", limit: 1
    t.string "d4_axillary", limit: 1
    t.string "d4_other6", limit: 1
    t.string "l1_bloodgroup_reason", limit: 4000
    t.string "l1_bfmp", limit: 1
    t.string "l1_hcg", limit: 1
    t.string "d6_hypertension", limit: 1
    t.string "d6_heart_diseases", limit: 1
    t.string "d6_asthma", limit: 1
    t.string "d6_diabetes", limit: 1
    t.string "d6_ulcer", limit: 1
    t.string "d6_kidney", limit: 1
    t.string "d6_others6", limit: 1
    t.index ["trans_id"], name: "idx_xqcc_quarantine_fw_doc_on_trans_id"
  end

  create_table "xqcc_quarantine_fw_reason", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "bc_worker_code", limit: 13
    t.string "reason_code", limit: 10
    t.datetime "creation_date"
    t.index ["trans_id"], name: "idx_xqcc_quarantine_fw_reason_on_trans_id"
  end

  create_table "xqcc_report", id: false, force: :cascade do |t|
    t.decimal "xqccid", precision: 10
    t.string "reference_no", limit: 20
    t.string "trans_id", limit: 14
    t.string "bc_xray_code", limit: 13
    t.string "bc_worker_code", limit: 13
    t.decimal "radiographer_id", precision: 10
    t.string "radiographer_comments", limit: 4000
    t.string "radiographer_indicator", limit: 1
    t.string "issop", limit: 1
    t.string "sop_comments", limit: 4000
    t.string "ismisread", limit: 1
    t.datetime "date_received"
    t.datetime "date_reviewed"
    t.string "sent_for_audit", limit: 1
    t.datetime "date_sent_for_audit"
    t.datetime "date_audit_result_recv"
    t.string "status", limit: 5
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
    t.index ["trans_id"], name: "idx_xqcc_report_on_trans_id"
  end

  create_table "xqcc_sign", id: false, force: :cascade do |t|
    t.string "name", limit: 35
    t.string "desig", limit: 30
  end

  create_table "xqcc_stat_change_approval", id: false, force: :cascade do |t|
    t.decimal "xqccreqid", precision: 10
    t.string "status", limit: 1
    t.string "comments", limit: 4000
    t.decimal "approval_id", precision: 10
    t.datetime "approval_date"
  end

  create_table "xqcc_stat_change_reasons", id: false, force: :cascade do |t|
    t.string "reasoncode", limit: 5
    t.string "reason", limit: 255
    t.string "status", limit: 1
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modification_id", precision: 10
    t.datetime "modification_date"
  end

  create_table "xqcc_stat_change_request", id: false, force: :cascade do |t|
    t.decimal "xqccreqid", precision: 10
    t.decimal "xqccid", precision: 10
    t.string "old_status", limit: 2
    t.string "new_status", limit: 2
    t.string "radiologist_name", limit: 50
    t.string "mo_name", limit: 50
    t.string "mo_comments", limit: 1000
    t.string "reasoncode", limit: 5
    t.string "status", limit: 1
    t.decimal "request_by", precision: 10
    t.datetime "request_date"
  end

  create_table "xqcc_transid", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.index ["trans_id"], name: "idx_xqcc_transid_on_trans_id"
  end

  create_table "xqcc_unfit", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.index ["trans_id"], name: "idx_xqcc_unfit_on_trans_id"
  end

  create_table "xqcc_warehouse", id: false, force: :cascade do |t|
    t.decimal "warehouse_id"
    t.string "name", limit: 100
    t.string "address", limit: 255
    t.string "status", limit: 20
  end

  create_table "xqua_release_req_history", id: false, force: :cascade do |t|
    t.decimal "xqrrid", precision: 18
    t.string "trans_id", limit: 14
    t.string "comments", limit: 4000
    t.string "status", limit: 5
    t.string "medstatus", limit: 1
    t.decimal "request_by", precision: 10
    t.datetime "creation_date"
    t.string "ismonitor", limit: 1
    t.decimal "mle", precision: 10
    t.datetime "assessment_date"
    t.datetime "release_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modify_date"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.index ["trans_id"], name: "idx_xqua_release_req_history_on_trans_id"
  end

  create_table "xquarantine_release_approval", id: false, force: :cascade do |t|
    t.decimal "xqrreqid", precision: 10
    t.decimal "xqrrid", precision: 10
    t.string "status", limit: 1
    t.string "comments", limit: 4000
    t.decimal "approval_id", precision: 10
    t.datetime "approval_date"
  end

  create_table "xquarantine_release_request", id: false, force: :cascade do |t|
    t.decimal "xqrrid", precision: 18
    t.string "trans_id", limit: 14
    t.string "comments", limit: 4000
    t.string "status", limit: 5
    t.string "medstatus", limit: 1
    t.decimal "request_by", precision: 10
    t.datetime "creation_date"
    t.string "ismonitor", limit: 1
    t.decimal "mle", precision: 10
    t.datetime "assessment_date"
    t.datetime "release_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modify_date"
    t.string "remove_mon_comment", limit: 4000
    t.index ["trans_id"], name: "idx_xquarantine_release_request_on_trans_id"
  end

  create_table "xray_adhoc_submit_abnormal", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "xray_code", limit: 10
    t.string "xray_name", limit: 50
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.datetime "transdate"
    t.datetime "xray_submit_date"
    t.string "send_ind", limit: 5
    t.datetime "send_date"
    t.decimal "rownumber", precision: 11
    t.index ["trans_id"], name: "idx_xray_adhoc_submit_abnormal_on_trans_id"
  end

  create_table "xray_adhoc_submit_delay", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "xray_code", limit: 10
    t.string "xray_name", limit: 50
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.datetime "transdate"
    t.datetime "xray_submit_date"
    t.string "send_ind", limit: 5
    t.datetime "send_date"
    t.decimal "rownumber", precision: 11
    t.string "filetype", limit: 50
    t.index ["trans_id"], name: "idx_xray_adhoc_submit_delay_on_trans_id"
  end

  create_table "xray_adhoc_submit_history", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "xray_code", limit: 10
    t.string "xray_name", limit: 50
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.datetime "transdate"
    t.datetime "xray_submit_date"
    t.string "send_ind", limit: 5
    t.datetime "send_date"
    t.decimal "rownumber", precision: 11
    t.string "filetype", limit: 50
    t.index ["trans_id"], name: "idx_xray_adhoc_submit_history_on_trans_id"
    t.index ["worker_code"], name: "idx_xray_adhoc_submit_history_on_worker_code"
    t.index ["xray_code"], name: "idx_xray_adhoc_submit_history_on_xray_code"
  end

  create_table "xray_adhoc_submit_normal", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "xray_code", limit: 10
    t.string "xray_name", limit: 50
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.datetime "transdate"
    t.datetime "xray_submit_date"
    t.string "send_ind", limit: 5
    t.datetime "send_date"
    t.decimal "rownumber", precision: 11
    t.index ["trans_id"], name: "idx_xray_adhoc_submit_normal_on_trans_id"
  end

  create_table "xray_change_request", id: false, force: :cascade do |t|
    t.decimal "xray_cr_id", precision: 10
    t.string "xray_code", limit: 10
    t.datetime "request_date"
    t.string "request_comment", limit: 1000
    t.string "status", limit: 20
    t.decimal "approvedby", precision: 10
    t.datetime "approved_date"
    t.string "approved_comment", limit: 1000
    t.decimal "createby", precision: 10
    t.datetime "createdate"
    t.decimal "modifyby", precision: 10
    t.datetime "modifydate"
  end

  create_table "xray_change_request_detail", id: false, force: :cascade do |t|
    t.decimal "xray_cr_id", precision: 10
    t.string "cr_column", limit: 100
    t.string "cr_old", limit: 100
    t.string "cr_new", limit: 100
  end

  create_table "xray_compare", id: false, force: :cascade do |t|
    t.string "xray_code", limit: 10
    t.string "old_xray_name", limit: 50
    t.string "old_xray_regn_no", limit: 20
    t.string "new_xray_name", limit: 50
    t.string "new_xray_regn_no", limit: 20
  end

  create_table "xray_coupling", id: false, force: :cascade do |t|
    t.string "bc_xray_code", limit: 13
    t.string "bc_radiologist_code", limit: 13
    t.decimal "modify_id"
    t.datetime "modify_date"
  end

  create_table "xray_dispatch_list", id: false, force: :cascade do |t|
    t.decimal "dispatch_listid"
    t.string "bc_xray_code", limit: 10
    t.decimal "films_count"
    t.string "status", limit: 10
    t.datetime "date_sent"
    t.datetime "date_received"
    t.decimal "version_no"
    t.string "creator_id", limit: 50
    t.datetime "create_date"
    t.string "modifier_id", limit: 50
    t.datetime "modify_date"
    t.decimal "received_count"
  end

  create_table "xray_dispatch_list_details", id: false, force: :cascade do |t|
    t.decimal "dispatch_listid"
    t.string "trans_id", limit: 14
    t.string "status", limit: 10
    t.datetime "status_date"
    t.decimal "film_sequence"
    t.datetime "xray_testdone_date"
    t.index ["trans_id"], name: "idx_xray_dispatch_list_details_on_trans_id"
  end

  create_table "xray_film_audit", id: false, force: :cascade do |t|
    t.decimal "film_auditid"
    t.string "trans_id", limit: 14
    t.string "ref_transid", limit: 14
    t.string "bc_worker_code", limit: 10
    t.string "comments", limit: 1000
    t.string "creator_id", limit: 50
    t.datetime "create_date"
    t.string "modifier_id", limit: 50
    t.datetime "modify_date"
    t.index ["trans_id"], name: "idx_xray_film_audit_on_trans_id"
  end

  create_table "xray_film_movement", id: false, force: :cascade do |t|
    t.decimal "movement_id"
    t.string "trans_id", limit: 14
    t.decimal "dispatchlist_id"
    t.string "status", limit: 10
    t.datetime "status_date"
    t.string "comments", limit: 1000
    t.string "user_id", limit: 30
    t.index ["trans_id"], name: "idx_xray_film_movement_on_trans_id"
  end

  create_table "xray_film_reminder", id: false, force: :cascade do |t|
    t.decimal "film_reminderid"
    t.string "trans_id", limit: 14
    t.datetime "reminder_date"
    t.decimal "dispatch_listid"
    t.string "creator_id", limit: 50
    t.datetime "create_date"
    t.string "modifier_id", limit: 50
    t.datetime "modify_date"
    t.index ["trans_id"], name: "idx_xray_film_reminder_on_trans_id"
  end

  create_table "xray_film_storage", id: false, force: :cascade do |t|
    t.decimal "film_storageid"
    t.string "batch_number", limit: 20
    t.decimal "box_number"
    t.string "type", limit: 20
    t.string "location", limit: 100
    t.string "status", limit: 10
    t.datetime "disposal_date"
    t.string "creator_id", limit: 50
    t.datetime "create_date"
    t.string "modified_id", limit: 50
    t.datetime "modify_date"
  end

  create_table "xray_film_storage_detail", id: false, force: :cascade do |t|
    t.decimal "film_storageid"
    t.string "trans_id", limit: 14
    t.string "creator_id", limit: 50
    t.datetime "create_date"
    t.string "modified_id", limit: 50
    t.datetime "modify_date"
    t.index ["trans_id"], name: "idx_xray_film_storage_detail_on_trans_id"
  end

  create_table "xray_follow_up", id: false, force: :cascade do |t|
    t.decimal "follow_upid"
    t.string "trans_id", limit: 14
    t.string "decision", limit: 20
    t.string "can_renew", limit: 1
    t.string "comments", limit: 4000
    t.string "status", limit: 10
    t.string "creator_id", limit: 50
    t.datetime "create_date"
    t.string "modifier_id", limit: 50
    t.datetime "modify_date"
    t.string "due_to_xray", limit: 1
    t.index ["trans_id"], name: "idx_xray_follow_up_on_trans_id"
  end

  create_table "xray_history", id: false, force: :cascade do |t|
    t.string "xray_code", limit: 10
    t.datetime "creation_date"
    t.string "version_no", limit: 10
    t.string "xray_name", limit: 50
    t.string "xray_regn_no", limit: 20
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 100
    t.string "fax", limit: 100
    t.string "district_code", limit: 7
    t.string "state_code", limit: 7
    t.string "country_code", limit: 3
    t.string "email_id", limit: 100
    t.string "primary_contact_person", limit: 50
    t.string "primary_contact_phone_no", limit: 20
    t.string "qualification", limit: 50
    t.string "comments", limit: 4000
    t.string "district_name", limit: 40
    t.datetime "modification_date"
    t.string "bc_xray_code", limit: 13
    t.string "status_code", limit: 5
    t.string "classification", limit: 5
    t.decimal "creator_id", precision: 10
    t.decimal "modify_id", precision: 10
    t.decimal "grade_point", precision: 3
    t.string "license", limit: 20
    t.string "license_year", limit: 4
    t.string "xray_fac_flag", limit: 5
    t.decimal "xregid", precision: 10
    t.string "nearest_district_office", limit: 7
    t.string "xray_ic_new", limit: 20
    t.string "xray_ic_old", limit: 20
    t.string "mohlicense_status", limit: 5
    t.datetime "mohlicense_expirydate"
    t.string "action", limit: 10
    t.datetime "action_date"
    t.string "radiooperated", limit: 1
    t.string "radiologist_name", limit: 50
    t.string "apc_year", limit: 4
    t.string "apc_no", limit: 20
    t.string "mobile_no", limit: 20
    t.datetime "renewal_date"
    t.string "gst_code", limit: 20
    t.decimal "gst_tax", precision: 126
    t.decimal "male_rate", precision: 126
    t.decimal "female_rate", precision: 126
    t.string "bank_account_no", limit: 20
    t.decimal "digital_image", precision: 1
    t.decimal "mystics_ic", precision: 1
    t.string "bank_code", limit: 8
    t.decimal "gst_type", precision: 1
    t.index ["bank_code"], name: "idx_xray_history_on_bank_code"
    t.index ["bc_xray_code"], name: "idx_xray_history_on_bc_xray_code"
    t.index ["country_code"], name: "idx_xray_history_on_country_code"
    t.index ["district_code"], name: "idx_xray_history_on_district_code"
    t.index ["gst_code"], name: "idx_xray_history_on_gst_code"
    t.index ["post_code"], name: "idx_xray_history_on_post_code"
    t.index ["state_code"], name: "idx_xray_history_on_state_code"
    t.index ["status_code"], name: "idx_xray_history_on_status_code"
    t.index ["xray_code"], name: "idx_xray_history_on_xray_code"
  end

  create_table "xray_master", id: false, force: :cascade do |t|
    t.string "xray_code", limit: 10
    t.string "xray_name", limit: 50
    t.datetime "creation_date"
    t.string "xray_regn_no", limit: 20
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 100
    t.string "fax", limit: 100
    t.string "district_code", limit: 7
    t.string "state_code", limit: 7
    t.string "country_code", limit: 3
    t.string "email_id", limit: 100
    t.string "primary_contact_person", limit: 50
    t.string "primary_contact_phone_no", limit: 20
    t.string "version_no", limit: 10
    t.string "qualification", limit: 50
    t.string "status_code", limit: 5
    t.string "comments", limit: 4000
    t.string "bc_xray_code", limit: 13
    t.string "classification", limit: 5
    t.decimal "creator_id", precision: 10
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.decimal "grade_point", precision: 3
    t.string "license", limit: 20
    t.string "license_year", limit: 4
    t.string "xray_fac_flag", limit: 5
    t.decimal "xregid", precision: 10
    t.string "nearest_district_office", limit: 7
    t.string "xray_ic_new", limit: 20
    t.string "xray_ic_old", limit: 20
    t.string "mohlicense_status", limit: 5
    t.datetime "mohlicense_expirydate"
    t.string "radiooperated", limit: 1
    t.string "radiologist_name", limit: 50
    t.string "apc_year", limit: 4
    t.string "apc_no", limit: 20
    t.string "gst_code", limit: 20
    t.decimal "gst_tax", precision: 126
    t.decimal "male_rate", precision: 126
    t.decimal "female_rate", precision: 126
    t.string "bank_account_no", limit: 20
    t.decimal "gst_type", precision: 10
    t.string "bank_code", limit: 8
    t.decimal "mystics_ic"
    t.decimal "digital_image", precision: 1
    t.string "mobile_no", limit: 20
    t.datetime "renewal_date"
    t.decimal "fp_device", precision: 1
    t.string "seminar_attendees", limit: 1
    t.decimal "device_install", precision: 1
    t.index ["bank_code"], name: "idx_xray_master_on_bank_code"
    t.index ["bc_xray_code"], name: "idx_xray_master_on_bc_xray_code"
    t.index ["country_code"], name: "idx_xray_master_on_country_code"
    t.index ["district_code"], name: "idx_xray_master_on_district_code"
    t.index ["gst_code"], name: "idx_xray_master_on_gst_code"
    t.index ["post_code"], name: "idx_xray_master_on_post_code"
    t.index ["state_code"], name: "idx_xray_master_on_state_code"
    t.index ["status_code"], name: "idx_xray_master_on_status_code"
    t.index ["xray_code"], name: "idx_xray_master_on_xray_code"
  end

  create_table "xray_not_done", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "xray_code", limit: 10
    t.string "worker_code", limit: 10
    t.datetime "transdate"
    t.datetime "certify_date"
    t.datetime "xray_submit_date"
    t.datetime "release_date"
    t.decimal "xray_ded", precision: 3
    t.index ["trans_id"], name: "idx_xray_not_done_on_trans_id"
  end

  create_table "xray_payin_list", id: false, force: :cascade do |t|
    t.string "xray_code", limit: 10
    t.string "xray_payee_name", limit: 50
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "post_code", limit: 10
    t.string "district_code", limit: 7
    t.string "state_code", limit: 7
  end

  create_table "xray_radio_assignment", id: false, force: :cascade do |t|
    t.string "bc_xray_code", limit: 13
    t.string "bc_radiologist_code", limit: 13
    t.string "trans_id", limit: 14
    t.string "status", limit: 1
    t.datetime "assignment_date"
    t.datetime "lock_date"
    t.datetime "report_date"
    t.datetime "acknowledge_date"
    t.datetime "create_date"
    t.datetime "modify_date"
    t.index ["trans_id"], name: "idx_xray_radio_assignment_on_trans_id"
  end

  create_table "xray_registration", id: false, force: :cascade do |t|
    t.decimal "xregid", precision: 10
    t.string "xray_name", limit: 50
    t.string "xray_regn_no", limit: 20
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "post_code", limit: 10
    t.string "phone", limit: 25
    t.string "fax", limit: 25
    t.string "district_code", limit: 7
    t.string "state_code", limit: 7
    t.string "country_code", limit: 3
    t.string "email_id", limit: 100
    t.string "primary_contact_person", limit: 50
    t.string "primary_contact_phone_no", limit: 20
    t.string "qualification", limit: 50
    t.string "status_code", limit: 5
    t.string "comments", limit: 4000
    t.string "nearest_district_office", limit: 7
    t.string "tranno", limit: 10
    t.string "license", limit: 20
    t.string "license_year", limit: 4
    t.string "xray_ic_new", limit: 20
    t.string "xray_ic_old", limit: 20
    t.string "radiooperated", limit: 1
    t.datetime "mohlicense_expirydate"
    t.string "radiologist_name", limit: 50
    t.string "apc_year", limit: 4
    t.decimal "creator_id", precision: 10
    t.datetime "creation_date"
    t.decimal "modify_id", precision: 10
    t.datetime "modification_date"
    t.decimal "digital_image", precision: 1
  end

  create_table "xray_request", id: false, force: :cascade do |t|
    t.decimal "xregid", precision: 10
    t.decimal "approval_id", precision: 10
    t.string "status", limit: 5
    t.string "comments", limit: 4000
    t.datetime "modification_date"
  end

  create_table "xray_review_film", id: false, force: :cascade do |t|
    t.decimal "review_filmid"
    t.string "trans_id", limit: 14
    t.string "xray_code", limit: 10
    t.string "worker_code", limit: 10
    t.string "status", limit: 10
    t.string "creator_id", limit: 50
    t.datetime "create_date"
    t.string "modifier_id", limit: 50
    t.datetime "modify_date"
    t.datetime "date_sent2pcr"
    t.decimal "pcr_trans_id"
    t.index ["trans_id"], name: "idx_xray_review_film_on_trans_id"
  end

  create_table "xray_review_film_comments", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "comments", limit: 1000
    t.string "creator_id", limit: 50
    t.datetime "create_date"
    t.string "modifier_id", limit: 50
    t.datetime "modify_date"
    t.decimal "commentsid"
    t.index ["trans_id"], name: "idx_xray_review_film_comments_on_trans_id"
  end

  create_table "xray_review_film_detail", id: false, force: :cascade do |t|
    t.decimal "review_filmid"
    t.string "parameter_code", limit: 20
    t.string "parameter_value", limit: 20
    t.string "trans_id", limit: 14
    t.index ["trans_id"], name: "idx_xray_review_film_detail_on_trans_id"
  end

  create_table "xray_review_film_identical", id: false, force: :cascade do |t|
    t.decimal "review_filmid"
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.index ["trans_id"], name: "idx_xray_review_film_identical_on_trans_id"
  end

  create_table "xray_submit_daily", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "xray_code", limit: 10
    t.string "xray_name", limit: 50
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.datetime "transdate"
    t.datetime "xray_submit_date"
    t.string "send_ind", limit: 5
    t.datetime "send_date"
    t.decimal "rownumber", precision: 11
    t.index ["trans_id"], name: "idx_xray_submit_daily_on_trans_id"
  end

  create_table "xray_submit_daily_abnormal", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "xray_code", limit: 10
    t.string "xray_name", limit: 50
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.datetime "transdate"
    t.datetime "xray_submit_date"
    t.string "send_ind", limit: 5
    t.datetime "send_date"
    t.decimal "rownumber", precision: 11
    t.index ["trans_id"], name: "idx_xray_submit_daily_abnormal_on_trans_id"
  end

  create_table "xray_submit_daily_normal", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "xray_code", limit: 10
    t.string "xray_name", limit: 50
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.datetime "transdate"
    t.datetime "xray_submit_date"
    t.string "send_ind", limit: 5
    t.datetime "send_date"
    t.decimal "rownumber", precision: 11
    t.index ["trans_id"], name: "idx_xray_submit_daily_normal_on_trans_id"
  end

  create_table "xray_submit_delay", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "xray_code", limit: 10
    t.string "xray_name", limit: 50
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.datetime "transdate"
    t.datetime "xray_submit_date"
    t.string "send_ind", limit: 5
    t.datetime "send_date"
    t.decimal "rownumber", precision: 11
    t.string "filetype", limit: 50
    t.index ["trans_id"], name: "idx_xray_submit_delay_on_trans_id"
  end

  create_table "xray_submit_history", id: false, force: :cascade do |t|
    t.string "trans_id", limit: 14
    t.string "xray_code", limit: 10
    t.string "xray_name", limit: 50
    t.string "worker_code", limit: 10
    t.string "worker_name", limit: 50
    t.datetime "transdate"
    t.datetime "xray_submit_date"
    t.string "send_ind", limit: 5
    t.datetime "send_date"
    t.decimal "rownumber", precision: 11
    t.string "filetype", limit: 50
    t.index ["trans_id"], name: "idx_xray_submit_history_on_trans_id"
    t.index ["worker_code"], name: "idx_xray_submit_history_on_worker_code"
    t.index ["xray_code"], name: "idx_xray_submit_history_on_xray_code"
  end

  create_table "xray_worker_count", id: false, force: :cascade do |t|
    t.string "bc_xray_code", limit: 10
    t.decimal "last_year"
    t.decimal "this_year"
    t.datetime "modification_date"
  end

  create_table "zone_master", id: false, force: :cascade do |t|
    t.string "zone_code", limit: 2
    t.string "zone_name", limit: 30
    t.decimal "clearing_days", precision: 3
    t.decimal "interest_charge", precision: 10, scale: 2
    t.decimal "minimum_charge", precision: 10, scale: 2
    t.string "group_id", limit: 2
    t.string "state_code", limit: 7
    t.string "district_code", limit: 7
    t.index ["district_code"], name: "idx_zone_master_on_district_code"
    t.index ["state_code"], name: "idx_zone_master_on_state_code"
    t.index ["zone_code"], name: "idx_zone_master_on_zone_code"
  end

  add_foreign_key "oracle_columns", "oracle_tables", column: "table_id", name: "oracle_columns_table_id_foreign", on_delete: :cascade
end
