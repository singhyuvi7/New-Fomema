class AddFromMigrationToBankDraftsAndOrderPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :bank_drafts, :from_migration, :boolean, default: false

    add_column :order_payments, :process_fee, :decimal, default: 0
    add_column :order_payments, :additional_fee_charge, :decimal, default: 0
    add_column :order_payments, :gst_amount, :decimal, default: 0
    add_column :order_payments, :gst_percentage, :decimal, default: 0
    add_column :order_payments, :additional_gst_charge, :decimal, default: 0
    add_column :order_payments, :from_migration, :boolean, default: false
    add_column :order_payments, :sync_cancel_status, :int
  end
end
