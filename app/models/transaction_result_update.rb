class TransactionResultUpdate < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz,   class_name: "Transaction", foreign_key: "transaction_id", inverse_of: :transaction_result_updates, optional: true
    belongs_to :user,           class_name: "User", foreign_key: "created_by", inverse_of: :transaction_result_updates, optional: true

    store_accessor :medical_conditions, :regular_fields, :comments

    def wrong_transmissions
        transmissions = [
            wrong_transmission_doctor? ? "Doctor" : nil,
            wrong_transmission_lab? ? "Laboratory" : nil,
            wrong_transmission_xray? ? "Xray" : nil
        ].compact.join_multiple_objects

        if transmissions.blank?
            "No Transmissions selected"
        else
            transmissions
        end
    end

    # get conditions that were changed
    def amended_conditions
        medical_conditions.except("certification_comment")
    end

    def amended_comment
        medical_conditions["certification_comment"]
    end
end