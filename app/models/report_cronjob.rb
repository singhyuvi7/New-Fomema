class ReportCronjob < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    validates :report_name, presence: true, uniqueness: true

    has_many :report_cronjob_emails
    has_many :report_cronjob_mail_sents
end

# Create permissions too.