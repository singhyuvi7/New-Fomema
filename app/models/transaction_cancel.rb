class TransactionCancel < ApplicationRecord
    STATUSES = {
        "PENDING_PAYMENT" => "Pending Payment",
        "COMPLETED" => "Completed",
    }

    audited
    include CaptureAuthor

    belongs_to :transactionz, class_name: "Transaction", foreign_key: "transaction_id", optional: true
    belongs_to :cancel_user, class_name: 'User', optional: true, foreign_key: :cancelled_by
end
