class XqccLetterIdentical < ApplicationRecord
    include Sequence
    include CaptureAuthor
    extend XqccLetter::LetterExtensions
    include XqccLetter::LetterMethods

    has_many :identical_workers,    class_name: "XqccLetterIdenticalWorker", foreign_key: "xqcc_letter_identical_id", inverse_of: :xqcc_letter

    validates :transaction_code,    presence: true
    validates :xray_ref_no,         presence: true
    validates :employer_ref_no,     presence: true
    validates :retake_period,       presence: true
    validates :reply_period,        presence: true
    validates :issuer_name,         presence: true
    validates :issuer_title,        presence: true
    validates :xray_code,           presence: true
    validates :doctor_code,         presence: true
    validates :employer_code,       presence: true

    before_validation :set_retake_period
    before_validation :set_reply_period
    before_create :set_ref_sequence

    def set_ref_sequence
        return unless self.valid?
        next_sequence_id        = seq_nextval('xqcc_identical_letter_seq')
        reference_number        = "L#{ "%04d" % next_sequence_id }"
        self.xray_ref_no        = xray_ref_no.gsub("L00XX", reference_number)
        self.employer_ref_no    = employer_ref_no.gsub("L00XX", reference_number)
    end

    def ref_tag
        xray_ref_no.split("/ID/").last if xray_ref_no.present?
    end

    def set_retake_period
        period              = retake_period.to_i
        self.retake_period  = "#{ period } #{ "day".pluralize(period) }"
    end

    def set_reply_period
        period              = reply_period.to_i
        self.reply_period   = "#{ period } #{ "day".pluralize(period) }"
    end

    def retake_period_number
        retake_period.match(/\d+/).to_s.to_i if retake_period.present?
    end

    def reply_period_number
        reply_period.match(/\d+/).to_s.to_i if reply_period.present?
    end
end