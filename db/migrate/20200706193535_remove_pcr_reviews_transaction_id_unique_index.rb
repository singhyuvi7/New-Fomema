class RemovePcrReviewsTransactionIdUniqueIndex < ActiveRecord::Migration[6.0]
  def change
    # to remove unique index, has to remove the index first
    remove_index :pcr_reviews, :transaction_id
    # then recreate the index without unique constraint
    add_index :pcr_reviews, :transaction_id
  end
end
