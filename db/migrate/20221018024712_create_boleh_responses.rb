class CreateBolehResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :boleh_responses do |t|
      t.belongs_to :boleh_request, optional: true
      t.string :response_category
      t.string :order_number, index: true
      t.string :ex_order_number
      t.decimal :amount
      t.string :transaction_id, index: true
      t.string :status
      t.string :signature
      t.date :payment_date
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
