class DropTransactionsPcrReviewBy < ActiveRecord::Migration[6.0]
  def change
    remove_column :transactions, :pcr_review_by, :bigint, index: true
  end
end
