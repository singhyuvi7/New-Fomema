class XqccLetterWrongTransmission < ApplicationRecord
    include Sequence
    include CaptureAuthor
    extend XqccLetter::LetterExtensions
    include XqccLetter::LetterMethods

    validates :transaction_code,    presence: true
    validates :xray_ref_no,         presence: true
    validates :employer_ref_no,     presence: true
    validates :amended_status,      presence: true
    validates :xray_code,           presence: true
    validates :doctor_code,         presence: true
    validates :employer_code,       presence: true
    validates :worker_code,         presence: true
    validates :worker_name,         presence: true
    validates :worker_passport,     presence: true

    before_create :set_ref_sequence

    def set_ref_sequence
        return unless self.valid?
        next_sequence_id        = seq_nextval('xqcc_wrong_transmission_letter_seq')
        reference_number        = "L#{ "%04d" % next_sequence_id }"
        self.xray_ref_no        = xray_ref_no.gsub("L00XX", reference_number)
        self.employer_ref_no    = employer_ref_no.gsub("L00XX", reference_number)
    end
end