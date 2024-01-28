class AddMedicalPrSourceToTransactions < ActiveRecord::Migration[6.0]
    def change
        add_column :transactions, :medical_pr_source, :string
        add_index :transactions, :medical_pr_source
    end
end