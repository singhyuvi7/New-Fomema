class AddIndexToTransactionsExpiredAt < ActiveRecord::Migration[6.0]
  def change
    add_index :transactions, :expired_at
  end
end
