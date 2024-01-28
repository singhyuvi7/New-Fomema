class AddCancelledAtToTransactionAmendments < ActiveRecord::Migration[6.0]
    def change
        add_column :transaction_amendments, :cancelled_at, :datetime
        add_index :transaction_amendments, :cancelled_at
    end
end
