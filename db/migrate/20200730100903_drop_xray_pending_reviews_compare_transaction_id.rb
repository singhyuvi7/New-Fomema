class DropXrayPendingReviewsCompareTransactionId < ActiveRecord::Migration[6.0]
  def change
    remove_column :xray_pending_reviews, :compare_transaction_id, :bigint, index: true
  end
end
