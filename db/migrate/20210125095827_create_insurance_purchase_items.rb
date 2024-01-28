class CreateInsurancePurchaseItems < ActiveRecord::Migration[6.0]
  def change
    create_table :insurance_purchase_items do |t|

      t.belongs_to :insurance_purchase
      t.string :product_name
      t.date :start_date
      t.date :end_date

      t.string :policy_status
      t.timestamps
    end
  end
end
