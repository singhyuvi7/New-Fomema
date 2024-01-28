class AddTimestampsForQuarantineToTransactions < ActiveRecord::Migration[6.0]
    def change
        add_column :transactions, :medical_quarantine_release_date, :datetime
        add_column :transactions, :xray_quarantine_release_date, :datetime
        add_index :transactions, :medical_quarantine_release_date
        add_index :transactions, :xray_quarantine_release_date
    end
end