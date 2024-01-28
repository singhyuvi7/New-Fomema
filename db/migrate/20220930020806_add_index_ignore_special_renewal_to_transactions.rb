class AddIndexIgnoreSpecialRenewalToTransactions < ActiveRecord::Migration[6.0]
  def change
      add_index :transactions, :ignore_special_renewal_rule
  end
end