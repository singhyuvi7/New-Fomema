class AddCommunicableDiseasesToTransactions < ActiveRecord::Migration[6.0]
    def change
        add_column :transactions, :communicable_diseases, :boolean
        add_index :transactions, :communicable_diseases
    end
end