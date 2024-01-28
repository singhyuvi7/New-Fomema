class ReportCronjobEmail < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    validates :report_cronjob_id,   presence: true
    validates :email,               uniqueness: { scope: :report_cronjob_id }
    validates :recipient_type,      presence: true # main or cc. Must have at least 1 main recipient.

    belongs_to :report_cronjob

    def is_main?
        recipient_type == "main"
    end

    def is_cc?
        recipient_type == "cc"
    end
end