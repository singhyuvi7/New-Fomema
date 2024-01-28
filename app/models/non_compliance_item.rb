class NonComplianceItem < ApplicationRecord
    belongs_to :xqcc_letter, class_name: "XqccLetterNonCompliance", foreign_key: "xqcc_letter_non_compliance_id", inverse_of: :total_item_rows, optional: true

    validates :xqcc_letter_non_compliance_id,   presence: true
    validates :name,                            presence: true
    validates :total,                           presence: true
end