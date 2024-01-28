class ServiceProviderPaymentWorker
    include Sidekiq::Worker
    include Sage

    def perform(batch_id,sp_fin_batches_ids)
        @batch = FinBatch.find(batch_id)
        sp_fin_batches = SpFinBatch.where(:id => sp_fin_batches_ids)
        submit_payment(sp_fin_batches)

        logger.info "SERVICE_PROVIDER_PAYMENT_WORKER DONE"
    end
end
  