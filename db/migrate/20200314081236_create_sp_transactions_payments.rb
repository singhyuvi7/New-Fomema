class CreateSpTransactionsPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :sp_transactions_payments do |t|
      t.belongs_to :transaction

      t.bigint :service_providable_id
      t.string :service_providable_type

      t.decimal :amount
      t.datetime :pay_at

      t.string :gst_code
      t.string :gst_tax
      t.bigint :gst_type
      t.decimal :gstamount

      t.timestamps
    end
  end
end
