class MedicalExaminationDetail < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz,           class_name: "Transaction", foreign_key: "transaction_id", inverse_of: :medical_examination_details, optional: true
    belongs_to :condition,              inverse_of: :medical_examination_details, optional: true
    belongs_to :medical_examination,    inverse_of: :medical_examination_details, optional: true

    validates :transaction_id,          presence: true
    validates :condition_id,            presence: true
    validates :medical_examination_id,  presence: true
end