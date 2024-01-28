class MyimmsErrorReportWorker
    include Sidekiq::Worker
    include ReportsCronjob
  
    def perform(*args)
    	daily_myimms_error_report
    end
end
