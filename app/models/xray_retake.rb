class XrayRetake < ApplicationRecord
    STATUSES = {
        "DRAFT"         => "Draft",
        "APPROVAL"      => "Approval",
        "REJECTED"      => "Rejected",
        "APPROVED"      => "Approved", # pending retake
        "IN_PROGRESS"   => "In Progress",
        "COMPLETED"     => "Completed"
    }

    APPEAL_STATUSES = {
        "NEW"           => "New",
        "EXAM"          => "Examination",
        "PCR_REVIEW"    => "Pending PCR Audit",
        "CLOSED"        => "Closed"
    }

    APPROVAL_DECISIONS = {
        "APPROVE" => "Approve",
        "REJECT" => "Reject"
    }

    audited
    include PublicActivity::Common
    include CaptureAuthor
    include XrayMovement
    include Sequence
    include ParentTransactionScope
    include OrderScope

    belongs_to :transactionz,   foreign_key: "transaction_id", class_name: "Transaction"
    belongs_to :retake_reason,  optional: true
    belongs_to :xray_facility,  optional: true
    belongs_to :radiologist,    optional: true
    belongs_to :requestable,    polymorphic: true
    belongs_to :pcr,            class_name: "User", foreign_key: "pcr_id", inverse_of: :xray_retakes_as_pcr, optional: true
    belongs_to :digital_xray_provider,   optional: true
    belongs_to :xray_bypass_fingerprint_reason, class_name: "BypassFingerprintReason", foreign_key: "xray_bypass_fingerprint_reason_id", optional: true

    has_many :radiologists,     through: :xray_facility
    has_one  :foreign_worker,   through: :transactionz
    has_one  :xray_examination, as: :sourceable
    has_many :pcr_pools
    has_many :pcr_reviews,      through: :pcr_pools
    has_many :follow_ups, as: :commentable, class_name: "XqccComment"

    accepts_nested_attributes_for :xray_examination, reject_if: :all_blank

    after_save :update_code, if: -> { saved_changes[:status] }

    def update_code
        if requestable_type == "MedicalAppeal"
            self.update(code: generate_appeal_retake_code)
        elsif saved_changes[:status][0] == 'APPROVAL' && saved_changes[:status][1] == 'APPROVED'
            self.update(code: generate_retake_code)
        end
    end

    def generate_retake_code
        "99#{'%012i' % seq_nextval('retake_xray_seq')}"
    end

    def generate_appeal_retake_code
        "88#{'%012i' % seq_nextval("medical_appeal_xray_retake_code_seq")}"
    end

    # scopes
    scope :search_pcr_retake, -> {
        where(requestable_type: PcrReview.to_s)
    }

    scope :search_xqcc_retake, -> {
        where(requestable_type: XrayReview.to_s)
    }

    scope :search_status, -> (retake_status) {
        retake_status = retake_status.strip if !retake_status.blank?
        return all if retake_status.blank?
        where(status: retake_status)
    }

    scope :statuses, -> (review_statuses) {
        where(status: review_statuses)
    }

    scope :request_start, -> request_start {
        unless request_start.blank?
            where("created_at >= ?", request_start)
        end
    }

    scope :request_end, -> request_end {
        unless request_end.blank?
            where("created_at <= ?", Time.parse(request_end) + 1.day)
        end
    }

    scope :search_approval_start, -> approval_start {
        unless approval_start.blank?
            where("approved_at >= ?", approval_start)
        end
    }

    scope :search_approval_end, -> approval_end {
        unless approval_end.blank?
            where("approved_at <= ?", Time.parse(approval_end) + 1.day)
        end
    }

    scope :search_retake_reason_id, -> (retake_reason_id) {
        return all if retake_reason_id.blank?
        where(retake_reason_id: retake_reason_id)
    }

    scope :search_retake_xray_code, -> (retake_xray_code) {
        retake_xray_code = retake_xray_code.strip if !retake_xray_code.blank?
        return all if retake_xray_code.blank?
        where("exists (select 1 from xray_facilities where xray_retakes.xray_facility_id = xray_facilities.id and xray_facilities.code ilike ?)", retake_xray_code)
    }

    scope :search_radiographer_id, -> (radiographer_id) {
        return all if radiographer_id.blank?
        where(created_by: radiographer_id)
    }

    scope :search_pcr_id, -> (pcr_id) {
        return all if pcr_id.blank?
        where(created_by: pcr_id)
    }

    scope :analog, -> { joins(:transactionz).where(transactions: { xray_film_type: 'ANALOG' }) }

    scope :digital, -> { joins(:transactionz).where(transactions: { xray_film_type: 'DIGITAL' }) }

    scope :with_created_at_year, ->(year) { where(created_at: DateTime.new(year).beginning_of_year...DateTime.new(year).end_of_year) }

    scope :with_xray_code, lambda { |xray_code|
        joins(transactionz: :xray_facility)
        .where(transactionz: { xray_facilities: { code: xray_code } })
    }
    # /scopes

    # authorizations
    def is_owner?(user_id)
        created_by == user_id
    end

    def xray_retake_can_edit?
        status === 'DRAFT'
    end

    def can_edit_approval?
        status === 'APPROVAL'
    end

    def can_approve?(current_user_id)
        created_by != current_user_id
    end

    def xray_retake_followup_can_edit?
        status === 'APPROVED'
    end

    def xray_retake_can_reassign?
        status === 'APPROVED'
    end
    # /authorizations

    # accessors
    def retake_review_type
        type = nil
        if self.requestable_type === XrayReview.to_s
            type = 'XQCC'
        elsif self.requestable_type === PcrReview.to_s
            type = 'PCR'
        end
        type
    end

    def approval_status
        approval_status = ''
        case status
        when "DRAFT"
            approval_status = "DRAFT"
        when "APPROVAL"
            approval_status = 'RETAKE - PENDING APPROVAL'
        when "APPROVED"
            approval_status = 'RETAKE - APPROVED'
        when "REJECTED"
            approval_status = 'RETAKE - REJECTED'
        when "COMPLETED"
            approval_status = 'RETAKE - COMPLETED'
        end
        approval_status
    end

    def displayed_status(user_type = nil)
        case user_type
        when "XrayFacility"
            if ["COMPLETED"].include?(status)
                "Transmitted"
            elsif ["APPROVED", "IN_PROGRESS"].include?(status)
                if xray_reporter_type == "RADIOLOGIST"
                    xray_examination.try(:radiologist_transmitted_at).present? ? "Pending Acknowledgement" : "Assigned To Radiologist"
                else
                    "Pending for Chest X-ray Transmission"
                end
            end
        when "Radiologist"
            if ["COMPLETED"].include?(status)
                "Transmitted"
            elsif xray_reporter_type == "RADIOLOGIST" && xray_examination.try(:radiologist_transmitted_at).present?
                "Pending Acknowledgement by X-ray Facility"
            elsif ["APPROVED", "IN_PROGRESS"].include?(status)
                "Pending for Chest X-ray Transmission"
            end
        else
            status
        end
    end

    def retake_duration
        duration = nil
        current_time = Time.now
        unless approved_at.nil?
            if completed_at.present?
                time_diff = (completed_at - approved_at)
            elsif status == "REJECTED"
                time_diff = (approved_at - approved_at)
            else
                time_diff = (current_time - approved_at)
            end
            duration = (time_diff / 1.day).round
        end
        duration
    end
    # /accessors

    def index_path
        case self.requestable_type
        when "PcrReview"
            Rails.application.routes.url_helpers.pcr_internal_xray_retakes_path
        when "XrayReview"
            Rails.application.routes.url_helpers.xqcc_internal_xray_retakes_path
        end
    end

end
