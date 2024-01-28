class DropTransactionsXrayPendingReviewApprovalId < ActiveRecord::Migration[6.0]
  def change
    remove_column :transactions, :xray_pending_review_approval_id, :bigint, index: true
  end
end
