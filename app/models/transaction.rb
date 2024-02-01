# frozen_string_literal: true

# app/models/transaction.rb
class Transaction < ApplicationRecord
    STATUSES = {
        "NEW_PENDING_APPROVAL" => "NEW PENDING APPROVAL",
        "NEW" => "NEW",
        "CANCEL_PENDING_PAYMENT" => "CANCELLATION (PENDING FOR PAYMENT)",
        # "PENDING_CANCEL_APPROVAL" => "CANCELLATION (PENDING FOR APPROVAL)",
        "CANCELLED" => "CANCELLED",
        "REJECTED" => "REJECTED",
        "EXAMINATION" => "EXAMINATION",
        "CERTIFICATION" => "CERTIFICATION",
        "REVIEW" => "REVIEW",
        "CERTIFIED" => "CERTIFIED"
    }

    MEDICAL_STATUSES = {
        "NEW" => "NEW", # new pending review case after doctor certified
        "REVIEW" => "REVIEW", # 1st MLE picked up the case
        "PENDING_APPROVAL" => "PENDING FOR APPROVAL", # 1st MLE made decision, pending 2nd MLE approval
        "PENDING_PR_QA"    => "PENDING FOR PR QA",
        # "REJECTED" => "REJECTED", # Not used
        # "APPROVED" => "APPROVED", # Not used
        "TCUPI" => "TCUPI", # when 1st MLE decision is TCUPI and 2nd MLE approved
        "TCUPI_PENDING_APPROVAL" => "PENDING FOR 2ND MLE APPROVAL", # 1st MLE made decision, pending 2nd MLE approval
        # "TCUPI_REJECTED" => "REJECTED", # Not used
        # "TCUPI_APPROVED" => "APPROVED", # Not used
        "CERTIFIED" => "CERTIFIED"
    }

    XRAY_STATUSES = {
        # MLE pending review
        "XQCC_PENDING_REVIEW" => "XQCC PENDING REVIEW",
        # "XQCC_PENDING_REVIEW_DRAFT" => "XQCC PENDING REVIEW DRAFT",
        # "XQCC_PENDING_REVIEW_APPROVAL" => "XQCC PENDING REVIEW APPROVAL",
        # "XQCC_PENDING_REVIEW_REJECTED" => "XQCC PENDING REVIEW REJECTED",
        # "XQCC_PENDING_REVIEW_APPROVED" => "XQCC PENDING REVIEW APPROVED",
        # MLE pending decision
        "XQCC_PENDING_DECISION" => "XQCC PENDING DECISION",
        "XQCC_PENDING_DECISION_APPROVAL" => "XQCC PENDING DECISION APPROVAL",
        # "XQCC_PENDING_DECISION_REJECTED" => "XQCC PENDING DECISION REJECTED",
        # radiographer
        "XQCC_POOL" => "XQCC POOL",
        "XQCC_REVIEW" => "XQCC REVIEW",
        "XQCC_RETAKE" => "XQCC RETAKE",
        "XQCC_ABORT" => "XQCC ABORT",
        # PCR
        "PCR_POOL" => "PCR POOL",
        "PCR_REVIEW" => "PCR REVIEW",
        "PCR_RETAKE" => "PCR RETAKE",
        # end
        "CERTIFIED" => "CERTIFIED"
    }

    XRAY_RETAKE_STATUSES = {
        "PENDING_RETAKE" => "PENDING RETAKE",
        "IN_PROGRESS" => "IN PROGRESS",
        "COMPLETED" => "COMPLETED"
    }

    XRAY_FILM_TYPES = {
        "DIGITAL" => "Digital",
        "ANALOG" => "Physical / Analog"
    }

    PENDING_REVIEW_TYPES = {
        "PREVIOUS_UNSUITABLE" => "PREVIOUSLY UNSUITABLE (LAST TRANSACTION)",
        "PREVIOUS_UNSUITABLE_XQCC" => "XQCC UNSUITABLE",
        "PREVIOUS_UNSUITABLE_MEDICAL" => "MEDICAL UNSUITABLE",
        "UNSUITABLE_PREVIOUS_UNSUITABLE_XQCC" => "PREVIOUSLY UNSUITABLE (LAST TRANSACTION)",
        "NORMAL_QUARANTINE" => "ABNORMAL X-RAY FINDING",
        "ABNORMAL_FINDING" => "ABNORMAL LAB/X-RAY FINDINGS WITH INCOMPLETE (NO CERTIFICATION) LAST TRANSACTION.",
    }

    XRAY_REPORTER_TYPES = [
        "SELF", "RADIOLOGIST"
    ]

    FINAL_RESULTS = {
        "SUITABLE" => "Suitable",
        "UNSUITABLE" => "Unsuitable"
    }

    FINGERPRINT_BYPASS_OPTION = {
        true => "YES",
        false => "NO"
    }

    FINGERPRINT_STATUSES = {
        "0" => "FAILED",
        "1" => "SUCCESS",
        "2" => "SKIP"
    }
    # null means haven't do the fingerprint yet

    DOCTOR_FP_RESULTS = FINGERPRINT_STATUSES
    XRAY_FP_RESULTS = FINGERPRINT_STATUSES

    SPECIAL_RENEWAL_REASONS = {
        "UNFIT" => "Unfit" # previous transaction unfit
        # "INCOMPLETE" => "Incomplete medical", # has incomplete transaction    # Not used
        # "3MONTH" => "Within 3 months", # renew within 3 months    # Not used
        # "BLOOD_GROUP_DISCREPANCY" => "Blood group discrepancy" # previous transaction with blood group discrepancy    # Not used
    }

    BYPASS_FP_VERIFICATION_DOCUMENT_TYPES = {
        "BYPASS_FPV_PASSPORT" => "PASSPORT FRONT PAGE",
        "BYPASS_FPV_ERROR_MESSAGE" => "IMAGE OF ERROR MESSAGE",
    }

    self.primary_key = "id"

    audited
    include PublicActivity::Common
    include CaptureAuthor
    include CaptureOrganization
    include ApprovalableModel
    acts_as_approval_resource
    include Sequence
    include Transaction::MedicalProcesses
    include Transaction::XqccProcesses
    include Transaction::Appeals
    extend  Transaction::Queries
    include Transaction::UnsuitableSlip
    include Transaction::SeedQuarantine
    include Transaction::SeedXqccQuarantine
    include ResetPcrReview
    include MedicalExaminationInitializer

    attr_accessor :barcode

    belongs_to :order_item,             optional: true
    belongs_to :foreign_worker,         optional: true
    belongs_to :employer,               optional: true
    belongs_to :doctor,                 optional: true
    belongs_to :laboratory,             optional: true
    belongs_to :xray_facility,          optional: true
    belongs_to :radiologist,            optional: true
    belongs_to :agency,                 optional: true
    belongs_to :change_sp_reason,   optional: true
    belongs_to :doctor_bypass_fingerprint_reason, class_name: "BypassFingerprintReason", foreign_key: "doctor_bypass_fingerprint_reason_id", optional: true
    belongs_to :xray_bypass_fingerprint_reason, class_name: "BypassFingerprintReason", foreign_key: "xray_bypass_fingerprint_reason_id", optional: true
    belongs_to :digital_xray_provider,   optional: true
    belongs_to :fw_country, class_name: "Country", optional: true
    belongs_to :fw_job_type, class_name: "JobType", optional: true
    belongs_to :created_by_user, class_name: "User", foreign_key: "created_by", optional: true

    belongs_to :pending_decision_approval_user, :class_name => :User, :foreign_key => "xray_pending_decision_approval_by", optional: true
    belongs_to :not_done_officer,       class_name: "User", foreign_key: "not_done_officer_id", inverse_of: :transactions_not_done, optional: true

    has_many :transaction_comments
    has_many :xqcc_transaction_comments
    has_many :transaction_cancels
    has_many :transaction_change_sps
    has_one :doctor_examination
    has_one :medical_examination
    has_one :laboratory_examination
    has_many :xray_examinations
    has_one :xray_examination, as: :sourceable
    has_one :last_xray_examination, -> { order(created_at: :desc) }, class_name: "XrayExamination"
    has_many :transaction_special_renewals
    belongs_to :xray_pending_review, optional: true
    has_many :xray_pending_reviews
    belongs_to :xray_pending_decision, optional: true
    has_many :xray_pending_decisions
    # latest xray_reviews
    belongs_to :xray_review, optional: true
    has_many :xqcc_pools
    has_one :xqcc_pool, -> { order(created_at: :desc) }
    has_many :xray_reviews
    has_many :pcr_pools
    has_one :pcr_pool, -> { order(created_at: :desc) }
    # latest pcr_reviews
    belongs_to :pcr_review, optional: true
    has_many :pcr_reviews
    has_one :latest_pcr_review, -> { order(created_at: :desc) }, class_name: 'PcrReview'
    has_many :xqcc_comments, through: :xray_review
    has_one :xray_pending_decision_approval, -> { where("status = ? or (status = ? and approval_decision is not null)", "XQCC_PENDING_DECISION_APPROVAL", "TRANSMITTED").order(id: :desc) }, class_name: "XrayPendingDecision"
    has_one :xray_review_approval, -> { where("status = ? or (status = ? and approval_decision is not null)", "XQCC_PENDING_DECISION_APPROVAL", "TRANSMITTED").order(id: :desc) }, class_name: "XrayPendingDecision"
    belongs_to :xray_retake, optional: true
    has_many :xray_retakes
    has_many :retake_xray_examinations, through: :xray_retakes, source: :xray_examination
    has_one :latest_xray_retake, -> { order(created_at: :desc) }, class_name: 'XrayRetake'

    has_many :medical_reviews,                  class_name: "MedicalReview",    foreign_key: "transaction_id", inverse_of: :transactionz
    has_one  :latest_medical_review,            -> { order(id: :desc) },        class_name: "MedicalReview"
    has_many :tcupi_reviews,                    class_name: "TcupiReview",      foreign_key: "transaction_id", inverse_of: :transactionz
    has_one  :latest_tcupi_review,              -> { order(id: :desc) },        class_name: "TcupiReview"
    has_many :medical_appeals,                  class_name: "MedicalAppeal",    foreign_key: "transaction_id", inverse_of: :transactionz
    has_one  :latest_medical_appeal,            -> { order(id: :desc) },        class_name: "MedicalAppeal"
    has_many :radiologists, through:            :xray_facility
    has_many :transaction_result_updates,       inverse_of: :transactionz
    has_many :transaction_amendments,           inverse_of: :transactionz
    has_one  :pending_transaction_amendment,    -> { where(approval_status: nil).order(id: :desc) }, class_name: "TransactionAmendment"
    has_many :ongoing_appeals,                  -> { where.not(status: "CLOSED") }, class_name: "MedicalAppeal"
    has_many :transaction_reversions,           class_name: "TransactionReversion", foreign_key: "transaction_id", inverse_of: :transactionz
    has_many :digital_xray_movements
    has_one  :is_latest_transaction,            class_name: "ForeignWorker", foreign_key: "latest_transaction_id"
    has_many :transaction_unsuitable_reasons,   class_name: "TransactionUnsuitableReason", foreign_key: "transaction_id"
    has_many :unsuitable_reasons,               through: :transaction_unsuitable_reasons, source: :unsuitable_reason
    has_many :unsuitable_letter_sents
    has_many :transaction_emails
    has_many :medical_form_print_logs
    has_many :transaction_quarantine_reasons,   class_name: "TransactionQuarantineReason", foreign_key: "transaction_id"
    has_many :xqcc_quarantine_reasons
    has_many :quarantine_reasons,               through: :transaction_quarantine_reasons, source: :quarantine_reason
    has_many :tcupi_letters,                    class_name: "TcupiLetter",          foreign_key: "transaction_id"
    has_many :queued_unsuitable_slips,          class_name: "QueuedUnsuitableSlip", foreign_key: "transaction_id", inverse_of: :transactionz

    # MedicalExaminationDetails.
    has_many :medical_examination_details,      class_name: "MedicalExaminationDetail",     foreign_key: "transaction_id",  inverse_of: :transactionz
    has_many :medical_examination_comments,     class_name: "MedicalExaminationComment",    foreign_key: "transaction_id",  inverse_of: :transactionz
    has_many :me_detail_conditions,             through: :medical_examination_details,      source: :condition,             inverse_of: :me_detail_transactions
    has_many :me_comment_conditions,            through: :medical_examination_comments,     source: :condition,             inverse_of: :me_comment_transactions

    # DoctorExaminationDetails.
    has_many :doctor_examination_details,       class_name: "DoctorExaminationDetail",      foreign_key: "transaction_id",  inverse_of: :transactionz
    has_many :doctor_examination_comments,      class_name: "DoctorExaminationComment",     foreign_key: "transaction_id",  inverse_of: :transactionz
    has_many :de_detail_conditions,             through: :doctor_examination_details,       source: :condition,             inverse_of: :de_detail_transactions
    has_many :de_comment_conditions,            through: :doctor_examination_comments,      source: :condition,             inverse_of: :de_comment_transactions

    # LaboratoryExaminationDetails.
    has_many :laboratory_examination_details,   class_name: "LaboratoryExaminationDetail",  foreign_key: "transaction_id",  inverse_of: :transactionz
    has_many :laboratory_examination_comments,  class_name: "LaboratoryExaminationComment", foreign_key: "transaction_id",  inverse_of: :transactionz
    has_many :le_detail_conditions,             through: :laboratory_examination_details,   source: :condition,             inverse_of: :le_detail_transactions
    has_many :le_comment_conditions,            through: :laboratory_examination_comments,  source: :condition,             inverse_of: :le_comment_transactions

    # XrayExaminationDetails.
    has_many :xray_examination_details,         class_name: "XrayExaminationDetail",        foreign_key: "transaction_id",  inverse_of: :transactionz
    has_many :xray_examination_comments,        class_name: "XrayExaminationComment",       foreign_key: "transaction_id",  inverse_of: :transactionz
    has_many :xe_detail_conditions,             through: :xray_examination_details,         source: :condition,             inverse_of: :xe_detail_transactions
    has_many :xe_comment_conditions,            through: :xray_examination_comments,        source: :condition,             inverse_of: :xe_comment_transactions

    # MedicalAppealConditions.
    has_many :medical_appeal_conditions,        class_name: "MedicalAppealCondition",       foreign_key: "transaction_id",  inverse_of: :transactionz

    # finance
    has_many :sp_transactions_payments
    has_many :sp_fin_batch_item

    #myimms
    has_one :myimms_transaction

    # details/history
    has_one :transaction_detail

    #upload doc
    has_many :uploads, as: :uploadable
    has_many :transaction_verify_docs

    # biodata
    has_one :biodata_transaction, foreign_key: "transaction_id", class_name: "BiodataTransaction"

    # xqcc
    has_many :identical_transactions, ->(transaction) {
        Transaction.joins("join xray_reviews xr2 on xr2.transaction_id = transactions.id
            join xqcc_review_identicals xri on xri.identical_xray_review_id = xr2.id
            join xray_reviews xr1 on xr1.id = xri.xray_review_id
            join transactions t1 on t1.id = xr1.transaction_id").unscope(:where).where("t1.id = ?", transaction.id)
    }, class_name: "Transaction"

    # amended_notifiable_transactions
    has_many :amended_notifiable_transactions, inverse_of: :transactionz

    # before_save :assign_sp, if: :doctor_id_changed?
    before_create :assign_transaction_date
    before_save :set_expired_at_as_date, if: -> { will_save_change_to_expired_at? }
    before_save :check_certification_status
    before_save :check_final_result, if: -> { will_save_change_to_final_result? }
    before_save :set_xray_quarantine_timestamp, if: -> { will_save_change_to_xray_status? }
    before_save :apply_registration_type, if: :foreign_worker_id_changed?
    after_create :update_code
    after_create :assign_latest_transaction
    after_create :increment_reg_ind_and_set_med_ind_count
    after_create :update_biodata_table
    after_create :assign_blood_group_benchmark
    after_save :update_transaction_details
    after_save :check_latest_transaction, if: -> { saved_changes[:status] }
    after_save :send_cancel_email, if: -> { saved_changes[:status] }
    after_save :update_doctors_quota, if: -> { saved_changes[:doctor_id] }
    after_save :reimburse_doctors_quota, if: -> { saved_changes[:status] }
    after_save :send_approval_email, if: -> { saved_changes[:approval_status] }
    after_save :update_rejected_date, if: -> { saved_changes[:approval_status] }
    after_save :submit_myimms, if: -> { [:fw_name, :fw_gender, :fw_date_of_birth, :fw_passport_number, :fw_country_id].any?{ |key| self.saved_changes.key?(key)} }
    after_save :reset_reprint_count, if: -> { saved_changes[:extended_at] }
    after_save :update_xray_film_type, if: -> { saved_changes[:xray_facility_id] }
    after_save :send_unsuitable_letter, if: -> { saved_changes[:is_imm_blocked] }
    after_save :check_amended_communicable_disease, if: -> { saved_changes[:condition_amended_at] }

    accepts_nested_attributes_for :doctor_examination,      reject_if: :all_blank
    accepts_nested_attributes_for :medical_examination,     reject_if: :all_blank
    accepts_nested_attributes_for :xray_examination,        reject_if: :all_blank
    accepts_nested_attributes_for :laboratory_examination,  reject_if: :all_blank
    accepts_nested_attributes_for :latest_medical_review,   reject_if: :all_blank
    accepts_nested_attributes_for :latest_tcupi_review,     reject_if: :all_blank
    accepts_nested_attributes_for :latest_medical_appeal,   reject_if: :all_blank

    delegate :arrival_date, :pati, :renewal?, :country_name, to: :foreign_worker, prefix: true, allow_nil: true
    delegate :code, :name, :phone, :state_code, :displayed_address, :pic_name, :pic_phone, :state_name, :town_name, to: :employer, prefix: true, allow_nil: true
    delegate :code, :name, :town_name, :state_name, :status, to: :laboratory, prefix: true, allow_nil: true
    delegate :code, :name, :clinic_name, :town_name, :state_name, :phone, :displayed_address, to: :doctor, prefix: true, allow_nil: true
    delegate :blood_group_rhesus, :blood_group, :specimen_taken_date, :specimen_received_date, to: :laboratory_examination, allow_nil: true
    delegate :code, :name, :town_name, :state_name, to: :xray_facility, prefix: true, allow_nil: true
    delegate :physical_height, :physical_weight, :physical_pulse, :physical_blood_pressure_systolic, :physical_blood_pressure_diastolic, prefix: true, to: :medical_examination, allow_nil: true
    delegate :physical_height, :physical_weight, :physical_pulse, :physical_blood_pressure_systolic, :physical_blood_pressure_diastolic, prefix: true, to: :doctor_examination, allow_nil: true
    delegate :xray_state_name, :xray_code, :xray_license_holder_name, :xray_name, :xray_group_code,
             :lab_name, :lab_code, :lab_state_name,
             to: :transaction_detail, prefix: :detail, allow_nil: true
    delegate :name, to: :fw_job_type, prefix: true, allow_nil: true
    delegate :name, to: :fw_country, prefix: true, allow_nil: true

    scope :except_transaction_id, -> except_transaction_id {
        return if except_transaction_id.blank?
        where.not(id: except_transaction_id)
    }

    scope :xqcc_pending_review, -> {
        where.(xray_status: "XQCC_PENDING_REVIEW")
    }

    scope :xqcc_retake, -> {
        where(xray_status: 'XQCC_RETAKE')
    }

    # deprecated. replace with scope inside XrayReview
    scope :xqcc_pool, -> {
        where(xray_status: 'XQCC_POOL')
    }

    # PENDING_DECISION active case
    scope :xqcc_pending_decision, -> {
        where(xray_status: ['XQCC_PENDING_DECISION', 'XQCC_REJECTED'])
    }

    scope :xqcc_approval, -> {
        where(xray_status: ['XQCC_PENDING_DECISION_APPROVAL'])
    }

    scope :review_pending_decision_approval_case, -> (review_status) {
        case review_status
        when 'ASSIGN'
            where(xray_status: 'XQCC_PENDING_DECISION_APPROVAL')
            .where(xray_pending_decision_approval_by: nil)

        when 'SUBMITTED'
            where.not(xray_pending_decision_approval_by: nil)

        when 'SUBMITTED_APPROVED'
            where(xray_pending_decision_approval_decision: 'APPROVE')
            .where.not(xray_pending_decision_approval_by: nil)

        when 'SUBMITTED_REJECTED'
            where(xray_pending_decision_approval_decision: 'REJECT')
            .where.not(xray_pending_decision_approval_by: nil)

        when 'ALL'
            where(xray_status: 'XQCC_PENDING_DECISION_APPROVAL')
            .or(
                where.not(xray_pending_decision_approval_by: nil)
            )
        else
            xqcc_approval
        end
    }

    scope :physical_xray, -> { where(xray_film_type: 'ANALOG') }
    scope :digital_xray, -> { where(xray_film_type: 'DIGITAL') }

    # date range scopes
    scope :certified_between, ->(start_date, end_date) { where(certification_date: DateTime.parse(start_date).in_time_zone('Kuala Lumpur').beginning_of_day...DateTime.parse(end_date).in_time_zone('Kuala Lumpur').end_of_day ) }
    scope :medical_examination_date_between, ->(from, to) { where(medical_examination_date: DateTime.parse(from).in_time_zone('Kuala Lumpur').beginning_of_day..DateTime.parse(to).in_time_zone('Kuala Lumpur').end_of_day) if from.present? }
    scope :transaction_date_between, ->(start_date, end_date) { where(transaction_date: DateTime.parse(start_date).in_time_zone('Kuala Lumpur').beginning_of_day..DateTime.parse(end_date).in_time_zone('Kuala Lumpur').end_of_day) if start_date.present? }
    scope :xray_test_done_date_between, ->(from, to) { joins(:xray_examination).where(xray_examinations: { created_at: DateTime.parse(from).in_time_zone('Kuala Lumpur').beginning_of_day...DateTime.parse(to).in_time_zone('Kuala Lumpur').end_of_day }) if from.present? }
    scope :specimen_taken_date_between, ->(from, to) { joins(:laboratory_examination).where(laboratory_examinations: { specimen_taken_date: DateTime.parse(from).in_time_zone('Kuala Lumpur').beginning_of_day...DateTime.parse(to).in_time_zone('Kuala Lumpur').end_of_day }) if from.present? }
    scope :specimen_received_date_between, ->(from, to) { joins(:laboratory_examination).where(laboratory_examinations: { specimen_received_date: DateTime.parse(from).in_time_zone('Kuala Lumpur').beginning_of_day...DateTime.parse(to).in_time_zone('Kuala Lumpur').end_of_day }) if from.present? }
    scope :pcr_created_at_date_between, ->(from, to) { joins(:pcr_reviews).where(pcr_reviews: { created_at: DateTime.parse(from).in_time_zone('Kuala Lumpur').beginning_of_day...DateTime.parse(to).in_time_zone('Kuala Lumpur').end_of_day }) if from.present? }
    scope :pcr_transmitted_at_date_between, ->(from, to) { joins(:pcr_reviews).where(pcr_reviews: { transmitted_at: DateTime.parse(from).in_time_zone('Kuala Lumpur').beginning_of_day...DateTime.parse(to).in_time_zone('Kuala Lumpur').end_of_day }) if from.present? }
    # scope :by_year, -> (col,year) { where('extract(year from '+col+') = ?', year) }
    scope :by_year, -> (col,year) { where("#{col} >= ? and #{col} < ?", "#{year}-01-01", "#{year.to_i+1}-01-01") }
    # scope :created_by_year, lambda { |year| where('extract(year from transaction_date) = ?', year) }
    scope :created_by_year, lambda { |year| where('transaction_date >= ? and transaction_date < ?', "#{year}-01-01", "#{year+1}-01-01") }

    scope :have_assigned_doctor, -> (doctor_id) { doctor_id ? where(:doctor_id => doctor_id) : where.not(:doctor_id => nil) }
    scope :have_assigned_laboratory, -> { where.not(:laboratory_id => nil) }
    scope :have_assigned_xray, -> (xray_facility_id) { xray_facility_id ? where(:xray_facility_id => xray_facility_id) : where.not(:xray_facility_id => nil) }

    scope :search_organization, -> (organization) {
        return all if organization.blank?
        where('transactions.organization_id = ?', "#{organization}")
    }

    scope :current_and_past_years, lambda {
        where(created_at: 1.year.ago.beginning_of_year...DateTime.current)
    }

    scope :with_doctor_code, ->(code) { joins(:doctor).where(doctors: { code: code }) if code.present? }
    scope :with_laboratory_code, ->(code) { joins(:laboratory).where(laboratories: { code: code }) if code.present? }
    scope :with_xray_code, ->(code) { joins(:xray_facility).where(xray_facilities: { code: code }) if code.present? }

    scope :with_afis_id_count , -> {
        below_threshold_code = BypassFingerprintReason.find_by(code: 'BT').try(:id)
        not_matching_code = BypassFingerprintReason.find_by(code: 'MNF').try(:id)

        select("sum(case when worker_identity_confirmed = 'true' and doctor_fp_result = 1 and (xray_fp_result != 1 or xray_fp_result is null) then 1 else 0 end) AS doctor_count,
        sum(case when xray_worker_identity_confirmed = 'true' and xray_fp_result = 1 and (doctor_fp_result != 1 or doctor_fp_result is null) then 1 else 0 end) AS xray_count,
        sum(case when (worker_identity_confirmed = 'true' and xray_worker_identity_confirmed = 'true' and doctor_fp_result = 1 and xray_fp_result = 1) then 1 else 0 end) as both_count,
        sum((case when doctor_fp = 'true' and doctor_bypass_fingerprint_reason_id = #{below_threshold_code} then 1 else 0 end) + (case when xray_fp = 'true' and xray_bypass_fingerprint_reason_id = #{below_threshold_code} then 1 else 0 end)) as below_threshold_count,
        sum((case when doctor_fp = 'true' and doctor_bypass_fingerprint_reason_id = #{not_matching_code} then 1 else 0 end) + (case when xray_fp = 'true' and xray_bypass_fingerprint_reason_id = #{not_matching_code} then 1 else 0 end)) as not_matching_count")
    }

    # default transaction date
    scope :with_default_transaction_date, -> {
        where('transactions.transaction_date >= ?', "1998-03-14")
    }

    scope :unsuitable, -> { where(final_result: 'UNSUITABLE') }

    # for biometric and afis id report
    scope :with_biometric_count, -> {
        joins('LEFT JOIN biodata_transactions ON transactions.id = biodata_transactions.transaction_id')
        .where.not(:status => 'CANCELLED')
        .select("
        sum(case when biodata_transactions.status = 'SUCCESS' AND (biodata_transactions.afis_id is not null AND length(biodata_transactions.afis_id) > 0) AND (transactions.fw_maid_online != 'RTK') then 1 else 0 end) AS have_id_normal,
        sum(case when biodata_transactions.status = 'SUCCESS' AND (biodata_transactions.afis_id is not null AND length(biodata_transactions.afis_id) > 0) AND (transactions.fw_maid_online = 'RTK') then 1 else 0 end) AS have_id_rekab,
        sum(case when biodata_transactions.status = 'SUCCESS' AND (biodata_transactions.afis_id is not null AND length(biodata_transactions.afis_id) > 0) then 1 else 0 end) AS have_id,
        sum(case when biodata_transactions.status = 'SUCCESS' AND (biodata_transactions.afis_id is null or length(biodata_transactions.afis_id) <= 0) AND (transactions.fw_maid_online != 'RTK') then 1 else 0 end) AS no_id_normal,
        sum(case when biodata_transactions.status = 'SUCCESS' AND (biodata_transactions.afis_id is null or length(biodata_transactions.afis_id) <= 0) AND (transactions.fw_maid_online = 'RTK') then 1 else 0 end) AS no_id_rekab,
        sum(case when biodata_transactions.status = 'SUCCESS' AND (biodata_transactions.afis_id is null or length(biodata_transactions.afis_id) <= 0) then 1 else 0 end) AS no_id,
        sum(case when (biodata_transactions.id is null OR biodata_transactions.status != 'SUCCESS' OR biodata_transactions.status is null OR biodata_transactions.status = '') AND (transactions.fw_maid_online != 'RTK') then 1 else 0 end) AS no_biodata_normal,
        sum(case when (biodata_transactions.id is null OR biodata_transactions.status != 'SUCCESS' OR biodata_transactions.status is null OR biodata_transactions.status = '') AND (transactions.fw_maid_online = 'RTK') then 1 else 0 end) AS no_biodata_rekab,
        sum(case when biodata_transactions.id is null OR biodata_transactions.status != 'SUCCESS' OR biodata_transactions.status is null OR biodata_transactions.status = '' then 1 else 0 end) AS no_biodata"
        )
    }
    # end scopes

    scope :approval_requests, -> {
        joins("join approval_items on transactions.id = approval_items.resource_id join approval_requests on approval_items.request_id = approval_requests.id and approval_items.resource_type = 'Transaction'")
    }

    scope :transaction_verify_docs, ->{
        joins("join transaction_verify_docs tvs on tvs.transaction_id = transactions.id")
    }

    class << self
        alias certification_date_between certified_between
    end

    def xray_retake
        xray_retakes.last
    end

    enum registration_type: { new: 0, renewal: 1 }, _prefix: :registration_type

    # accessors
    def xqcc_pending_review_label
        type_name = Transaction::PENDING_REVIEW_TYPES[self.xray_pending_review.quarantine_type]

        if type_name.nil?
            type_name = self.xray_pending_review.quarantine_type
        end

        type_name
    end

    def xqcc_pending_review_description
        desc = nil

        case self.xray_pending_review.quarantine_type
        when "PREVIOUS_UNSUITABLE"
            desc = 'Certified SUITABLE but was previously UNSUITABLE'
        when "PREVIOUS_UNSUITABLE_XQCC"
            desc = 'Certified SUITABLE but was previously X-Ray UNSUITABLE'
        when "PREVIOUS_UNSUITABLE_MEDICAL"
            desc = 'Certified SUITABLE but was previously Medical UNSUITABLE'
        when "UNSUITABLE_PREVIOUS_UNSUITABLE_XQCC"
            desc = 'Certified UNSUITABLE but was previously X-Ray UNSUITABLE'
        when "NORMAL_QUARANTINE"
            desc = 'Worker certified SUITABLE with abnormal X-Ray findings'
        when "ABNORMAL_FINDING"
            desc = 'ABNORMAL LAB/X-RAY FINDINGS WITH INCOMPLETE (NO CERTIFICATION) LAST TRANSACTION.'
        end
        desc
    end

    def has_completed_xqcc_retake
        return false unless xray_retake.present?
        return false unless xray_retake.requestable_type == XrayReview.to_s
        return true if xray_retake.status === 'COMPLETED'
    end

    def has_completed_pcr_retake
        return false unless xray_retake.present?
        return false unless xray_retake.requestable_type == PcrReview.to_s
        return true if xray_retake.status === 'COMPLETED'
    end

    def pending_decision_user
        self.xray_pending_decision&.reviewer
    end
    # end accessors

    def assign_transaction_date
        self.transaction_date = Time.now if self.transaction_date.blank?
    end

    def update_code
        self.update_columns(code: generate_code)
    end

    def assign_latest_transaction
        # foreign_worker.update(latest_transaction_id: id)
        foreign_worker.latest_transaction_id = id
        foreign_worker.save(validate: false)
    end

    def check_latest_transaction
        if ["NEW"].include?(saved_changes["status"][1])
            # foreign_worker.update(latest_transaction_id: id)
            foreign_worker.latest_transaction_id = id
            foreign_worker.save(validate: false)
        elsif ["CANCELLED"].include?(saved_changes["status"][1])
            last_transaction = foreign_worker.transactions
            .where("transaction_date < ? and status not in (?)", self.transaction_date, ["CANCELLED", "REJECTED"])
            .order("transaction_date desc, id desc").first
            # foreign_worker.update(latest_transaction_id: last_transaction.try(:id))
            foreign_worker.latest_transaction_id = last_transaction.try(:id)
            foreign_worker.save(validate: false)
        end
    end

    def send_cancel_email
        if saved_changes["status"][1] == "CANCELLED" and !self.employer&.email.blank?
            TransactionMailer.with({
                transaction: self
            }).cancel_email.deliver_later
        end
    end

    def generate_code
        # sprintf("T%08d", self.id)
        "#{self.created_at.strftime('%Y%m%d')}#{seq_nextval('code_transaction_seq')}"
    end

    def can_extend?
        extended_at.nil? and expired_at > Time.now and ["NEW"].include?(status) and doctor_transmit_date.nil? and laboratory_transmit_date.nil? and xray_transmit_date.nil?
    end

    def can_cancel?
        fw_order_item = OrderItem.joins(:order).where(:order_itemable_type => 'ForeignWorker', :order_itemable_id => foreign_worker.id).where("orders.category in (?) and orders.status in (?)",['FOREIGN_WORKER_GENDER_AMENDMENT'],["NEW", "PENDING_PAYMENT", "PENDING_AUTHORIZATION", "PENDING"]).first
        if !fw_order_item.blank?
            gender_amendment_transaction_id = fw_order_item.get_additional_information_transaction_id
            return false if id == gender_amendment_transaction_id
        end

        ["NEW"].include?(status) and medical_examination_date.nil? and laboratory_transmit_date.nil? and xray_transmit_date.nil? and (expired_at >= Time.now || ignore_cancellation_rule?) and !foreign_worker.has_pending_gender_amendment_approval?
    end

    def can_print_medical_examination_form?
        !doctor_id.blank? && certification_date.blank? && !["NEW_PENDING_APPROVAL","UPDATE_PENDING_APPROVAL","CANCELLED","REJECTED"].include?(self.status) && !(expired_at < Time.now && [nil,'',false].include?(ignore_expiry)) && !["UPDATE_PENDING_APPROVAL"].include?(self.approval_status)
    end

    def can_print_doctor_approval_letter?
        !doctor_id.blank?
    end

    def can_print_laboratory_approval_letter?
        !laboratory_id.blank?
    end

    def can_print_xray_approval_letter?
        !xray_facility_id.blank?
    end

    def can_print_radiologist_approval_letter?
        !radiologist_id.blank?
    end

    def can_change_clinic?
        !medical_examination_date.blank? and doctor_id.blank?
    end

    def can_manual_audit?(previous_transaction)
        can_manual_audit = false

        unless previous_transaction.nil?
            if previous_transaction.xray_film_type === 'ANALOG'
                can_manual_audit = true
            end
        end

        can_manual_audit
    end

    def xqcc_pending_decision_can_edit?
        xray_status === 'XQCC_PENDING_DECISION' || xray_status === 'XQCC_PENDING_DECISION_REJECTED'
    end

    def xqcc_pending_decision_approval_can_edit?
        xray_status === 'XQCC_PENDING_DECISION_APPROVAL'
    end

    def is_maid_online?
        fw_maid_online == "PRAON"
    end

    def is_recalibration?
        fw_maid_online == "RTK"
    end

    def programme_indicator
        indicator = nil

        case fw_maid_online
        when "PRAON"
            indicator = 'MAID ONLINE'

        when "RTK"
            indicator = 'RECALIBRATION'

        else
            indicator = '-'
        end
    end

    def is_manual_audit?
        is_manual_audit = false

        if self.xray_pending_review&.decision == 'MANUAL_AUDIT'
            is_manual_audit = true
        end

        is_manual_audit
    end

    def is_xqcc_pending_review?
        self.xray_status.eql?("XQCC_PENDING_REVIEW")
    end

    def xray_retake_pending_approval?
        pending_approval = false

        if xray_retake.present? && xray_retake.status === 'APPROVAL'
            pending_approval = true
        end

        pending_approval
    end

    def xray_retake_approved?
        approved = false

        if xray_retake.present? && xray_retake.status === 'APPROVED'
            approved = true
        end

        approved
    end

    def xray_retake_completed?
        completed = false

        if xray_retake.present? && xray_retake.status === 'COMPLETED'
            completed = true
        end

        completed
    end

    def is_xray_wrong_certification?
        is_wrong = false

        if self.xray_pending_decision&.sourceable_type == 'DoctorExamination'
            is_wrong = true
        end

        is_wrong
    end

    def extend
        self.update({
            extended_at: Time.now,
            expired_at: self.calculate_extend_date
        })
    end

    def calculate_extend_date
        self.expired_at + 1.month
    end

    def expired_merts?(user_type = nil)
        med_exam_date   = medical_examination_date
        check_expiry    = med_exam_date.present? ? (med_exam_date + SystemConfiguration.get("MERTS_TRANSMISSION_EXPIRY_DAYS").to_i.days) : expired_at

        statuses_check  = case user_type
            when "Laboratory", "XrayFacility", "Radiologist"
                ["NEW", "EXAMINATION"]
            else
                ["NEW", "EXAMINATION", "CERTIFICATION", "NEW_PENDING_APPROVAL"]
            end

        check_expiry < Time.now && !ignore_expiry? && statuses_check.include?(status)
    end

    def is_expired?
        expired_at < Time.now
    end

    def valid_until
        expired_at - 1.day rescue nil
    end

    # TODO: remove this function
    # get latest xray_transaction_code if there is retake
    def xray_transaction_code(original = false)
        self.code
    end

=begin
    def assign_sp
        if self.doctor_id.blank?
            self.assign_attributes({
                laboratory_id: nil,
                xray_facility_id: nil,
                radiologist_id: nil,
            })
        else
            new_doctor = Doctor.find(self.doctor_id)
            self.assign_attributes({
                laboratory_id: new_doctor.laboratory_id,
                xray_facility_id: new_doctor.xray_facility_id,
                radiologist_id: nil,
            })
        end
    end
=end
    def update_doctors_quota
        # previous_changes[:doctor_id] returns an array of 2 items, 1st item is the original value, 2nd item the new one.
        # Doctor ID can be nil, if selecting a doctor for the transaction for the first time.
        # Will have to use saved_changes, previous_changes does not work with approval gem.
        Doctor.find(saved_changes[:doctor_id].first).update_quota_used(-1) if saved_changes[:doctor_id].first.present? && transaction_date.year == Date.today.year # Do not reimburse if transaction was registered the year before.
        Doctor.find(saved_changes[:doctor_id].second).update_quota_used(1) if saved_changes[:doctor_id].second.present?
    end

    def reimburse_doctors_quota
        if doctor_id? && saved_changes[:status].second == "CANCELLED" && transaction_date.year == Date.today.year # Do not reimburse if transaction was registered the year before.
            doctor.update_quota_used(-1)
        end
    end

    def displayed_status(user_type = nil)
        case user_type
        when "Laboratory"
            if laboratory_transmit_date?
                "Transmitted"
            elsif expired_merts?(user_type)
                status_if_expired
            elsif status == "EXAMINATION"
                "Pending for Laboratory Transmission"
            else
                status_if_expired
            end
        when "XrayFacility"
            if xray_transmit_date?
                "Transmitted"
            elsif expired_merts?(user_type)
                status_if_expired
            elsif xray_reporter_type == "RADIOLOGIST"
                xray_examination.try(:radiologist_transmitted_at).present? ? "Pending Acknowledgement" : "Assigned To Radiologist"
            elsif status == "EXAMINATION"
                "Pending for Chest X-ray Transmission"
            else
                status_if_expired
            end
        when "Radiologist"
            if xray_transmit_date?
                "Transmitted"
            elsif expired_merts?(user_type)
                status_if_expired
            elsif xray_reporter_type == "RADIOLOGIST" && xray_examination.try(:radiologist_transmitted_at).present?
                "Pending Acknowledgement by X-ray Facility"
            elsif status == "EXAMINATION"
                "Pending for Chest X-ray Transmission"
            else
                status_if_expired
            end
        when "Doctor", "Employer", "Agency"
            if expired_merts? && ["EXAMINATION", "CERTIFICATION"].include?(status)
                status_if_expired
            elsif approval_status.eql?("UPDATE_PENDING_APPROVAL")
                case approval_request&.category
                when "TRANSACTION_CHANGE_DOCTOR"
                    "Change Clinic Pending Approval"
                end
            elsif approval_status.eql?("NEW_PENDING_APPROVAL")
                case approval_request&.category
                when "TRANSACTION_SPECIAL_RENEWAL"
                    if !uploads.blank? && uploads.first&.remark == "SPECIAL_RENEWAL"
                        "Special Renewal Pending Approval"
                    else
                        "Special Renewal Pending Document"
                    end
                end
            else
                case status
                when "EXAMINATION"
                    if xray_transmit_date?
                        "Pending for Lab Transmission"
                    elsif laboratory_transmit_date?
                        "Pending for X-ray Transmission"
                    elsif xray_transmit_date.blank? && laboratory_transmit_date.blank?
                        "Pending for Lab & X-ray Transmission"
                    end
                when "CERTIFICATION"
                    "Pending for Certification"
                when "CERTIFIED"
                    if ["Employer", "Agency"].include?(user_type)
                        final_result&.titleize
                    else
                        "Certified Transaction"
                    end
                when "REVIEW"
                    if ["Employer", "Agency"].include?(user_type)
                        "FOMEMA Review"
                    else
                        medical_status != "CERTIFIED" || ["XQCC_PENDING_REVIEW", "XQCC_PENDING_DECISION", "XQCC_PENDING_DECISION_APPROVAL"].include?(xray_status) ? "Pending Review" : "Certified Transaction"
                    end
                when "REJECTED"
                    "Special Renewal Rejected"
                else
                    status_if_expired
                end
            end
        else
            case status
            when "EXAMINATION"
                if xray_transmit_date?
                    "Pending for Lab Transmission"
                elsif laboratory_transmit_date?
                    "Pending for X-ray Transmission"
                elsif xray_transmit_date.blank? && laboratory_transmit_date.blank?
                    "Pending Lab And X-ray Transmission"
                end
            when "CERTIFICATION"
                "Pending For Certification"
            when "NEW_PENDING_APPROVAL"
                case approval_request&.category
                when "TRANSACTION_SPECIAL_RENEWAL"
                end
            else
                status_if_expired
            end
        end
    end

    def status_if_expired
        if expired_merts?
            "Expired"
        elsif status == "NEW"
            doctor_id? ? "Pending Examination" : "Pending Select Clinic"
        else
            status.titleize
        end
    end

    def displayed_medical_status
        {
            "NEW"                       => "Medical Pending Review",
            "REVIEW"                    => "Medical Pending Review",
            "PENDING_APPROVAL"          => "Medical Pending Review Approval",
            "PENDING_PR_QA"             => "Medical Pending Review QA",
            "TCUPI"                     => "TCUPI",
            "TCUPI_PENDING_APPROVAL"    => "TCUPI Approval",
            "CERTIFIED"                 => medical_result
        }[medical_status]
    end

    def displayed_xqcc_pcr_status
        {
            "XQCC_PENDING_REVIEW"           => "XQCC Pending Review",
            "XQCC_PENDING_REVIEW_DRAFT"     => "XQCC Pending Review Draft",
            "XQCC_PENDING_REVIEW_APPROVAL"  => "XQCC Pending Review Approval",
            "XQCC_PENDING_REVIEW_REJECTED"  => "XQCC Pending Review Rejected",
            "XQCC_PENDING_REVIEW_APPROVED"  => "XQCC Pending Review Approved",
            "XQCC_POOL"                     => "XQCC Pool",
            "XQCC_REVIEW"                   => "XQCC Review",
            "XQCC_ABORT"                   =>  "XQCC ABORT",
            "XQCC_RETAKE"                   => "XQCC Retake",
            "PCR_POOL"                      => "PCR Pool",
            "PCR_REVIEW"                    => "PCR Review",
            "PCR_RETAKE"                    => "PCR Retake",
            "XQCC_PENDING_DECISION"         => "XQCC Pending Decision",
            "XQCC_PENDING_DECISION_APPROVAL" => "XQCC Pending Decision Approval",
            "XQCC_PENDING_DECISION_REJECTED" => "XQCC Pending Decision",
            "XQCC_REJECTED"                 => "XQCC Rejected",
            "CERTIFIED"                     => xray_result
        }[xray_status]
    end

    def display_communicable_diseases_list
        doc_exam    = doctor_examination
        return nil if doc_exam.blank?
        list        = []
        list        << "HIV"                            if doc_exam.try(:condition_hiv)
        list        << "Tuberculosis"                   if doc_exam.try(:condition_tuberculosis)
        list        << "Malaria"                        if doc_exam.try(:condition_malaria)
        list        << "Leprosy"                        if doc_exam.try(:condition_leprosy)
        list        << "Sexually Transmitted Diseases"  if doc_exam.try(:condition_std)
        list        << "Hepatitis B"                    if doc_exam.try(:condition_hepatitis)
        list.join("\n")
    end

    def older_than_14?
        ["TCUPI", "TCUPI_PENDING_APPROVAL"].include?(self.medical_status) and self.tcupi_date? and self.tcupi_date < 14.days.ago
    end

    def tcupi_duration_days
        show_duration = tcupi_date? && ["TCUPI", "TCUPI_PENDING_APPROVAL"].include?(medical_status)

        begin
            if show_duration
                (Date.today - tcupi_date.to_date).to_i
            else
                "<i>N/A</i>"
            end
        rescue
            "Error"
        end
    end

    def review_indicator
        indicator = nil

        case self.xray_pending_review&.quarantine_type
        when "PREVIOUS_UNSUITABLE_XQCC"
            indicator = 'MONITORING'

        when "PREVIOUS_UNSUITABLE_MEDICAL"
            indicator = 'MONITORING'

        when "NORMAL_QUARANTINE"
            indicator = 'QUARANTINE'

        end
    end

    # copy data for usage at xqcc mle finding, etc
    def copy_doctor_medical_examination
        doctor_examination_cols = DoctorExamination.column_names
        doctor_examination = self.doctor_examination
        copy_data = {}
        copy_cols = %w(condition_hiv condition_tuberculosis condition_malaria condition_leprosy condition_std condition_hepatitis condition_cancer condition_epilepsy condition_psychiatric_disorder condition_other condition_hypertension condition_heart_diseases condition_bronchial_asthma condition_diabetes_mellitus condition_peptic_ulcer condition_kidney_diseases condition_urine_for_pregnant condition_urine_for_opiates condition_urine_for_cannabis certification_comment)

        unless doctor_examination.nil?
            doctor_examination_cols.each do |col|
                if copy_cols.include?(col)
                    copy_data[col] = doctor_examination[col]
                end
            end
        end

        copy_data
    end

    def fw_gender_name
    case self.fw_gender
        when 'f', 'F'
            "FEMALE"
        when 'm', 'M'
            "MALE"
        else
            nil
        end
    end

    def registered_by_display
        if creator.blank?
            "None"
        else
            case creator.userable_type
            when "Organization"
                "#{ creator.try(:name) } (#{ creator.try(:userable).try(:code) })"
            when "Employer"
                "Web Portal"
            end
        end
    end

    def certified_day_taken
        # certify_date - (case when XRAY_SUBMIT_DATE > LAB_SUBMIT_DATE then XRAY_SUBMIT_DATE else LAB_SUBMIT_DATE ) - 1
        # offset applied for user SOP
        return unless certification_date
        return unless certified_day_taken_from_date

        (certification_date.to_date - certified_day_taken_from_date.to_date).to_i - 1
    end

    def lab_submit_day_taken
        # Lab: lab submit date - exam date  (minus 3)
        # offset applied for user SOP
        return unless laboratory_transmit_date
        return unless medical_examination_date

        (laboratory_transmit_date.to_date - medical_examination_date.to_date).to_i - 3
    end

    def lab_delay?
        return false unless lab_submit_day_taken

       lab_submit_day_taken > 0
    end

    def xray_submit_day_taken
        # to be used in xray delay day taken calculation
        # Xray: xray submit date - xray testdone date (minus 2)
        # offset applied for user SOP
       return unless xray_transmit_date
       return unless xray_examination

       (xray_transmit_date.to_date - xray_examination.xray_taken_date.to_date).to_i - 2
    end

    def xray_delay?
        return false unless xray_submit_day_taken

        xray_submit_day_taken > 0
    end

    def xray_test_done_date
        xray_examination.try(:xray_taken_date)
    end

    def previous_transaction
        Transaction.where("transaction_date < ? and foreign_worker_id = ? and status in (?)", self.transaction_date, self.foreign_worker_id, ["CERTIFIED"]).order(transaction_date: :desc).first
    end

    def previous_transaction_remedical
        Transaction.where("transaction_date < ? and foreign_worker_id = ? and status in (?)", self.transaction_date, self.foreign_worker_id, ["CERTIFIED","CANCELLED","REJECTED"]).order(transaction_date: :desc).first or Transaction.where("transaction_date < ? and foreign_worker_id = ?", self.transaction_date, self.foreign_worker_id).where(ignore_expiry: [false,nil,'']).where("expired_at < ?", Time.now).order(transaction_date: :desc).first
    end

    def update_transaction_details
        if saved_change_to_doctor_id? || saved_change_to_xray_facility_id? || saved_change_to_laboratory_id? || saved_change_to_radiologist_id? || saved_change_to_certification_date?
            transaction_detail = TransactionDetail.where(:transaction_id => self.id).first_or_create
            transaction_detail.update({
                doc_code: self.doctor&.code,
                doc_name: self.doctor&.name,
                doc_company_name: self.doctor&.company_name,
                doc_clinic_name: self.doctor&.clinic_name,
                doc_address1: self.doctor&.address1,
                doc_address2: self.doctor&.address2,
                doc_address3: self.doctor&.address3,
                doc_address4: self.doctor&.address4,
                doc_country_id: self.doctor&.country_id,
                doc_state_id: self.doctor&.state_id,
                doc_town_id: self.doctor&.town_id,
                doc_postcode: self.doctor&.postcode,
                doc_service_provider_group_id: self.doctor&.service_provider_group_id,
                doc_male_rate: self.doctor&.male_rate,
                doc_female_rate: self.doctor&.female_rate,
                doc_payment_method_id: self.doctor&.payment_method_id,

                lab_code: self.laboratory&.code,
                lab_name: self.laboratory&.name,
                lab_company_name: self.laboratory&.company_name,
                lab_pic_name: self.laboratory&.pic_name,
                lab_pathologist_name: self.laboratory&.pathologist_name,
                lab_address1: self.laboratory&.address1,
                lab_address2: self.laboratory&.address2,
                lab_address3: self.laboratory&.address3,
                lab_address4: self.laboratory&.address4,
                lab_country_id: self.laboratory&.country_id,
                lab_state_id: self.laboratory&.state_id,
                lab_town_id: self.laboratory&.town_id,
                lab_postcode: self.laboratory&.postcode,
                lab_service_provider_group_id: self.laboratory&.service_provider_group_id,
                lab_male_rate: self.laboratory&.male_rate,
                lab_female_rate: self.laboratory&.female_rate,
                lab_payment_method_id: self.laboratory&.payment_method_id,

                xray_code: self.xray_facility&.code,
                xray_name: self.xray_facility&.name,
                xray_company_name: self.xray_facility&.company_name,
                xray_license_holder_name: self.xray_facility&.license_holder_name,
                xray_address1: self.xray_facility&.address1,
                xray_address2: self.xray_facility&.address2,
                xray_address3: self.xray_facility&.address3,
                xray_address4: self.xray_facility&.address4,
                xray_country_id: self.xray_facility&.country_id,
                xray_state_id: self.xray_facility&.state_id,
                xray_town_id: self.xray_facility&.town_id,
                xray_postcode: self.xray_facility&.postcode,
                xray_service_provider_group_id: self.xray_facility&.service_provider_group_id,
                xray_male_rate: self.xray_facility&.male_rate,
                xray_female_rate: self.xray_facility&.female_rate,
                xray_payment_method_id: self.xray_facility&.payment_method_id,

                rad_code: self.radiologist&.code,
                rad_name: self.radiologist&.name,
                rad_xray_facility_name: self.radiologist&.xray_facility_name,
                rad_address1: self.radiologist&.address1,
                rad_address2: self.radiologist&.address2,
                rad_address3: self.radiologist&.address3,
                rad_address4: self.radiologist&.address4,
                rad_country_id: self.radiologist&.country_id,
                rad_state_id: self.radiologist&.state_id,
                rad_town_id: self.radiologist&.town_id,
                rad_postcode: self.radiologist&.postcode,

                doc_sp_group_code: self.doctor.service_provider_group&.code,
                doc_sp_group_name: self.doctor.service_provider_group&.name,
                doc_sp_group_male_rate: self.doctor.service_provider_group&.male_rate || 0,
                doc_sp_group_female_rate: self.doctor.service_provider_group&.female_rate || 0,
                doc_sp_group_payment_method_id: self.doctor.service_provider_group&.payment_method_id,

                lab_sp_group_code: self.laboratory.service_provider_group&.code,
                lab_sp_group_name: self.laboratory.service_provider_group&.name,
                lab_sp_group_male_rate: self.laboratory.service_provider_group&.male_rate || 0,
                lab_sp_group_female_rate: self.laboratory.service_provider_group&.female_rate || 0,
                lab_sp_group_payment_method_id: self.laboratory.service_provider_group&.payment_method_id,

                xray_sp_group_code: self.xray_facility.service_provider_group&.code,
                xray_sp_group_name: self.xray_facility.service_provider_group&.name,
                xray_sp_group_male_rate: self.xray_facility.service_provider_group&.male_rate || 0,
                xray_sp_group_female_rate: self.xray_facility.service_provider_group&.female_rate || 0,
                xray_sp_group_payment_method_id: self.xray_facility.service_provider_group&.payment_method_id

            })
        end
    end

    def transaction_rate(service_provider:)
       return unless transaction_detail

       transaction_detail.rate_for(service_provider, fw_gender == 'M' ? :male : :female)
    end

    def self.transaction_rate_sum(service_provider:)
        all.map do |transaction|
            # logger.info "transaction-#{transaction.id} - amout:#{transaction.transaction_rate(service_provider: service_provider)}"
            transaction.transaction_rate(service_provider: service_provider)
        end.compact.sum
    end

    def renewal?
        registration_type_renewal?
    end

    def send_approval_email
        if ['UPDATE_APPROVED','UPDATE_REJECTED'].include?(approval_status) && !self.employer&.email.blank?
            TransactionMailer.with({
                transaction: self,
                employer: self.employer,
                agency: self.try(:agency),
                do_refund: 'N'
            }).transaction_amend_email.deliver_later
        end
    end

    def update_rejected_date
        if ['NEW_REJECTED'].include?(approval_status) && self.is_special_renewal
            self.update_columns(special_renewal_rejected_at: Time.now)
        end
    end

    def check_renewal_registration?(count: 0)
        foreign_worker_id.present? &&
        foreign_worker.persisted_transactions.present? &&
        foreign_worker.persisted_transactions.count > count
    end

    def delay_status_for(source)
        case source
        when :laboratory
            lab_delay? ? 'DELAY' : 'NON-DELAY'
        when :xray
            xray_delay? ? 'DELAY' : 'NON-DELAY'
        else
            raise 'Invalid source input'
        end
    end

    def service_provider_code_for(source)
       return laboratory_code if source == :laboratory
       return xray_facility_code if source == :xray

       nil
    end

    def service_provider_name_for(source)
        return laboratory_name if source == :laboratory
        return xray_facility_name if source == :xray

        nil
    end

    def physical_height
        medical_examination_physical_height || doctor_examination_physical_height
    end

    def physical_weight
        medical_examination_physical_weight || doctor_examination_physical_weight
    end

    def physical_pulse
        medical_examination_physical_pulse || doctor_examination_physical_pulse
    end

    def physical_blood_pressure_systolic
        medical_examination_physical_blood_pressure_systolic || doctor_examination_physical_blood_pressure_systolic
    end

    def physical_blood_pressure_diastolic
        medical_examination_physical_blood_pressure_diastolic || doctor_examination_physical_blood_pressure_diastolic
    end

    def update_xray_film_type
        self.update({
            xray_film_type: self.xray_facility&.film_type
        })
    end

    def reset_reprint_count
        MedicalFormPrintLog.delete_by(transaction_id: self.id)
    end

    def is_unsuitable?
        [final_result, medical_result, xray_result].include? "UNSUITABLE"
    end

    def fw_age
       ((Time.zone.now - fw_date_of_birth.to_time) / 1.year.seconds).floor
    end

    def has_newer_transaction
        Transaction.where(foreign_worker_id: foreign_worker_id).where.not(id: id).where("transaction_date > ? and status not in (?)", transaction_date, ["CANCELLED", "REJECTED"]).present?
    end

    def xray_reported_by
        return 'G' if xray_reporter_type == 'SELF'
        return 'C' if xray_reporter_type == 'RADIOLOGIST'
    end

    def assign_blood_group_benchmark
        self.is_blood_group_benchmark = foreign_worker.previous_transaction_with_blood_group_discrepancy? ? true : false
    end

    def is_blood_group_discrepancy?
        final_result == "UNSUITABLE" && is_imm_blocked && Transaction.joins(:transaction_quarantine_reasons).where("transaction_quarantine_reasons.transaction_id = ?", id).joins(:quarantine_reasons).where("quarantine_reasons.code = ?", "10009").count > 0
    end

    def last_myimms_response_has_duplicate_error?
        Transaction.joins("JOIN myimms_transactions mt on transactions.id = mt.transaction_id")
        .joins("JOIN myimms_requests mreq on mreq.myimms_transaction_id = mt.id")
        .joins("JOIN myimms_responses mres on mres.myimms_request_id = mreq.id")
        .where("transactions.id = ?", self.id)
        .where("mres.status = 'ERROR: Duplicate record (803)' and transactions.is_imm_insert = false")
        .where("mreq.id = (select MAX(id) from myimms_requests where myimms_requests.myimms_transaction_id = mt.id)")
        .count > 0
    end

    def is_agency_transaction?
        !agency_id.nil?
    end
private
    def certified_day_taken_from_date
        return laboratory_transmit_date if xray_transmit_date.nil?
        return xray_transmit_date if laboratory_transmit_date.nil?
        return xray_transmit_date if xray_transmit_date > laboratory_transmit_date

        laboratory_transmit_date
    end

    def increment_reg_ind_and_set_med_ind_count
        last_transaction = Transaction.where.not(id: id).where(foreign_worker_id: foreign_worker_id).order(id: :desc).first

        # If first time registration or employer is not the same.
        if last_transaction.try(:employer_id) != employer_id
            foreign_worker.reg_ind = 1
        else
            increment = foreign_worker.reg_ind == 0 ? 1 : (foreign_worker.reg_ind || 0) + 1
            foreign_worker.reg_ind = increment
        end

        foreign_worker.save(validate: false)
        self.update(reg_ind: foreign_worker.reg_ind, med_ind_count: foreign_worker.med_ind_count)
    end

    def apply_registration_type
        self.registration_type = check_renewal_registration? ? :renewal : :new
    end

    def update_biodata_table
        if !self.order_item_id.blank?
            if !self.order_item.biodata_transaction.blank?
                self.order_item.biodata_transaction.update({
                    transaction_id: self.id
                })
            else
                BiodataTransaction.create({
                    order_item_id: self.order_item_id,
                    transaction_id: self.id,
                    status: self.foreign_worker&.have_biodata ? 'SUCCESS' : 'ERROR',
                    afis_id: self.foreign_worker.afis_id
                })
            end
        end
    end

    def set_xray_quarantine_timestamp
        if xray_pending_review_id? && xray_status == "CERTIFIED"
            self.xray_quarantine_release_date = Time.now
        end
    end

    def submit_myimms
        days = (SystemConfiguration.get("LAST_X_DAYS_TO_UPDATE_TRANSACTION") || '0')
        can_sync = days == '0' ? true : self.created_at >= days.to_i.days.ago

        # Do not send if physical_exam_not_done
        if !physical_exam_not_done? && !final_result_date.blank? && can_sync
            MyimmsGateway.call(id.to_s)
        end
    end

    def send_unsuitable_letter
        if !is_imm_blocked && !final_result_date.blank? && final_result == 'UNSUITABLE'
            QueuedUnsuitableSlip.create(transaction_id: id)
        end
    end

    def set_expired_at_as_date
        # Please note that it should always be at the start of the day, having timestamp 00:00:00
        self.expired_at = expired_at.to_date rescue nil
    end

    def self.search_assigned_to(assigned_to, status)
        return all if assigned_to.blank? or status.blank?

        case status
        when "bypass_fp_pending_approval", "bypass_fp_approved_rejected"
            where("exists (select 1 from transaction_verify_docs tvd where category in (?) and assigned_to = ? and transaction_id = transactions.id order by id desc limit 1)", ['DOCTOR_TRANSACTION_BYPASS_FINGERPRINT', 'XRAY_TRANSACTION_BYPASS_FINGERPRINT'], assigned_to)
        else
            approval_requests.where("approval_requests.state = 0 and approval_items.id = (SELECT MAX(id) FROM approval_items temp_ai WHERE temp_ai.resource_id = transactions.id and resource_type = 'Transaction')").where("approval_requests.assigned_to_user_id = ?", assigned_to)
        end
    end

    def self.search_request_start_date(start_date)
        return all if start_date.blank?
        approval_requests.where("approval_requests.state = 0 and approval_items.id = (SELECT MAX(id) FROM approval_items temp_ai WHERE temp_ai.resource_id = transactions.id and resource_type = 'Transaction')").where("approval_requests.created_at >= ?",start_date.to_date.beginning_of_day)
    end

    def self.search_request_end_date(end_date)
        return all if end_date.blank?
        date = end_date.to_date + 1.day
        approval_requests.where("approval_requests.state = 0 and approval_items.id = (SELECT MAX(id) FROM approval_items temp_ai WHERE temp_ai.resource_id = transactions.id and resource_type = 'Transaction')").where("approval_requests.created_at < ?",date.strftime('%Y-%m-%d'))
    end

    ##dashboard first dashboard
    def self.transaction_data_last_5_years
        current_year = Time.now.year

        transactions_data = Transaction
                              .where(created_at: (Time.new(current_year - 4, 1, 1)..Time.new(current_year, 12, 31, 23, 59, 59)))
                              .where.not(status: ['CANCELLED', 'REJECTED'])
                              .group("EXTRACT(YEAR FROM created_at)")
                              .select("EXTRACT(YEAR FROM created_at) AS year, array_agg(EXTRACT(MONTH FROM created_at) ORDER BY EXTRACT(MONTH FROM created_at)) AS months")
                              .order("EXTRACT(YEAR FROM created_at)")

        transaction_data_by_year = transactions_data.inject({}) do |result, data|
          year = data.year.to_i
          months = data.months.map(&:to_i)

          result[year] ||= Array.new(12, 0)
          months.each { |month| result[year][month - 1] += 1 }

          result
        end
        transaction_data_by_year
    end

    def self.transaction_data_between(start_time:, end_time:)
        transactions_data = Transaction
                              .where(created_at: (start_time..end_time))
                              .where.not(status: ['CANCELLED', 'REJECTED'])
                              .group("EXTRACT(YEAR FROM transactions.created_at)")
                              .select("EXTRACT(YEAR FROM transactions.created_at) AS year, array_agg(EXTRACT(MONTH FROM transactions.created_at) ORDER BY EXTRACT(MONTH FROM transactions.created_at)) AS months")
                              .order("EXTRACT(YEAR FROM transactions.created_at)")
    
        transaction_data_by_year = transactions_data.inject({}) do |result, data|
          year = data.year.to_i
          months = data.months.map(&:to_i)
    
          result[year] ||= Array.new(12, 0)
          months.each { |month| result[year][month - 1] += 1 }
    
          result
        end
        transaction_data_by_year
      end
end