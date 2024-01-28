class CreateBolehRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :boleh_requests do |t|
      t.belongs_to :order, optional: true
      t.string :msg_type
      t.string :order_number, index: true
      t.string :ex_order_number
      t.decimal :amount
      t.string :user_name
      t.string :user_email
      t.string :user_contact
      t.string :remark
      t.string :response_url
      t.string :callback_url
      t.string :payment_url
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
      t.string :document_number
      t.datetime :sync_date, index: true
    end
  end
end
