class DropTransactionsXrayPendingReviewApprovalFields < ActiveRecord::Migration[6.0]
  def change
    remove_column :transactions, :xray_pending_review_approval_decision, :string
    remove_column :transactions, :xray_pending_review_approval_comment, :text
  end
end
