class AddTransactionsIsSpecialRenewal < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :is_special_renewal, :boolean, default: false, index: true
  end
end
