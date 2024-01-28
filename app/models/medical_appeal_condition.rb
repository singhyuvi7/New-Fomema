class MedicalAppealCondition < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz,       class_name: "Transaction", foreign_key: "transaction_id", inverse_of: :medical_appeal_conditions, optional: true
    belongs_to :condition,          inverse_of: :medical_appeal_conditions, optional: true
    belongs_to :medical_appeal,     inverse_of: :medical_appeal_conditions, optional: true

    validates :transaction_id,      presence: true
    validates :condition_id,        presence: true
    validates :medical_appeal_id,   presence: true
end
