class MonthlyAppealTypeOfDiseasesReportsWorker
    include Sidekiq::Worker

    def perform(*args)
        date = Date.today.last_month
        MedicalReportsMailer.with(query_month: date).medical_reports_monthly_type_of_diseases.deliver_later
    end
end