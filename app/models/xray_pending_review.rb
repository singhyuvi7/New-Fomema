class XrayPendingReview < ApplicationRecord
    audited
    include PublicActivity::Common
    include CaptureAuthor
    include ParentTransactionScope
    include OrderScope
    include XrayMovement

    STATUSES = {
        "XQCC_PENDING_REVIEW" => "Pending",
        "TRANSMITTED" => "Transmitted",
    }

    QUARANTINE_TYPES = {
        "M" => "Worker has been manually tagged for monitoring",
        "P" => "Abnormal lab/x-ray findings with incomplete (no certification) last transaction",
        "Q" => "Quarantine",
        "U" => "Certified SUITABLE but was previously UNSUITABLE (last transaction)",
        "X" => "From XQCC to medical pending review",

        # "CSXU" => "ABNORMAL X-RAY FINDING", # Certified Suitable Xray Unsuitable
        # "CUPXU" => "PREVIOUSLY UNSUITABLE", # Certified Unsuitable Previous Xray Unsuitable
        # "CSPXU" => "PREVIOUSLY UNSUITABLE", # Certified Suitable Previous Xray Unsuitable
        # "CSPMU" => "MEDICAL UNSUITABLE", # Certified Suitable Previous Medical Unsuitable
        # "MONITOR" => "WORKER HAS BEEN MANUALLY TAGGED FOR MONITORING",

        # "MANUAL" => "WORKER HAS BEEN MANUALLY TAGGED FOR MONITORING",
        # "ABNORMAL_FINDING" => "ABNORMAL LAB/X-RAY FINDINGS WITH INCOMPLETE (NO CERTIFICATION) LAST TRANSACTION.",
    }
=begin
    QUARANTINE_TYPE_DESCRIPTIONS = {
        "CSXU" => "Certified SUITABLE with abnormal X-Ray findings", # Certified Suitable Xray Unsuitable
        "CUPXU" => "Certified UNSUITABLE but was previously X-Ray UNSUITABLE", # Certified Unsuitable Previous Xray Unsuitable
        "CSPXU" => "Certified SUITABLE but was previously X-Ray UNSUITABLE", # Certified Suitable Previous Xray Unsuitable
        "CSPMU" => "Certified SUITABLE but was previously Medical UNSUITABLE", # Certified Suitable Previous Medical Unsuitable
        "MONITOR" => "Worker has been manually tagged for monitoring",

        # "MANUAL" => "Worker has been manually tagged for monitoring",
        # "ABNORMAL_FINDING" => "Abnormal lab/x-ray findings with incomplete (no certification) last transaction",
    }
=end
=begin
    PREV_UNSUITABLE_TYPES = {
        "XQCC" => "XQCC UNSUITABLE",
        "MEDICAL" => "MEDICAL UNSUITABLE",
    }
=end
    SOURCES = {
        "MERTS" => "MERTS", # old nios: 1
        "MEDICAL" => "MEDICAL", # old nios 2
        "PCR" => "PCR", # old nios 3
        "XQCC" => "XQCC" # old nios 4
    }

    DECISIONS = {
        "RADIOGRAPHER_REVIEW" => "RADIOGRAPHER REVIEW",
        "PCR_AUDIT" => "PCR AUDIT",
        "MANUAL_AUDIT" => "MANUAL AUDIT",
    }

    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction"
    belongs_to :reviewer, class_name: "User", foreign_key: "reviewed_by", optional: true
    has_many :xray_pending_review_compares

    has_one :foreign_worker, through: :transactionz
    has_one :xray_review, through: :transactionz
    has_one :pcr_review, through: :transactionz
    has_one :xqcc_pool, as: :sourceable
    has_one :pcr_pool, as: :sourceable

    scope :search_status, -> (status) {
        return all if status.blank? || status == "ALL"
        case status
        when "PENDING"
            where(status: "XQCC_PENDING_REVIEW")
        when "REQUESTED_PCR"
            joins(:transactionz).left_outer_joins(:pcr_review)
            .where(status: "TRANSMITTED")
            .where(decision: "PCR_AUDIT")
            .where("transactions.pcr_review_id is null or pcr_reviews.status != 'TRANSMITTED'")
        when "REQUESTED_RADIOGRAPHER"
            joins(:transactionz).left_outer_joins(:xray_review)
            .where(status: "TRANSMITTED")
            .where(decision: "RADIOGRAPHER_REVIEW")
            .where("transactions.xray_review_id is null or xray_reviews.status != 'TRANSMITTED'")
        when "AUDITED_PCR"
            joins(:transactionz).joins(:pcr_review)
            .where(status: "TRANSMITTED")
            .where(decision: "PCR_AUDIT")
            .where("pcr_reviews.status = 'TRANSMITTED'")
        when "REVIEWED_XQCC"
            joins(:transactionz).joins(:xray_review)
            .where(status: "TRANSMITTED")
            .where(decision: "RADIOGRAPHER_REVIEW")
            .where("xray_reviews.status = 'TRANSMITTED'")
        when "MANUAL_AUDIT"
            where(decision: "MANUAL_AUDIT")
            # joins(:transactionz)
            # .where(transactions: {xray_film_type: "ANALOG"})
        else
            where(status: status)
        end
    }

    scope :search_indicator, -> (indicator) {
        return all if indicator.blank? || indicator == "ALL"
        case indicator
        when 'QUARANTINE_MERTS' # when GP certifiy suitable but xray says abnormal
            where(source: 'MERTS')
            .where(quarantine_type: ["Q", "P", "X"])
        when 'MONITORING_MERTS' # when previous transaction unsuitable
            where(source: 'MERTS')
            .where(quarantine_type: ["M", "U"])
        end
    }

    scope :latest_record, -> {
        joins(:transactionz).where("transactions.xray_pending_review_id = xray_pending_reviews.id")
    }
    # end of scopes

    # authorizations
    def is_owner?(user_id)
        true
    end

    def can_edit?
        status === 'XQCC_PENDING_REVIEW'
    end
    # end of authorizations

    def sync_compares(compare_transaction_ids)
        ids = []
        compare_transaction_ids.each do |compare_transaction_id|
            ids << compare_transaction_id.to_i
            self.xray_pending_review_compares.where(transaction_id: compare_transaction_id.to_i).first_or_create
        end
        self.xray_pending_review_compares.where.not(transaction_id: ids).destroy_all
    end

    # accessor
    def case_review_status
        ret = self.status
        case status
        when "XQCC_PENDING_REVIEW"
            ret = "PENDING"
        when "TRANSMITTED"
            case decision
            when "PCR_AUDIT"
                ret = "REQUESTED-PCR"
                if self.try(:pcr_review_status).eql?("TRANSMITTED")
                    ret = "AUDITED"
                end
            when "RADIOGRAPHER_REVIEW"
                ret = "REQUESTED-RADIOGRAPHER"
                if self.try(:xray_review_status).eql?("TRANSMITTED")
                    ret = "REVIEWED"
                end
            when "MANUAL_AUDIT"
                ret = "MANUAL AUDIT"
            end
        end
        ret
    end

    def case_indicator
        case_indicator = nil

        case quarantine_type
        when "M", "U" # "PREVIOUS_UNSUITABLE", "CUPXU", "CSPXU", "CSPMU", 
            case_indicator = 'MONITORING'
        when "Q", "P", "X" # "NORMAL_QUARANTINE", "CSXU", 
            case_indicator = 'QUARANTINE'
        end

        case_indicator
    end

    def quarantine_type_label
        type_name = XrayPendingReview::QUARANTINE_TYPES[self.quarantine_type]

        if type_name.nil?
            type_name = self.quarantine_type
        end

        type_name
    end

    def quarantine_type_description
        desc = nil

        case self.quarantine_type
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
    # end of accessor

    # methods
    def submit_pending_review_to_xqcc(pending_review_data, user_id)
        pending_review_data[:status] = 'TRANSMITTED'
        pending_review_data[:decision] = 'RADIOGRAPHER_REVIEW'
        pending_review_data[:reviewed_by] = user_id
        pending_review_data[:transmitted_at] = Time.now
        self.update(pending_review_data.except(:compare_transaction_code))

        xqcc_pool_data = {
            transaction_id: self.transaction_id,
            case_type: 'XQCC_PENDING_REVIEW_XQCC_POOL',
            status: 'XQCC_POOL',
            source: 'PENDING_REVIEW',
            sourceable_type: XrayPendingReview.to_s,
            sourceable_id: self.id
        }
        # xqcc_pool = XqccPool.find_or_create_by(xqcc_pool_data)
        xqcc_pool = XqccPool.create(xqcc_pool_data)
    end

    # create pcr_pool case when xqcc pending review choose PCR Audit
    def submit_pending_review_to_pcr(pending_review_data, user_id)
        pending_review_data[:status] = 'TRANSMITTED'
        pending_review_data[:decision] = 'PCR_AUDIT'
        pending_review_data[:reviewed_by] = user_id
        pending_review_data[:transmitted_at] = Time.now
        self.update(pending_review_data.except(:compare_transaction_code))

        pcr_pool_data = {
            transaction_id: self.transaction_id,
            case_type: 'XQCC_PENDING_REVIEW_PCR_POOL',
            status: 'PCR_POOL',
            source: 'PENDING_REVIEW',
            sourceable_type: XrayPendingReview.to_s,
            sourceable_id: self.id
        }
        # pcr_pool = PcrPool.find_or_create_by(pcr_pool_data)
        pcr_pool = PcrPool.create(pcr_pool_data)
    end

    # create pending_decision case when xqcc pending review choose Manual Audit
    def submit_pending_review_to_pending_decision(pending_review_data, user_id)
        pending_review_data[:status] = 'TRANSMITTED'
        pending_review_data[:decision] = 'MANUAL_AUDIT'
        pending_review_data[:reviewed_by] = user_id
        pending_review_data[:transmitted_at] = Time.now
        self.update(pending_review_data.except(:compare_transaction_code))

        pending_decision_data = {
            transaction_id: self.transaction_id,
            status: 'XQCC_PENDING_DECISION',
            sourceable_type: XrayPendingReview.to_s,
            sourceable_id: self.id,
        }
        xray_pending_decision = XrayPendingDecision.create(pending_decision_data)
    end
    # end of methods

end
