class XqccLetterNonCompliance < ApplicationRecord
    include Sequence
    include CaptureAuthor
    extend XqccLetter::LetterExtensions
    include XqccLetter::LetterMethods

    has_many :total_image_rows,   class_name: "NonComplianceTotalImage", foreign_key: "xqcc_letter_non_compliance_id", inverse_of: :xqcc_letter
    has_many :total_item_rows,        class_name: "NonComplianceItem", foreign_key: "xqcc_letter_non_compliance_id", inverse_of: :xqcc_letter

    validates :xray_ref_no,         presence: true
    validates :issuer_name,         presence: true
    validates :issuer_title,        presence: true
    validates :xray_code,           presence: true
    validates :follow_up_with,      presence: true
    validates :follow_up_date,      presence: true

    before_create :set_ref_sequence

    def set_ref_sequence
        return unless self.valid?
        next_sequence_id        = seq_nextval('xqcc_non_compliance_letter_seq')
        reference_number        = "L#{ "%04d" % next_sequence_id }"
        self.xray_ref_no        = xray_ref_no.gsub("L00XX", reference_number)
    end

    def ref_tag
        xray_ref_no.split("/NC/").last if xray_ref_no.present?
    end
end