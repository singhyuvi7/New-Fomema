class XrayReviewApproval < ApplicationRecord
    DECISIONS = {
        "APPROVE" => "Approve",
        "REJECT" => "Reject"
    }

    STATUSES = {
        "PENDING_APPROVAL" => "Pending Approval",
        "APPROVED" => "Approved",
        "REJECTED" => "Rejected"
    }

    audited
    include PublicActivity::Common
    include CaptureAuthor
    include ParentTransactionScope
    include OrderScope
    include XrayMovement

    belongs_to :xray_pending_decision
    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction"
    belongs_to :reviewer, class_name: "User", foreign_key: "reviewed_by", optional: true
    has_one :foreign_worker, through: :transactionz

    after_create :set_older_records_as_ignore

    # authorizations
    def is_owner?(user_id)
        created_by == user_id
    end

    def can_edit?
        status === 'PENDING_APPROVAL'
    end

    def can_approve?(current_user_id)
        created_by != current_user_id
        true
    end
    # end of authorizations

    # scopes
    scope :approval, -> {
        where(status: 'PENDING_APPROVAL')
        .where(reviewed_by: nil)
    }

    scope :approval_done, -> {
        where.not(status: 'PENDING_APPROVAL')
    }

    scope :review_status, -> (review_status) {

        case review_status

        when 'PENDING_APPROVAL'
            approval

        when 'APPROVAL'
            where.not(status: 'PENDING_APPROVAL')
            .where.not(reviewed_by: nil)

        when 'APPROVAL_APPROVED'
            where(status: 'APPROVED')
            .where.not(reviewed_by: nil)

        when 'APPROVAL_REJECTED'
            where(status: 'REJECTED')
            .where.not(reviewed_by: nil)

        when 'ALL'

        else
            approval
        end
    }
    # end of scopes

    # accessors
    def case_review_status
        review_status = 'PENDING APPROVAL'

        if status != 'PENDING_APPROVAL'
            review_status = "APPROVAL - #{status}"
        end

        review_status
    end

    def review_data_parse
        json_data = review_data.to_json
        JSON.parse(json_data, object_class: OpenStruct)
    end
    # end of accessors

    def set_older_records_as_ignore
        # Each transaction can have multiple XrayReviewApproval. This happens when the approval is rejected, and when a user sends the XrayPendingDecision back to approval pool, a new record is made.
        old_approvals = XrayReviewApproval.where(transaction_id: transaction_id, ignored: false).where.not(id: id)
        old_approvals.update(ignored: true)
    end

    def self.update_ignored_states
        # This will sort and retrieve the latest id of each transaction.
        latest_approvals    = XrayReviewApproval.all.pluck(:transaction_id, :id).sort.to_h.values
        old_approvals       = XrayReviewApproval.where.not(id: latest_approvals).update(ignored: true)
    end
end