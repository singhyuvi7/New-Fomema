class MonthlyTransactionCertifyStaticSeedWorker
    include Sidekiq::Worker

    def perform(*args)
        date            = Date.today
        start_of_month  = date.beginning_of_month.last_month
        end_of_month    = start_of_month.next_month
        TransactionCertifyStatic.seed_transaction_certify_static(start_of_month, end_of_month)
    end
end