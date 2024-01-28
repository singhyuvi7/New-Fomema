class AddTransactionsPcrReviewId < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :pcr_review_id, :bigint, index: true
  end
end
