class XqccLetterActiveTb < ApplicationRecord
    include Sequence
    include CaptureAuthor
    extend XqccLetter::LetterExtensions
    include XqccLetter::LetterMethods

    validates :transaction_code,    presence: true
    validates :xray_ref_no,         presence: true
    validates :employer_ref_no,     presence: true
    validates :issuer_name,         presence: true
    validates :issuer_title,        presence: true
    validates :xray_code,           presence: true
    validates :doctor_code,         presence: true
    validates :employer_code,       presence: true
    validates :worker_code,         presence: true
    validates :worker_name,         presence: true
    validates :worker_passport,     presence: true

    before_create :set_ref_sequence

    def set_ref_sequence
        return unless self.valid?
        next_sequence_id        = seq_nextval('xqcc_active_tb_letter_seq')
        reference_number        = "L#{ "%04d" % next_sequence_id }"
        self.xray_ref_no        = xray_ref_no.gsub("L00XX", reference_number)
        self.employer_ref_no    = employer_ref_no.gsub("L00XX", reference_number)
    end

    def ref_tag
        xray_ref_no.split("/ATB/").last if xray_ref_no.present?
    end
end