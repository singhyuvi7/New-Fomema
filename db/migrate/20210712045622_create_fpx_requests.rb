class CreateFpxRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :fpx_requests do |t|
      t.belongs_to :order, optional: true
      t.string :msg_type
      t.string :msg_token, index: true
      t.string :seller_ex_id
      t.string :seller_ex_order_no
      t.string :seller_txn_time
      t.string :seller_order_no, index: true
      t.string :seller_id
      t.string :seller_bank_code
      t.string :txn_currency
      t.decimal :txn_amount
      t.string :buyer_email
      t.string :checksum
      t.string :buyer_name
      t.string :buyer_bank_id
      t.string :product_description
      t.string :version
      t.string :payment_url
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
      t.string :document_number
      t.datetime :sync_date, index: true
    end
  end
end
