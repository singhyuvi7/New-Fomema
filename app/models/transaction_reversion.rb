class TransactionReversion < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction", inverse_of: :transaction_reversions, optional: true
    belongs_to :user, class_name: "User", foreign_key: "created_by", inverse_of: :transaction_reversions, optional: true

    validates :exam_type, 	presence: true
    validates :issues, 		presence: true
end