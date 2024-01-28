class CreateIpay88Requests < ActiveRecord::Migration[5.2]
  def change
    create_table :ipay88_requests do |t|
      t.belongs_to :order, optional: true
      t.string :merchant_code
      t.string :merchant_key
      t.string :payment_id
      t.string :reference_number, index: true
      t.decimal :amount
      t.string :currency
      t.string :product_description
      t.string :user_name
      t.string :user_email
      t.string :user_contact
      t.string :remark
      t.string :lang
      t.string :signature_type
      t.string :signature
      t.string :response_url
      t.string :backend_url
      t.string :payment_url
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
