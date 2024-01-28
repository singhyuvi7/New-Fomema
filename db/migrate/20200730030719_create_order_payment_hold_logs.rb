class CreateOrderPaymentHoldLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :order_payment_hold_logs do |t|

      t.belongs_to :order_payment, index: true
      t.bigint :holded_by, index: true
      t.datetime :holded_at
      t.text :hold_comment
      t.bigint :unholded_by, index: true
      t.datetime :unholded_at
      t.text :unhold_comment

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
