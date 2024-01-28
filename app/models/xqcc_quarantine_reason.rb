class XqccQuarantineReason < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz, class_name: "Transaction", foreign_key: :transaction_id, optional: true
    belongs_to :quarantine_reason, optional: true

    validates :transaction_id, presence: true
    validates :quarantine_reason_id, presence: true
end
