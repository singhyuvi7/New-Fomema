class ReportCronjobMailSent < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    validates :report_cronjob_id,   presence: true

    belongs_to :report_cronjob

    serialize :main_recipients, Array
    serialize :cc_recipients, Array
end