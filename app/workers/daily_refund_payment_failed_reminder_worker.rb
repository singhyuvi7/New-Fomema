class DailyRefundPaymentFailedReminderWorker
    include Sidekiq::Worker
    include ReportsCronjob

    def perform
        daily_refund_payment_failed_reminder       
    end
end