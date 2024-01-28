class PcrReview < ApplicationRecord
    STATUSES = {
        "PCR_REVIEW" => "PCR_REVIEW",
        "PCR_RETAKE" => "PCR_RETAKE",
        "TRANSMITTED" => "TRANSMITTED",
    }

    RESULTS = {
        "NORMAL" => "NORMAL",
        "ABNORMAL" => "ABNORMAL",
        "RETAKE" => "RETAKE",
    }

    CASE_TYPES = {
        "XRAY_EXAMINATION_ABNORMAL" => "XRAY EXAMINATION: ABNORMAL",
        "XQCC_REVIEW_IQA" => "XQCC REVIEW: INTERNAL QUALITY AUDIT (IQA)",
        "XQCC_REVIEW_SUSPICIOUS" => "XQCC REVIEW: SUSPICIOUS",
        "XQCC_REVIEW_IDENTICAL" => "XQCC REVIEW: IDENTICAL",
        "XQCC_REVIEW_WRONGLY_TRANSMITTED" => "XQCC REVIEW: WRONGLY TRANSMITTED",
        "XQCC_REVIEW_WRONGLY_RETAKE" => "XQCC REVIEW: WRONGLY RETAKE",
        "XQCC_PENDING_REVIEW_PCR_POOL" => "XQCC PENDING REVIEW: PCR AUDIT",
        "XQCC_PENDING_DECISION_PCR" => "XQCC PENDING DECISION: ADDITIONAL PCR",
    }
    
    QUALITY_DETAILS = {
        "4021" => "ID",
        "4022" => "Processing",
        "4023" => "Positioning",
        "4024" => "Exposure",
        "4025" => "Artifacts",
        "4026" => "Inspiratory Effort",
        "4027" => "Movement / Breathing",
        "4028" => "Anatomical Marker",
        "4029" => "Others",
    }

    QUALITY_COMMENTS = {
        "4121" => "ID Comment",
        "4122" => "Processing Comment",
        "4123" => "Positioning Comment",
        "4124" => "Exposure Comment",
        "4125" => "Artifacts Comment",
        "4126" => "Inspiratory Effort Comment",
        "4127" => "Movement / Breathing Comment",
        "4128" => "Anatomical Marker Comment",
        "4129" => "Others Comment",
    }
    
    CONDITION_DETAILS = {
        "4010" => "Film Quality", #film quality, #obsolete
        "4011" => "Accuracy Report", #accuracy report,  #obsolete
        "4012" => "Thoracic Cage", #thoracic cage comment, 
        "4013" => "Heart Size & Shape", #heart size and shape, 
        "4014" => "Lung Fields", #lung fields, 
        "4015" => "Mediastinum & Hilar Region", #mediastinum and hilar region, 
        "4016" => "Pleura / Diaphragm / CPA", #pleura diaphragm cpa, 
        "4017" => "Other Abnormalities", #other abnormalities, 
        "4020" => "Abnormal", #abnormal, #pcr_reviews.result
    }

    CONDITION_COMMENTS = {
        "4112" => "Thoracic Cage Comment", #thoracic cage comment
        "4113" => "Heart Size & Shape Comment", #heart size and shape
        "4114" => "Lung Fields Comment", #lung fields
        "4115" => "Mediastinum & Hilar Region Comment", #mediastinum and hilar region
        "4116" => "Pleura / Diaphragm / CPA Comment", #pleura diaphragm cpa
        "4117" => "Other Abnormalities Comment", #other abnormalities
        "4118" => "PCR Review Comment", #pcr review comment #pcr_reviews.comment
    }

    audited
    include PublicActivity::Common
    include CaptureAuthor
    include XrayRetakeRequest
    include ParentTransactionScope
    include ResetPcrReview
    include OrderScope
    include XrayMovement

    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction", optional: true
    belongs_to :medical_appeal, foreign_key: "medical_appeal_id", class_name: "MedicalAppeal", optional: true
    belongs_to :pcr_user, :class_name => :User, :foreign_key => "pcr_id", optional: true
    belongs_to :poolable, polymorphic: true, optional: true

    has_one  :foreign_worker, through: :transactionz
    has_one  :foreign_worker_through_appeal, through: :medical_appeal, source: :foreign_worker
    has_one  :transaction_through_appeal, through: :medical_appeal, source: :transactionz
    has_many :xqcc_approval_histories, as: :historyable
    has_many :xray_retakes, as: :requestable
    has_one  :xray_retake, -> { order(id: :desc) }, as: :requestable
    has_many :pcr_review_details
    has_many :pcr_review_comments

    # scopes
    scope :latest_record, -> {
        joins(:transactionz).where("transactions.pcr_review_id = pcr_reviews.id")
    }

    scope :appeal_transaction_code, -> transaction_code {
        if transaction_code.present?
            joins(:transaction_through_appeal).where(transactions: { code: transaction_code.strip })
        end
    }

    scope :appeal_worker_code, -> worker_code {
        unless worker_code.blank?
            joins(:foreign_worker_through_appeal).where(foreign_workers: { code: worker_code })
        end
    }

    scope :appeal_passport_number, -> passport_number {
        unless passport_number.blank?
            joins(:foreign_worker_through_appeal).where(foreign_workers: { passport_number: passport_number })
        end
    }

    scope :user_review_pcr_case, -> (user_id, review_status) {
        case review_status
        when 'PENDING_AUDIT'
            where(status: 'PCR_REVIEW').user_pcr_case(user_id)

        when 'AUDITED'
            where.not(status: 'PCR_REVIEW').user_pcr_case(user_id)

        when 'AUDITED_NORMAL'
            where(result: 'NORMAL')
            .where.not(status: 'PCR_REVIEW')
            .user_pcr_case(user_id)

        when 'AUDITED_ABNORMAL'
            where(result: 'ABNORMAL')
            .where.not(status: 'PCR_REVIEW')
            .user_pcr_case(user_id)

        when 'AUDITED_RETAKE'
            where(result: 'RETAKE')
            .where.not(status: 'PCR_REVIEW')
            .user_pcr_case(user_id)

        when 'ALL'
            user_pcr_case(user_id)

        else
            where(status: 'PCR_REVIEW').user_pcr_case(user_id)
        end
    }

    # get current PCR_REVIEW at hand
    scope :user_current_pcr_case, -> (user_id) {
        where(status: 'PCR_REVIEW').user_pcr_case(user_id)
    }

    # get all PCR_REVIEW that was handled by this user
    scope :user_pcr_case, -> (user_id) {
        where(pcr_id: user_id)
    }

    scope :pcr_pool, -> {
        where(status: 'PCR_POOL').joins("pcr_pools on pcr_pools.transaction_id = pcr_reviews.transaction_id").where("pcr_pools.picked_up_by is null")
    }

    scope :created_at_between, ->(start_date, end_date) { where(created_at: DateTime.parse(start_date).in_time_zone('Kuala Lumpur').beginning_of_day...DateTime.parse(end_date).in_time_zone('Kuala Lumpur').end_of_day) }
    # end of scopes

    # accessor
    def get_transaction_id
        medical_appeal_id? ? medical_appeal_id : transaction_id
    end

    def case_review_status
        review_status = 'PENDING AUDIT'

        case self.status
        when "PCR_RETAKE"
            review_status = "AUDITED - RETAKE - PENDING RETAKE"
        when 'TRANSMITTED'
            review_status = "AUDITED - #{result}"
        end

        review_status
    end

    def pending_review_source
        source = false

        if poolable.present?
            if poolable.sourceable.present?
                if poolable.sourceable_type == XrayPendingReview.to_s
                    source = true
                end

                if poolable.sourceable_type == XrayReview.to_s
                    if poolable.sourceable.case_type == 'XQCC_PENDING_REVIEW_XQCC_POOL'
                        source = true
                    end
                end
            end
        end

        source
    end

    def pending_review_comment
        comment = nil

        if poolable.present?
            if poolable.sourceable.present? && poolable.sourceable_type == XrayPendingReview.to_s
                comment = poolable.sourceable.comment
            end
        end

        comment
    end

    def case_type_label
        CASE_TYPES[case_type]
    end

    def is_retake?
        completed_pcr_retake = XrayRetake.where(requestable_type: PcrReview.to_s).where(requestable_id: id).where(status: 'COMPLETED').first

        return true if completed_pcr_retake.present?

        return false
    end
    # end of accessor

    # authorizations
    def is_owner?(user_id)
        pcr_id == user_id
    end

    def can_edit?
        status == 'PCR_REVIEW' && result != 'RETAKE'
    end

    def can_request_retake?
        status == 'PCR_REVIEW' && result == 'RETAKE'
    end
    # end of authorizations

    # methods
    def reassign_pcr_review(reassign_data)
        reset_col_data = reset_pcr_review_cols
        pcr_review_data = reset_col_data.merge(reassign_data)
        self.update(pcr_review_data)
    end
    # end of methods

    def belong_is_mandatory?
        return true if self.transactionz&.xray_review&.result == "IDENTICAL"
        return true if self.transactionz&.xray_pending_review&.is_audit_comparison == "YES"
        rs = self.transactionz&.pcr_reviews.select("pcr_reviews.result", "xray_retakes.approval_decision")
        .joins("join xray_retakes on pcr_reviews.id = xray_retakes.requestable_id and xray_retakes.requestable_type = 'PcrReview'")
        .where("pcr_reviews.id != ? and pcr_reviews.created_at < ?", self.id, self.created_at).order(created_at: :desc).first
        if rs && rs.result == 'RETAKE' && rs.approval_decision == 'APPROVE'
            return true
        end
        rs = self.transactionz&.xray_reviews.select("xray_retakes.approval_decision")
        .joins("join xray_retakes on xray_reviews.id = xray_retakes.requestable_id and xray_retakes.requestable_type = 'XrayReview'")
        .where("xray_reviews.id != ? and xray_reviews.created_at < ?", self.id, self.created_at).order(created_at: :desc).first
        if rs && rs.approval_decision == 'APPROVE'
            return true
        end
        return false
    end

    def get_condition_detail(code)
        if !@condition_details
            @condition_details = {}
            pcr_review_details.joins("join conditions on pcr_review_details.condition_id = conditions.id")
            .select("pcr_review_details.*", "conditions.code as condition_code").each do |pcr_review_detail|
                @condition_details[pcr_review_detail.condition_code] = pcr_review_detail.text_value
            end
        end
        @condition_details.key?(code) ? @condition_details[code] : nil
    end

    def get_condition_comment(code)
        if !@condition_comments
            @condition_comments = {}
            pcr_review_comments.joins("join conditions on pcr_review_comments.condition_id = conditions.id")
            .select("pcr_review_comments.*", "conditions.code as condition_code").each do |pcr_review_comment|
                @condition_comments[pcr_review_comment.condition_code] = pcr_review_comment.comment
            end
        end
        @condition_comments.key?(code) ? @condition_comments[code] : nil
    end

end
