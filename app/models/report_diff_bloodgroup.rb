class ReportDiffBloodgroup < ApplicationRecord
    validates :foreign_worker_code, presence: true
    validates :foreign_worker_name, presence: true
    validates :certification_date,  presence: true
    validates :doctor_code_3,       presence: true
    validates :lab_code_3,          presence: true
    validates :transaction_code_3,  presence: true
end