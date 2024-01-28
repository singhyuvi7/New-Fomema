class XqccLetterIdenticalWorker < ApplicationRecord
    belongs_to :xqcc_letter, class_name: "XqccLetterIdentical", foreign_key: "xqcc_letter_identical_id", inverse_of: :identical_workers, optional: true

    validates :xqcc_letter_identical_id,    presence: true
    validates :worker_code,                 presence: true
    validates :worker_name,                 presence: true
    validates :worker_passport,             presence: true
    validates :xray_date,                   presence: true
    validates :audit_date,                  presence: true
    validates :employer_name,               presence: true
end