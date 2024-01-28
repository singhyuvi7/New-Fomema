class XrayPendingReviewCompare < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :xray_pending_review
    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction", optional: true
end
