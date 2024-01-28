class DoctorExaminationComment < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz,           class_name: "Transaction", foreign_key: "transaction_id", inverse_of: :doctor_examination_comments, optional: true
    belongs_to :condition,              inverse_of: :doctor_examination_comments, optional: true
    belongs_to :doctor_examination,     inverse_of: :doctor_examination_comments, optional: true

    validates :transaction_id,          presence: true
    validates :condition_id,            presence: true
    validates :doctor_examination_id,   presence: true
end