class MedicalAppeal < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor
    include Sequence
    extend  MedicalAppeal::Queries

    STATUSES = {
        "DOCTOR_NEW"            => "Appeal Submitted",
        "PENDING_TODO"          => "To be Reviewed",
        "PENDING_MOH_DOCUMENT"  => "Pending Employer to Upload Document",
        "EXAMINATION"           => "Doctor Examination",
        "DOCUMENT_COMPLETED"    => "Document Completed",
        "PENDING_MOH_APPROVAL"  => "Awaiting MOH Approval",
        "PENDING_APPROVAL"      => "Awaiting Approval",
        "CLOSED"                => "Closed Appeal",
    }

    RESULTS = {
        "SUCCESSFUL"                => "Successful",
        "UNSUCCESSFUL"              => "Unsuccessful",
        "CANCEL/CLOSE"              => "Cancelled",
        "CONDITIONAL_SUCCESSFUL"    => "Conditional Successful"
    }

    # Ensure document type id for doctor and laboratory is different
    DOCTOR_DOCUMENT_TYPES = {
        "D_APPEAL_FORM" => "APPEAL FORM",
        "D_LABORATORY_REPORT" => "LABORATORY REPORT",
        "D_SPECIALIST_REPORT" => "SPECIALIST REPORT",
        "D_XRAY_REPORT" => "X-RAY REPORT",
        "D_EMPLOYER_EXPLANATION_LETTER" => "EMPLOYER EXPLANATION LETTER",
        "D_APPENDIX_12" => "APPENDIX 12",
        "D_VISION_ACUITY" => "VISION ACUITY",
        "D_OTHER" => "OTHER INVESTIGATION REPORT",
    }

    LABORATORY_DOCUMENT_TYPES = {
        "L_INITIAL_LAB_REPORT" => "INITIAL LABORATORY REPORT",
        "L_CONFIRMATION_LAB_REPORT" => "CONFIRMATION LAB REPORT / COVER LETTER",
    }

    EMPLOYER_MOH_DOCUMENT_TYPES = {
        "EM_SPECIALIST_REPORT"  => "SPECIALIST REPORT",
        "EM_OTHER_DOCUMENT"     => "OTHER RELEVANT DOCUMENT",
    }

    MOH_DOCUMENT_TYPES = {
        "MOH_LETTER" => 'MOH LETTER',
    }

    ALL_DOCUMENT_TYPES = MedicalAppeal::DOCTOR_DOCUMENT_TYPES.merge(
        MedicalAppeal::LABORATORY_DOCUMENT_TYPES,
        MedicalAppeal::EMPLOYER_MOH_DOCUMENT_TYPES,
        MedicalAppeal::MOH_DOCUMENT_TYPES,
    )

    belongs_to :transactionz,       class_name: "Transaction",      foreign_key: "transaction_id",          inverse_of: :medical_appeals,       optional: true
    belongs_to :officer_in_charge,  class_name: "User",             foreign_key: "officer_in_charge_id",    inverse_of: :officer_of_appeals,    optional: true
    belongs_to :doctor,             inverse_of: :medical_appeals,   optional: true
    belongs_to :laboratory,         inverse_of: :medical_appeals,   optional: true
    belongs_to :xray_facility,      inverse_of: :medical_appeals,   optional: true
    belongs_to :radiologist,        inverse_of: :medical_appeals,   optional: true
    belongs_to :registered_by,      polymorphic: true,              foreign_key: "created_by", optional: true

    has_many :medical_appeal_comments,          inverse_of: :medical_appeal
    has_many :medical_appeal_todos,             inverse_of: :medical_appeal
    has_one  :foreign_worker,                   through: :transactionz, inverse_of: :medical_appeals
    has_one  :employer,                         through: :transactionz, inverse_of: :medical_appeals
    has_many :medical_appeal_assignments,       inverse_of: :medical_appeal
    has_many :medical_appeal_approvals,         inverse_of: :medical_appeal
    has_one  :latest_medical_appeal_approval,   -> { order(id: :desc) }, class_name: "MedicalAppealApproval", foreign_key: "medical_appeal_id"
    has_one  :previous_medical_appeal_approval, -> { order(id: :desc).offset(1) }, class_name: "MedicalAppealApproval", foreign_key: "medical_appeal_id"

    has_many :pcr_reviews,              class_name: "PcrReview", foreign_key: "medical_appeal_id"
    has_one  :latest_pcr_review,        -> { order(id: :desc) }, class_name: "PcrReview", foreign_key: "medical_appeal_id"

    has_many :xray_retakes,             as: :requestable
    has_many :xray_examinations,        through: :xray_retakes
    has_one  :current_xray_retake,      -> { where(current_appeal_retake: true) }, class_name: "XrayRetake", as: :requestable
    has_one  :xray_examination,         through: :current_xray_retake

    has_many :medical_appeal_conditions, inverse_of: :medical_appeal
    has_many :uploads, as: :uploadable

    validates :status,          presence: true

    before_save :check_for_todo_list_states
    after_commit :set_latest_appeal_indicator,      on: [:create]
    after_commit :seed_todo_list,                   on: [:create]
    after_commit :copy_medical_appeal_conditions,   on: [:create]

    def self.order_by_active
        active_statuses = sanitize_sql_array(["case when medical_appeals.status IN ('CLOSED') then 1 else 0 end"])
        order(active_statuses)
    end

    def displayed_status
        status == "CLOSED" ? RESULTS[result] : STATUSES[status]
    end

    def todo_list
        @transaction    = transactionz
        @med_exam       = @transaction.medical_examination || @transaction.doctor_examination
        @lab_exam       = @transaction.laboratory_examination
        @xray_exam      = @transaction.xray_examination
        @to_do_list     = Array.new
        appeal_todo__digital_xray
        appeal_todo__hiv
        appeal_todo__dermatologist
        appeal_todo__vision_test
        appeal_todo__hypertension
        appeal_todo__cancer
        appeal_todo__neurologist
        appeal_todo__psychiatrist
        appeal_todo__opiates
        appeal_todo__cannabis
        appeal_todo__diabetes
        appeal_todo__urologist
        appeal_todo__respiratory
        appeal_todo__hepatitis
        appeal_todo__heart_diseases
        appeal_todo__tuberculosis
        return @to_do_list
    end

    def duration_days
        comparison_time = status == "CLOSED" ? completed_at.to_date : Date.today

        begin
            (comparison_time - created_at.to_date).to_i
        rescue
            "Error"
        end
    end

    def moh_duration_days
        comparison_time = status == "CLOSED" ? completed_at.to_date : Date.today

        begin
            (comparison_time - employer_document_uploaded_date.to_date).to_i
        rescue
            "-"
        end
    end

    def pcr_xray_result
        pcr_result || xray_result
    end
private
    def seed_todo_list
        todo_list.each do |todo_id|
            MedicalAppealTodo.create(medical_appeal_id: id, appeal_todo_id: todo_id)
        end
    end

    def appeal_todo__digital_xray
        # IMPORTANT - Appeal for Digital X-Ray is no longer automated. It is only through manual selection.
        # @to_do_list << 1 if [:result].map {|field| @xray_exam.try(field)}.include?(true) # Appeal for Digital X-Ray.

        # IMPORTANT - To submit new evidence is no longer automated. It is only through manual selection.
        # Take note, to submit new evidence is done by Doctor. They will communicate with X-Ray Facility.
        # @to_do_list << 4 if [:thoracic_cage, :heart_shape_and_size, :lung_fields, :mediastinum_and_hila, :pleura_hemidiaphragms_costopherenic_angles].map {|field| @xray_exam.try(field)}.include?(true) # To submit new evidence (X-Ray film) with report to Medical Department FOMEMA within 7 days.
    end

    def appeal_todo__hiv
        @to_do_list << 2 if @med_exam.try(:condition_hiv) # To request for HIV Confirmatory test (Western Blot) on primary blood/serum sample.
    end

    def appeal_todo__dermatologist
        @to_do_list << 5 if @med_exam.try(:physical_chronic_skin_rash) # To get Dermatologist assessment report for Slit Skin Test.
        @to_do_list << 5 if @med_exam.try(:condition_leprosy) # To get Dermatologist assessment report for Slit Skin Test.
    end

    def appeal_todo__vision_test
        if [:physical_vision_test_unaided_left,:physical_vision_test_unaided_right,:physical_vision_test_aided_left,:physical_vision_test_aided_right].map {|field| @med_exam.try(field)}.include?(true)
            @to_do_list << 25 # To do aided Vision assessment report.
            @to_do_list << 26 # To get Ophthalmologist's assessment report (if necessary).
        end
    end

    def appeal_todo__hypertension
        if @med_exam.try(:condition_hypertension)
            @to_do_list << 12 # To do Hypertension assessment report with BP measurement before and after treatment.
            @to_do_list << 21 # Physician's assessment report.
            @to_do_list << 14 # Other related systemic examination, especially for signs of target organ damage and fitness for employment.
        end
    end

    def appeal_todo__cancer
        @to_do_list << 9 if @med_exam.try(:condition_cancer) # To get Oncologist assessment report.
    end

    def appeal_todo__neurologist
        if [:system_nervous_time, :system_nervous_place, :system_nervous_person].map {|field| @med_exam.try(field)}.include?(true) ||
            [:system_nervous_speech, :system_nervous_cognitive_function, :system_nervous_size_of_peripheral_nerves, :system_nervous_motor_power, :system_nervous_sensory, :system_nervous_reflexes, :system_nervous_other].map {|field| @med_exam.try(field)}.include?(true)
            @to_do_list << 8 # To get Neurologist assessment report.
        end
    end

    def appeal_todo__psychiatrist
        @to_do_list << 7 if @med_exam.try(:condition_psychiatric_disorder) # To get Psychiatrist's assessment report.
    end

    def appeal_todo__opiates
        @to_do_list << 10 if @med_exam.try(:condition_urine_for_opiates) # To request for opiates confirmation test (GCMS) on primary urine sample kept by the original lab.
    end

    def appeal_todo__cannabis
        @to_do_list << 11 if @med_exam.try(:condition_urine_for_cannabis) # To request for Cannabinoids Confirmation test (GCMS) on primary urine sample kept by the original lab.
    end

    def appeal_todo__diabetes
        if @med_exam.try(:condition_diabetes_mellitus)
            @to_do_list << 18 # To do FBS and HBA1C before and after treatment.
            @to_do_list << 19 # To get Endocrinologist / Physician assessment report if needed.
        end
    end

    def appeal_todo__urologist
        if @med_exam.try(:condition_kidney_diseases)
            @to_do_list << 23 # To Repeat Urine Albumin
            @to_do_list << 24 # To get Nephrologist‘s/ Urologist’s assessment report if needed.
        end
    end

    def appeal_todo__respiratory
        @to_do_list << 17 if @med_exam.try(:condition_bronchial_asthma) # To get Respiratory/Chest Physician's assessment report.
    end

    def appeal_todo__hepatitis
        @to_do_list << 6 if @med_exam.try(:condition_hepatitis) # To request for Hbs/AG (ELISA/CMIA) screening test on duplicated sample of original blood/serum sample.
    end

    def appeal_todo__heart_diseases
        @to_do_list << 16 if @med_exam.try(:condition_heart_diseases) # To get Cardiologist's assessment with ECHO report.
    end

    def appeal_todo__tuberculosis
        @to_do_list << 45 if @med_exam.try(:condition_tuberculosis) # To get Gene Xpert report, TB QuantiFERON report and chest physician assessment report.
    end

    def check_for_todo_list_states
        todo_list       = MedicalAppealTodo.where(medical_appeal_id: self.id)
        doctor_todos    = todo_list.select {|todo| todo.secondary_type.nil? }.map(&:completed_at?)
        lab_todos       = todo_list.select {|todo| todo.secondary_type == "Laboratory" && todo.secondary_sent_at? }.map(&:completed_at?)

        if doctor_todos.present? && !doctor_todos.include?(false)
            self.doctor_done_at ||= Time.now
        else
            self.doctor_done_at = nil
        end

        if lab_todos.present? && !lab_todos.include?(false)
            self.laboratory_done_at ||= Time.now
        else
            self.laboratory_done_at = nil
        end
    end

    def copy_medical_appeal_conditions
        certification_condition_ids = Condition.where(code: Condition.medical_certification_conditions.except("5501", "5502").keys).pluck(:id)

        detail_condition_ids =
            if transactionz.medical_examination.present?
                transactionz.medical_examination_details.pluck(:condition_id)
            else
                transactionz.doctor_examination_details.pluck(:condition_id)
            end

        (detail_condition_ids & certification_condition_ids).each do |condition_id|
            MedicalAppealCondition.find_or_create_by(transaction_id: transaction_id, medical_appeal_id: id, condition_id: condition_id)
        end
    end

    def set_latest_appeal_indicator
        MedicalAppeal.where(transaction_id: transaction_id, latest_appeal: true).where.not(id: id).update(latest_appeal: false)
    end
end