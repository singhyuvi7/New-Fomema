class RefreshMvImmBlockedTransactionJob < ApplicationJob
    queue_as :default

    def perform(*args)
        ActiveRecord::Base.connection.execute("refresh materialized view mv_imm_blocked_transactions")
    end
end
