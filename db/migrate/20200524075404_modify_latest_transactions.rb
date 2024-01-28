class ModifyLatestTransactions < ActiveRecord::Migration[6.0]
    def change
        remove_column :transactions, :latest_transaction
        add_column :foreign_workers, :latest_transaction_id, :bigint
        add_index :foreign_workers, :latest_transaction_id
    end
end