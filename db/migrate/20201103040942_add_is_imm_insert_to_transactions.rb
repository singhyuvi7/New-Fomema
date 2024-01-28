class AddIsImmInsertToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :is_imm_insert, :boolean, default: false
  end
end
