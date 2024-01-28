class RefreshMvImmBlockedTransactionWorker < ActionController::Base
    include Sidekiq::Worker

    def perform(*args)
        RefreshMvImmBlockedTransactionJob.perform_later
    end
end
