class AddReMedicalToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :is_next_transaction_re_medical, :boolean, default: false
  end
end