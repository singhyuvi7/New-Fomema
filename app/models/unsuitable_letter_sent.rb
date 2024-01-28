class UnsuitableLetterSent < ApplicationRecord
    SEND_TYPES = {
        "FINAL_RESULT" => "Final result unsuitable",
        "RESEND" => "Manually resent"
    }

    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz, class_name: "Transaction", foreign_key: "transaction_id"
end