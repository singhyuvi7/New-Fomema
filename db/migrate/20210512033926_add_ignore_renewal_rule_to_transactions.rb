class AddIgnoreRenewalRuleToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :ignore_renewal_rule, :boolean, default: false
  end
end
