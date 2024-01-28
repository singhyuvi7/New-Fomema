class IndexMyimmsTransactionsStatus < ActiveRecord::Migration[6.0]
  def change
    add_index :myimms_transactions, :status
  end
end
