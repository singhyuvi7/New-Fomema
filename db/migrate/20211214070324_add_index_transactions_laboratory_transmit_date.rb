class AddIndexTransactionsLaboratoryTransmitDate < ActiveRecord::Migration[6.0]
  def change
    add_index :transactions, :laboratory_transmit_date
  end
end
