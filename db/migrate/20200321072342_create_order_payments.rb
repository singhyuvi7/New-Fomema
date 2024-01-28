class CreateOrderPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :order_payments do |t|
      t.bigint :order_id, index: true
      t.decimal :amount
      t.string :reference
      t.text :comment
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
