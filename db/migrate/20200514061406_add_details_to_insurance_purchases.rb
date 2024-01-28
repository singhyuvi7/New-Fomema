class AddDetailsToInsurancePurchases < ActiveRecord::Migration[6.0]
  def change
    add_column :insurance_purchases, :batch_id, :bigint
    add_column :insurance_purchases, :reg_id, :bigint
    add_reference :insurance_purchases, :employer, :null => true
    add_column :insurance_purchases, :worker_name, :string
    add_column :insurance_purchases, :insurance_provider, :string
  end
end
