class AddColumnsToInsurancePurchases < ActiveRecord::Migration[6.0]
  def change
    add_column :insurance_purchases, :status, :string

    ## emp info
    add_column :insurance_purchases,:emp_code, :string
    add_index :insurance_purchases, :emp_code
    add_column :insurance_purchases,:emp_name, :string
    add_index :insurance_purchases, :emp_name

    ## fw info
    add_column :insurance_purchases, :foreign_worker_id, :bigint
    add_index :insurance_purchases, :foreign_worker_id

    rename_column :insurance_purchases, :worker_name, :fw_name
    add_index :insurance_purchases, :fw_name
    add_column :insurance_purchases, :fw_code, :string
    add_index :insurance_purchases, :fw_code
    add_column :insurance_purchases, :fw_gender, :string
    add_column :insurance_purchases, :fw_date_of_birth, :date
    add_column :insurance_purchases, :fw_passport_number, :string
    add_index :insurance_purchases, :fw_passport_number
    add_column :insurance_purchases, :fw_country_id, :bigint
    add_column :insurance_purchases, :fw_job_type_id, :bigint
  end
end
