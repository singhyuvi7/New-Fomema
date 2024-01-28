class XqccTransactionComment < ApplicationRecord
    audited
    include CaptureAuthor
    
    belongs_to :transactionz, class_name: "Transaction", foreign_key: "transaction_id", optional: true
end
