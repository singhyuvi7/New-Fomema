class DailyDisableIgnoreExpiryWorker
    include Sidekiq::Worker

    def perform(*args)
        # Auto update ignore_expiry to false, ignore_merts_expiry_at to null if no certification after transmission expired (ignore_expiry)
        # This is to block doctor transmit result after revenue recognized (to avoid double revenue recognition)
        # To cater for ignore_expiry & transmission_expired_at which are updated from backend. Started to update from backend on 18/07/2022
        Transaction.where("transactions.ignore_expiry = true and transactions.certification_date is null and transactions.transmission_expired_at is not null")
        .where("transactions.transmission_expired_at >= '2022-07-18'")
        .where(transmission_expired_at: DateTime.now.beginning_of_day)
        .each do |transaction|
            transaction.update({
                ignore_expiry: false,
                ignore_merts_expiry_at: nil
            })
        end
    end
end