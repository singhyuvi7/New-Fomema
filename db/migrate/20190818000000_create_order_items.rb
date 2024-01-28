class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.belongs_to :order
      t.bigint :order_itemable_id
      t.string :order_itemable_type
      t.belongs_to :fee
      t.decimal :amount, default: 0
      t.text :comment
      t.json :additional_information

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end

    add_index :order_items, [:order_itemable_id, :order_itemable_type]
  end
end
