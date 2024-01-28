class AddIsCollectionToInsurancePurchases < ActiveRecord::Migration[6.0]
  def change
    add_column :insurance_purchases, :is_collection, :boolean, default: false
  end
end
