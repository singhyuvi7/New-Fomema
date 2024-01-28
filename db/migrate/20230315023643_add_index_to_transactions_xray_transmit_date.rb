class AddIndexToTransactionsXrayTransmitDate < ActiveRecord::Migration[6.0]
  def change
    add_index :transactions, :xray_transmit_date
    add_index :transactions, :condition_amended_at
  end
end
