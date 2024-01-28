class AddIgnoreSpecialRenewalToTransactions < ActiveRecord::Migration[6.0]
  def change
      add_column :transactions, :ignore_special_renewal_rule, :boolean, default: false
  end
end