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

  create_table "announcement", id: false, force: :cascade do |t|
    t.decimal "id"
    t.datetime "creation_date"
    t.string "subject", limit: 250
    t.datetime "start_date"
    t.datetime "end_date"
    t.text "content"
    t.decimal "status", precision: 1
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
  end

  create_table "employer_registration", id: false, force: :cascade do |t|
    t.decimal "id"
    t.string "employer_name", limit: 150
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "state_code", limit: 7
    t.string "post_code", limit: 10
    t.string "country_code", limit: 3
    t.string "telephone", limit: 20
    t.string "fax", limit: 20
    t.string "email", limit: 100
    t.decimal "employer_type"
    t.string "company_number", limit: 20
    t.string "ic_passport_no", limit: 20
    t.string "fomema_remarks", limit: 4000
    t.datetime "creation_date"
    t.datetime "modification_date"
    t.decimal "reg_status"
    t.string "previous_employer_code", limit: 10
    t.string "employer_code", limit: 10
    t.string "contact_person", limit: 100
    t.string "password", limit: 100
    t.string "assign_to", limit: 20
    t.datetime "assign_date"
    t.decimal "use_employer_reginfo"
    t.string "district_code", limit: 7
    t.string "reg_sessid", limit: 100
  end

  create_table "employer_registration_approval", id: false, force: :cascade do |t|
    t.decimal "approve_status", precision: 10
    t.string "comments", limit: 400
    t.datetime "creation_date"
    t.decimal "creator_id", precision: 10
    t.datetime "modification_date"
    t.decimal "modify_id", precision: 10
    t.string "nios_uuid", limit: 20
    t.decimal "regid", precision: 19
  end

  create_table "fpx_bank_master", id: false, force: :cascade do |t|
    t.string "bankid", limit: 30
    t.string "bankname", limit: 100
    t.string "fpxtype", limit: 2
    t.decimal "banktype"
    t.string "banklongname", limit: 100
  end

  create_table "fw_amendment", id: false, force: :cascade do |t|
    t.decimal "id"
    t.decimal "batch_id"
    t.decimal "reg_id"
    t.string "approval_status", limit: 20
    t.string "worker_name", limit: 50
    t.string "worker_name_new", limit: 50
    t.string "passport_no", limit: 20
    t.string "passport_no_new", limit: 20
    t.datetime "dob"
    t.datetime "dob_new"
    t.string "country_code", limit: 3
    t.string "country_code_new", limit: 3
    t.string "gender", limit: 1
    t.string "gender_new", limit: 1
    t.string "approval_comments", limit: 2000
    t.datetime "created_date"
    t.string "created_by", limit: 20
    t.datetime "modified_date"
    t.string "modified_by", limit: 20
    t.string "trans_id", limit: 14
    t.string "worker_code", limit: 10
    t.string "doc_type", limit: 1
    t.string "doc_path", limit: 500
  end

  create_table "insurance_purchase", id: false, force: :cascade do |t|
    t.decimal "id"
    t.decimal "batchid"
    t.string "employer_code", limit: 10
    t.decimal "worker_regid"
    t.string "worker_name", limit: 50
    t.string "product_name", limit: 100
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "ins_svcprovider", limit: 3
    t.datetime "creation_date"
  end

  create_table "migrations", id: :serial, force: :cascade do |t|
    t.string "migration", limit: 255, null: false
    t.integer "batch", null: false
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

  create_table "payment", id: false, force: :cascade do |t|
    t.decimal "id"
    t.string "empcode", limit: 10
    t.decimal "payment_type"
    t.datetime "creation_date"
    t.decimal "amount", precision: 126
    t.string "fpx_sellerexorderno", limit: 20
    t.string "fpx_sellertxntime", limit: 20
    t.string "fpx_sellerorderno", limit: 20
    t.string "fpx_buyeremail", limit: 50
    t.decimal "wr_batchid"
    t.decimal "isposted"
    t.datetime "posted_date"
    t.decimal "status"
    t.datetime "cancel_date"
    t.string "cancel_reason", limit: 1000
    t.decimal "gst_amount", precision: 126
    t.decimal "net_amount", precision: 126
    t.datetime "nios_deposit_date"
    t.string "bank_area", limit: 20
    t.string "bank_code", limit: 20
    t.datetime "date_issue"
    t.string "payment_no", limit: 20
    t.string "zone_code", limit: 20
    t.decimal "payment_mode"
    t.decimal "other_amount", precision: 126
    t.decimal "other_amount_gst", precision: 126
    t.string "fpx_txnid", limit: 20
    t.string "fpx_method", limit: 10
    t.string "buyer_bank", limit: 100
    t.decimal "gst_tax"
    t.datetime "modification_date"
  end

  create_table "payment_log", id: false, force: :cascade do |t|
    t.decimal "id"
    t.datetime "creation_date"
    t.string "empcode", limit: 10
    t.decimal "amount"
    t.string "fpx_sellerexorderno", limit: 20
    t.string "fpx_sellertxntime", limit: 20
    t.string "fpx_sellerorderno", limit: 20
    t.string "fpx_buyeremail", limit: 50
    t.decimal "payment_posted"
    t.datetime "post_date"
    t.string "fpx_return_status", limit: 20
    t.decimal "net_amount", precision: 126
    t.decimal "gst_amount", precision: 126
    t.decimal "other_amount", precision: 126
    t.decimal "other_amount_gst", precision: 126
    t.string "fpx_txnid", limit: 20
    t.decimal "payment_type"
    t.string "batchdesc", limit: 100
    t.decimal "status"
    t.decimal "batch_id"
    t.string "fpx_method", limit: 10
    t.string "buyer_bankid", limit: 30
    t.string "buyer_bankname", limit: 100
    t.decimal "gst_tax"
  end

  create_table "support_document_path", id: false, force: :cascade do |t|
    t.decimal "regid"
    t.string "docdata", limit: 100
    t.decimal "doctype"
    t.decimal "docid"
    t.decimal "imagetype"
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

  create_table "user_log", id: false, force: :cascade do |t|
    t.string "userid", limit: 20
    t.string "log_message", limit: 4000
    t.datetime "log_date"
    t.string "sessionid", limit: 50
  end

  create_table "user_master", id: false, force: :cascade do |t|
    t.decimal "regid"
    t.string "username", limit: 100
    t.string "email", limit: 100
    t.decimal "type"
    t.string "password", limit: 100
    t.string "usercode", limit: 10
    t.decimal "status"
    t.datetime "creation_date"
    t.datetime "modification_date"
    t.decimal "islogin"
    t.datetime "logindate"
    t.string "password_reset", limit: 1
    t.string "address1", limit: 50
    t.string "address2", limit: 50
    t.string "address3", limit: 50
    t.string "address4", limit: 50
    t.string "state_code", limit: 7
    t.string "post_code", limit: 10
    t.string "country_code", limit: 3
    t.string "telephone", limit: 50
    t.string "fax", limit: 50
    t.string "company_number", limit: 20
    t.string "ic_passport_no", limit: 20
    t.string "contact_person", limit: 100
    t.string "reset_sessid", limit: 100
    t.datetime "reset_date"
    t.string "district_code", limit: 7
  end

  create_table "user_session", id: false, force: :cascade do |t|
    t.string "sessionid", limit: 50
    t.string "remote_address", limit: 50
    t.datetime "last_access"
    t.string "request_uri", limit: 4000
    t.decimal "timeout", precision: 10
    t.string "module", limit: 5
    t.string "userid", limit: 20
    t.string "browser_string", limit: 4000
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "email", limit: 255, null: false
    t.datetime "email_verified_at", precision: 0
    t.string "password", limit: 255, null: false
    t.string "remember_token", limit: 100
    t.datetime "created_at", precision: 0
    t.datetime "updated_at", precision: 0
    t.index ["email"], name: "users_email_unique", unique: true
  end

  create_table "worker_list", id: false, force: :cascade do |t|
    t.decimal "id"
    t.string "worker_name", limit: 50
    t.string "sex", limit: 1
    t.datetime "date_of_birth"
    t.string "passport_no", limit: 20
    t.string "country_code", limit: 3
    t.string "job_type", limit: 50
    t.string "employer_code", limit: 10
    t.datetime "creation_date"
    t.datetime "modification_date"
    t.datetime "arrival_date"
    t.decimal "status"
    t.string "worker_code", limit: 10
    t.decimal "ispati"
    t.decimal "pending_reg"
    t.string "invoiceno", limit: 20
    t.string "imm_date_of_birth", limit: 8
    t.string "imm_gender", limit: 1
    t.string "imm_passportno", limit: 20
    t.string "imm_nationality", limit: 3
    t.string "imm_date_of_arrival", limit: 8
    t.string "imm_doc_expiry_date", limit: 8
    t.string "imm_doc_issue_authority", limit: 3
    t.string "imm_application_number", limit: 45
    t.string "imm_afis_id", limit: 15
    t.string "imm_ners_reason_code", limit: 5
    t.string "imm_employer_name", limit: 150
    t.string "imm_employer_id", limit: 20
    t.string "imm_employer_type", limit: 3
    t.string "imm_employer_address1", limit: 40
    t.string "imm_employer_address2", limit: 40
    t.string "imm_employer_address3", limit: 40
    t.string "imm_employer_address4", limit: 40
    t.string "imm_employer_city", limit: 6
    t.string "imm_employer_state", limit: 3
    t.string "imm_employer_email", limit: 60
    t.string "imm_employer_phone_no", limit: 25
    t.string "imm_employer_postcode", limit: 15
    t.string "imm_ners_status", limit: 3
    t.string "imm_ners_message", limit: 100
    t.string "imm_transaction_id", limit: 30
    t.decimal "ispra", precision: 1
    t.decimal "plks_no", precision: 3
    t.string "imm_fp_biosl", limit: 2
    t.string "imm_fp_availability_status", limit: 3
    t.string "imm_renew_count_year", limit: 2
    t.string "imm_pra_create_id", limit: 30
    t.string "imm_fp_avail", limit: 30
    t.string "imm_worker_name", limit: 150
    t.string "error_desc", limit: 100
    t.string "error_ind", limit: 10
  end

  create_table "worker_log", id: false, force: :cascade do |t|
    t.string "invoiceno", limit: 20
    t.decimal "workerlist_id"
    t.string "doctor_code", limit: 10
  end

  create_table "worker_registration", id: false, force: :cascade do |t|
    t.decimal "id"
    t.string "worker_name", limit: 50
    t.string "sex", limit: 1
    t.datetime "date_of_birth"
    t.string "passport_no", limit: 20
    t.string "country_code", limit: 3
    t.string "job_type", limit: 50
    t.string "employer_code", limit: 10
    t.datetime "arrival_date"
    t.string "worker_code", limit: 10
    t.decimal "reg_status"
    t.string "doctor_code", limit: 10
    t.decimal "payment_method"
    t.datetime "transdate"
    t.datetime "submission_date"
    t.string "reg_remarks", limit: 4000
    t.decimal "batchid"
    t.string "previous_worker_code", limit: 10
    t.string "trans_id", limit: 14
    t.decimal "ispati"
    t.string "imm_date_of_birth", limit: 8
    t.string "imm_gender", limit: 1
    t.string "imm_passportno", limit: 20
    t.string "imm_nationality", limit: 3
    t.string "imm_date_of_arrival", limit: 8
    t.string "imm_doc_expiry_date", limit: 8
    t.string "imm_doc_issue_authority", limit: 3
    t.string "imm_application_number", limit: 45
    t.string "imm_afis_id", limit: 15
    t.string "imm_ners_reason_code", limit: 5
    t.string "imm_employer_name", limit: 150
    t.string "imm_employer_id", limit: 20
    t.string "imm_employer_type", limit: 3
    t.string "imm_employer_address1", limit: 40
    t.string "imm_employer_address2", limit: 40
    t.string "imm_employer_address3", limit: 40
    t.string "imm_employer_address4", limit: 40
    t.string "imm_employer_city", limit: 6
    t.string "imm_employer_state", limit: 3
    t.string "imm_employer_email", limit: 60
    t.string "imm_employer_phone_no", limit: 25
    t.string "imm_employer_postcode", limit: 15
    t.string "imm_ners_status", limit: 3
    t.string "imm_ners_message", limit: 100
    t.string "imm_transaction_id", limit: 30
    t.decimal "ispra", precision: 1
    t.decimal "plks_no", precision: 3
    t.string "imm_fp_biosl", limit: 2
    t.string "imm_fp_availability_status", limit: 3
    t.string "imm_renew_count_year", limit: 2
    t.string "imm_pra_create_id", limit: 30
    t.string "imm_fp_avail", limit: 30
    t.string "imm_worker_name", limit: 150
    t.string "error_desc", limit: 100
    t.string "error_ind", limit: 10
  end

  create_table "worker_registration_hdr", id: false, force: :cascade do |t|
    t.decimal "batchid"
    t.string "employer_code", limit: 10
    t.datetime "creation_date"
    t.string "batchdesc", limit: 100
    t.datetime "modification_date"
    t.string "ins_svcprovider", limit: 3
  end

  add_foreign_key "oracle_columns", "oracle_tables", column: "table_id", name: "oracle_columns_table_id_foreign", on_delete: :cascade
end
