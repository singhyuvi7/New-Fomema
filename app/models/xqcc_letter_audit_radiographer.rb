class XqccLetterAuditRadiographer < ApplicationRecord
    include Sequence
    include CaptureAuthor
    extend XqccLetter::LetterExtensions
    include XqccLetter::LetterMethods

    validates :xray_ref_no,         presence: true
    validates :issuer_name,         presence: true
    validates :issuer_title,        presence: true
    validates :panel_year,          presence: true
    validates :xray_code,           presence: true

    before_create :set_ref_sequence

    def set_ref_sequence
        return unless self.valid?
        next_sequence_id        = seq_nextval('xqcc_audit_radiographer_letter_seq')
        reference_number        = "L#{ "%04d" % next_sequence_id }"
        self.xray_ref_no        = xray_ref_no.gsub("L00XX", reference_number)
    end

    def ref_tag
        xray_ref_no.split("/AR/").last if xray_ref_no.present?
    end
end