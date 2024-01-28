class AddFinalResultDateToTransactions < ActiveRecord::Migration[6.0]
    def change
        add_column :transactions, :final_result_date, :datetime
        add_index :transactions, :final_result_date
    end
end