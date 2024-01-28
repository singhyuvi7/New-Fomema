class AddMedicalIndicatorCountToForeignWorkers < ActiveRecord::Migration[6.0]
    def change
        add_column :foreign_workers, :med_ind_count, :integer, default: 0
        add_index :foreign_workers, :med_ind_count
        add_column :transactions, :med_ind_count, :integer
        add_index :transactions, :med_ind_count
    end
end