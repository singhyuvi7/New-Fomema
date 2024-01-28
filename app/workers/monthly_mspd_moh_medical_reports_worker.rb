class MonthlyMspdMohMedicalReportsWorker
    include Sidekiq::Worker

    def perform(*args)
        MspdMonthlyReportingMailer.mspd_moh_monthly.deliver_later
    end
end