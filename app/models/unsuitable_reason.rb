class UnsuitableReason < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    has_many :transaction_unsuitable_reasons
    has_many :transactions, through: :transaction_unsuitable_reasons, source: :transaction

    validates :reason_en, presence: true
    validates :reason_bm, presence: true
    validates :priority,  presence: true

    scope :xqcc_reasons,    -> { where(reason_en: ["The worker's chest x-ray has abnormal findings.", "The worker has abnormal physical findings."]) }
    scope :other_reasons,   -> { where.not(reason_en: ["The worker's chest x-ray has abnormal findings.", "The worker has abnormal physical findings."]) }
end