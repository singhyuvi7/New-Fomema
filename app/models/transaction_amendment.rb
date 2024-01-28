class TransactionAmendment < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz,   class_name: "Transaction", foreign_key: "transaction_id", inverse_of: :transaction_amendments, optional: true
    belongs_to :user,           class_name: "User", foreign_key: "created_by", inverse_of: :transaction_amendments, optional: true
    belongs_to :approved_by,    class_name: "User", foreign_key: "approval_by", inverse_of: :transaction_amendments_approved, optional: true
    belongs_to :cancelled_by,   class_name: "User", foreign_key: "cancelled_by_id", inverse_of: :transaction_amendments_approved, optional: true

    default_scope { where(cancelled_at: nil) }

    store_accessor :medical_conditions, :regular_fields, :comments

    def wrong_transmissions
        transmissions = [
          wrong_transmission_doctor? ? "Doctor" : nil,
          wrong_transmission_lab? ? "Laboratory" : nil,
          wrong_transmission_xray? ? "Xray" : nil
        ].compact.join_multiple_objects

        return "No Transmissions selected" if transmissions.blank?
        transmissions
    end

    # get conditions that were changed while amending final result
    def amended_conditions
        medical_conditions.except("certification_comment")
    end

    def amended_comment
        medical_conditions["certification_comment"]
    end
end