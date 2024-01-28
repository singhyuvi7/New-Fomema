class DropTransactionXrayPendingReviewsFields < ActiveRecord::Migration[6.0]
  def change
    remove_column :transactions, :xray_pending_review_type, :string
    remove_column :transactions, :xray_pending_review_decision, :string
    remove_column :transactions, :xray_pending_review_comment, :text
  end
end
