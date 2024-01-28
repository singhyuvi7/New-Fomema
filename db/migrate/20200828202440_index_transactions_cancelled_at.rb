class IndexTransactionsCancelledAt < ActiveRecord::Migration[6.0]
  def change
    add_index :transactions, :cancelled_at
  end
end
