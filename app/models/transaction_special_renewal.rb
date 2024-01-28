class TransactionSpecialRenewal < ApplicationRecord
    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction"
end
