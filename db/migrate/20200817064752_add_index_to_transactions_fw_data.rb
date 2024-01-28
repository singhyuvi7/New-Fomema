class AddIndexToTransactionsFwData < ActiveRecord::Migration[6.0]
    def change
        add_index :transactions, :fw_code
        add_index :transactions, :fw_name
        add_index :transactions, :fw_gender
        add_index :transactions, :fw_passport_number
        add_index :transactions, :fw_country_id
        add_index :transactions, :fw_maid_online
        add_index :transactions, :organization_id
        add_index :transactions, :fw_job_type_id
        add_index :transactions, :certification_date
    end
end