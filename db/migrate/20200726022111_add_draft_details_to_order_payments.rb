class AddDraftDetailsToOrderPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :order_payments, :issue_date, 	:date
    add_column :order_payments, :bad, :boolean, index: true, default: false
    add_column :order_payments, :bad_at, :datetime, index: true
    add_column :order_payments, :holded, :boolean, index: true, default: false
    add_column :order_payments, :holded_at, :datetime, index: true
    add_column :order_payments, :holded_by, :bigint, index: true
    add_column :order_payments, :replacement_id, :bigint, index: true

    add_column :order_payments, :sync_date, :datetime, index: true
    add_column :order_payments, :sync_bad_date, :datetime, index: true
  end
end
