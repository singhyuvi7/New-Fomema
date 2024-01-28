class TransactionChangeSp < ApplicationRecord
    STATUSES = {
        "PAYMENT" => "Pending Payment",
        "APPROVAL" => "Pending Approval",
        "APPROVED" => "Approved",
        "REJECTED" => "Rejected",
    }

    DECISIONS = {
        "APPROVE" => "Approve",
        "REJECT" => "Reject",
    }

    audited
    include CaptureAuthor

    belongs_to :transactionz, class_name: "Transaction", foreign_key: "transaction_id", optional: true
    belongs_to :change_sp_reason, optional: true
    belongs_to :request_user, class_name: 'User', optional: true, foreign_key: :requested_by
    belongs_to :approval_user, class_name: 'User', optional: true, foreign_key: :approval_by
end
