class RemoveTransactionsCancelFields < ActiveRecord::Migration[6.0]
    def change
        remove_column :transactions, :cancelled_by, :bigint
        remove_column :transactions, :cancelled_at, :datetime
        remove_column :transactions, :cancel_reason, :text
    end
end
