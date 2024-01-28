class NonComplianceTotalImage < ApplicationRecord
    belongs_to :xqcc_letter, class_name: "XqccLetterNonCompliance", foreign_key: "xqcc_letter_non_compliance_id", inverse_of: :total_image_rows, optional: true

    validates :xqcc_letter_non_compliance_id,   presence: true
    # validates :month,                           presence: true
    validates :total_images,                    presence: true
    validates :sop_compliant,                   presence: true
    validates :non_sop_compliant,               presence: true

    def total_percentage_sop_compliant
        total_percentage_sop_compliant=(sop_compliant.to_d/total_images.to_d) *100
        total_percentage_sop_compliant.round(2)
    end

    def total_percentage_non_compliant
        total_percentage_non_compliant=(non_sop_compliant.to_d/total_images.to_d) *100
        total_percentage_non_compliant.round(2)
    end
end