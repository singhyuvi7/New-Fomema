class DropTransactionsXrayXqccReviewFields < ActiveRecord::Migration[6.0]
  def change
    remove_column :transactions, :xray_xqcc_review_id, :bigint, index: true
    remove_column :transactions, :xray_xqcc_review_decision, :string
    remove_column :transactions, :xray_xqcc_review_comment, :text
  end
end
