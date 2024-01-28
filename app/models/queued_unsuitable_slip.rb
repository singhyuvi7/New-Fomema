class QueuedUnsuitableSlip < ApplicationRecord
    belongs_to :transactionz, class_name: "Transaction", foreign_key: "transaction_id", inverse_of: :queued_unsuitable_slips, optional: true

    validates :transaction_id, presence: true
end