class MonthlyMedicalStatisticsReportsWorker
    include Sidekiq::Worker

    def perform(*args)
        date        = Date.today.last_month
        start_date  = date.beginning_of_year
        end_date    = date.end_of_month
        MedicalReportsMailer.with(filter_date_start: start_date, filter_date_end: end_date).medical_reports_med_monthly_stat_appeal.deliver_later
        MedicalReportsMailer.with(filter_date_start: start_date, filter_date_end: end_date).medical_reports_med_monthly_stat_pr.deliver_later
        MedicalReportsMailer.with(filter_date_start: start_date, filter_date_end: end_date).medical_reports_med_monthly_stat_tcupi.deliver_later
        MedicalReportsMailer.with(filter_date_start: start_date, filter_date_end: end_date).medical_reports_med_monthly_stat_reuse_passport.deliver_later
        MedicalReportsMailer.with(filter_date_start: start_date, filter_date_end: end_date).medical_reports_med_monthly_stat_unfit_reason.deliver_later
    end
end