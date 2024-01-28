class AddRegIndCountToTransactionsAndForeignWorkers < ActiveRecord::Migration[6.0]
    def change
        add_column :transactions, :reg_ind, :integer
        add_column :foreign_workers, :reg_ind, :integer
        add_index :transactions, :reg_ind
        add_index :foreign_workers, :reg_ind
    end
end