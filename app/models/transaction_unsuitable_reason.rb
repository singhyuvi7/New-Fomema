class TransactionUnsuitableReason < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction", optional: true
    belongs_to :unsuitable_reason, optional: true

    validates :transaction_id,          presence: true
    validates :unsuitable_reason_id,    presence: true
    validates :created_by_system,       inclusion: [true, false]
end