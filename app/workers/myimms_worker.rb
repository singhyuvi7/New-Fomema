class MyimmsWorker
    include Sidekiq::Worker
  
    def perform
        ## check if theres final result but no myimms_transaction row
        transactions = Transaction.joins('LEFT JOIN myimms_transactions mt on transactions.id = mt.transaction_id').where("mt.id is null and transactions.created_at >= '2020-11-02'").where.not(:final_result => [nil,''])

        transactions.each do |transaction|
            if !transaction&.physical_exam_not_done? || transaction&.transaction_amendments.present?
                MyimmsTransaction.create({
                    transaction_id: transaction.id,
                    status: 97
                })
            end
        end

        ids_batches = MyimmsTransaction.where(:status => ['0','96','97','98','99']).where("created_at >= CURRENT_TIMESTAMP - INTERVAL '12 months'").in_batches(of: 100)
        ids_batches.each do |ids_batch|
            ids = ids_batch.pluck(:transaction_id)
            if !ids.blank?
                response = MyimmsGateway.call(ids)
                sleep(3)
            end
        end
    end
end
  