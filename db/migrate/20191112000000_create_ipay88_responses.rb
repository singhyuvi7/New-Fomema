class CreateIpay88Responses < ActiveRecord::Migration[5.2]
  def change
    create_table :ipay88_responses do |t|
      t.belongs_to :ipay88_request, optional: true
      t.string :response_category
      t.string :merchant_code
      t.string :payment_id
      t.string :reference_number, index: true
      t.decimal :amount
      t.string :currency
      t.string :remark
      t.string :transaction_id, index: true
      t.string :authentication_code
      t.string :status
      t.string :error_description
      t.string :signature
      t.string :cc_name
      t.string :cc_number
      t.string :s_bank_name
      t.string :s_country
      t.string :bank_mid
      t.date :transaction_date
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
