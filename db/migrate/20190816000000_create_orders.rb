class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :code
      t.bigint :customerable_id
      t.string :customerable_type
      t.belongs_to :payment_method
      t.string :category, index: true
      t.date :date
      t.decimal :amount
      t.string :status, index: true, default: 'NEW'
      t.text :comment
      t.json :additional_information

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
    
    add_index :orders, :code, unique: true
    add_index :orders, [:customerable_id, :customerable_type]
  end
end
