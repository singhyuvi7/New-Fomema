class CreateInsuranceServiceProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :insurance_service_providers do |t|
      t.string :code, index: true
      t.string :name
      t.string :display_name
      t.boolean :active
      t.string :payment_to_code
      t.timestamps
      t.bigint :created_by
      t.bigint :updated_by
    end
  end
end
