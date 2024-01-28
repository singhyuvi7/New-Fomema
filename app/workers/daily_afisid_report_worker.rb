class DailyAfisidReportWorker < ActionController::Base
    include Sidekiq::Worker
    include ReportsCronjob

    def perform(*args)
        @current = Time.now
        daily_afisid
    end
end
