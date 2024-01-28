class AddInsuranceServiceProviderToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :insurance_service_provider_id, :bigint
    add_index :orders, :insurance_service_provider_id
  end
end
