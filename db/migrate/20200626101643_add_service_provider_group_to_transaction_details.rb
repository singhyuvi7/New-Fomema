class AddServiceProviderGroupToTransactionDetails < ActiveRecord::Migration[6.0]
  def change
    add_column :transaction_details, :doc_sp_group_code, :string
    add_column :transaction_details, :doc_sp_group_name, :string
    add_column :transaction_details, :doc_sp_group_male_rate, :decimal
    add_column :transaction_details, :doc_sp_group_female_rate, :decimal

    add_column :transaction_details, :lab_sp_group_code, :string
    add_column :transaction_details, :lab_sp_group_name, :string
    add_column :transaction_details, :lab_sp_group_male_rate, :decimal
    add_column :transaction_details, :lab_sp_group_female_rate, :decimal

    add_column :transaction_details, :xray_sp_group_code, :string
    add_column :transaction_details, :xray_sp_group_name, :string
    add_column :transaction_details, :xray_sp_group_male_rate, :decimal
    add_column :transaction_details, :xray_sp_group_female_rate, :decimal
  end
end
