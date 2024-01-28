class RefundBatchWorker
    include Sidekiq::Worker
    include Sage

    def perform(refund_batch_id)
        submit_refund_batch(refund_batch_id)

        logger.info "REFUND_BATCH_WORKER DONE"
    end
end
  