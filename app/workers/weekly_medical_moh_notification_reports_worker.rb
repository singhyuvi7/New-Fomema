class WeeklyMedicalMohNotificationReportsWorker
    include Sidekiq::Worker

    def perform(*args)
        date            = Date.today
        start_date      = date.beginning_of_week - 15.days # Must start on Sunday
        end_date        = start_date + 6.days
        MedicalReportsMailer.with(filter_date_start: start_date, filter_date_end: end_date).medical_reports_weekly_cronjob_moh_weekly_email_report.deliver_later
    end
end