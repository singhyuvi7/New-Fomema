class AddTransmissionExpiredAtToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :transmission_expired_at, :datetime
    add_index :transactions, :transmission_expired_at
  end
end
