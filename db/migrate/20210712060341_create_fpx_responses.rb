class CreateFpxResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :fpx_responses do |t|
      t.belongs_to :fpx_request, optional: true
      t.string :response_category
      t.string :msg_type
      t.string :msg_token, index: true
      t.string :fpx_txn_id
      t.string :seller_ex_id
      t.string :seller_ex_order_no
      t.string :fpx_txn_time
      t.string :seller_txn_time
      t.string :seller_order_no, index: true
      t.string :seller_id
      t.string :txn_currency
      t.decimal :txn_amount
      t.string :checksum
      t.string :buyer_name
      t.string :buyer_bank_id
      t.string :debit_auth_code
      t.string :debit_auth_no
      t.string :credit_auth_code
      t.string :credit_auth_no
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
