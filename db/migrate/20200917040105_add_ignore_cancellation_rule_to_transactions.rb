class AddIgnoreCancellationRuleToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :ignore_cancellation_rule, :boolean, default: false
  end
end
