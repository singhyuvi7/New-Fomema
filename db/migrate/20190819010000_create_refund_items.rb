class CreateRefundItems < ActiveRecord::Migration[5.2]
  def change
    create_table :refund_items do |t|
      t.belongs_to :refund
      t.bigint :refund_itemable_id
      t.string :refund_itemable_type
      t.decimal :amount, default: 0
      t.text :comment
      t.json :additional_information

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end

    add_index :refund_items, [:refund_itemable_id, :refund_itemable_type], name: "index_refund_items_on_refund_itemable"
  end
end
