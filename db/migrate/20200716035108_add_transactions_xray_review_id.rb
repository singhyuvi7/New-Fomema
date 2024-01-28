class AddTransactionsXrayReviewId < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :xray_review_id, :bigint, index: true
  end
end
