class AddTransactionsFwPati < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :fw_pati, :boolean
  end
end
