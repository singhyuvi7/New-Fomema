class CreateIpay88Types < ActiveRecord::Migration[6.0]
  def change
    create_table :ipay88_types do |t|
      t.string :code, index: true
      t.string :name, index: true
      t.string :payment_code, index: true

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
