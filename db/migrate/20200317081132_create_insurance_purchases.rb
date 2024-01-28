class CreateInsurancePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :insurance_purchases do |t|

      t.belongs_to :order
      t.belongs_to :order_item

      t.date :start_date
      t.date :end_date

      t.string :product_purchased

      t.timestamps
    end
  end
end
