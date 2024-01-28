class AddProviderToInsurancePurchases < ActiveRecord::Migration[6.0]
  def change
    add_column :insurance_purchases, :insurance_service_provider_id, :bigint
    add_index :insurance_purchases, :insurance_service_provider_id
  end
end
