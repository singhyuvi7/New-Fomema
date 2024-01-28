class AddFeesToInsurancePurchases < ActiveRecord::Migration[6.0]
  def change
    add_column :insurance_purchases, :gross_premium, :decimal, default: 0
    add_column :insurance_purchases, :stamp_duty, :decimal, default: 0
    add_column :insurance_purchases, :sst, :decimal, default: 0
    add_column :insurance_purchases, :adminfees, :decimal, default: 0
    add_column :insurance_purchases, :adminfees_sst, :decimal, default: 0
    add_column :insurance_purchases, :total_premium, :decimal, default: 0
  end
end