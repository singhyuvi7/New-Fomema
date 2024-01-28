class AddIgnoreMertsExpiryDateToTransactions < ActiveRecord::Migration[6.0]
    def change
        add_column :transactions, :ignore_merts_expiry_at, :datetime
        add_index :transactions, :ignore_merts_expiry_at
    end
end