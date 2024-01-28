class TransactionEmail < ApplicationRecord
    SEND_TYPES = {
        "FINAL_RESULT_SUITABLE" => "Final result suitable",
        "FINAL_RESULT_UNSUITABLE" => "Final result unsuitable",
    }

    belongs_to :transactionz, class_name: "Transaction", foreign_key: "transaction_id"
end