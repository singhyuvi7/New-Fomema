class AddCancelledByIdToTransactionAmendments < ActiveRecord::Migration[6.0]
    def change
        add_column :transaction_amendments, :cancelled_by_id, :integer
        add_index :transaction_amendments, :cancelled_by_id
    end
end
