class DailyUnblockImmWorker < ActionController::Base
    include Sidekiq::Worker
    include WorkerBlocking

    def perform(*args)
        # Unblock IMM if the transaction is registered by agency and is expired

        if args.present?
            date = args.first
        else
            date = Date.yesterday
        end

        transactions = Transaction.where(medical_examination_date: nil, expired_at: date).where.not(agency_id: nil)

        unblock_reason = BlockReason.find_by(code: "OTHER", category: "UNBLOCK")
        unblock_comment = "TRANSACTION EXPIRED, DOCUMENT VERIFICATION NOT DONE BY OPERATION TEAM."

        transactions.each do |transaction|
            if transaction.id == transaction.foreign_worker.latest_transaction_id and transaction.foreign_worker.is_imm_blocked and transaction.foreign_worker.block_reason.code == "DOCVERIFY"
                unblock_imm(transaction.foreign_worker, unblock_reason, unblock_comment)
            end
        end
    end
end
