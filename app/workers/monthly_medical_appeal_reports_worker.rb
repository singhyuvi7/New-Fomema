class MonthlyMedicalAppealReportsWorker
    include Sidekiq::Worker

    def perform(*args)
        date        = Date.today.last_month
        start_date  = date.beginning_of_year
        end_date    = date.end_of_month
        MedicalReportsMailer.with(filter_date_start: start_date, filter_date_end: end_date).medical_reports_monthly_medical_appeal.deliver_later
    end
end