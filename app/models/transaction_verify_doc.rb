class TransactionVerifyDoc < ApplicationRecord

    NIOS_STATUSES = {
        "APPROVAL" => "Pending Approval",
        "APPROVED" => "Approved",
        "REJECTED" => "Rejected",
        "INCOMPLETE" => "Incomplete"
    }

    PORTAL_STATUSES = {
        "APPROVAL" => "Pending for review",
        "APPROVED" => "Approved",
        "REJECTED" => "Rejected",
        "INCOMPLETE" => "Incomplete"
    }

    DECISIONS = {
        "APPROVE" => "Approve",
        "REJECT" => "Reject",
        "INCOMPLETE" => "Incomplete"
    }

    CATEGORIES = {
        "AGENCY_TRANSACTION_REGISTRATION" => "AGENCY TRANSACTION REGISTRATION",
        "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION" => "SPECIAL RENEWAL TRANSACTION REGISTRATION"
    }

    audited
    include CaptureAuthor

    belongs_to :transactionz, class_name: "Transaction", foreign_key: "transaction_id", optional: true
    belongs_to :submit_user, class_name: 'User', optional: true, foreign_key: :submitted_by
    belongs_to :approval_user, class_name: 'User', optional: true, foreign_key: :approval_by
    belongs_to :sourceable, polymorphic: true, optional: true
end
