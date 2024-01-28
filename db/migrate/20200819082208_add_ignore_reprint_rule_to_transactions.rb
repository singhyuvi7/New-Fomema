class AddIgnoreReprintRuleToTransactions < ActiveRecord::Migration[6.0]
    def change
        add_column :transactions, :ignore_reprint_rule, :boolean, default: false
    end
end