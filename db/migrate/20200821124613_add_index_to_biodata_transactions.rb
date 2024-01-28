class AddIndexToBiodataTransactions < ActiveRecord::Migration[6.0]
  def change
    add_index :biodata_transactions, :created_at
    add_index :biodata_transactions, :updated_at
  end
end
