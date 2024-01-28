class AddIsImmBlockedToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :is_imm_blocked, :boolean, default: false
  end
end
