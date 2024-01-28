class MohNotificationCheck < ApplicationRecord
    audited

    belongs_to :transactionz, class_name: "Transaction",  foreign_key: "transaction_id", optional: true
end