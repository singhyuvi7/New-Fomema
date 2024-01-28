class AddLatestTransactionToTransactions < ActiveRecord::Migration[6.0]
    def change
        add_column :transactions, :latest_transaction, :boolean, default: true
        add_index :transactions, :latest_transaction
    end
end