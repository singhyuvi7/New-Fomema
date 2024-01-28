class InsurancePaymentWorker
    include Sidekiq::Worker
    include Sage

    def perform(batch_id)
        submit_insurance_payment(batch_id)

        logger.info "INSURANCE_PAYMENT_WORKER DONE"
    end
end
  