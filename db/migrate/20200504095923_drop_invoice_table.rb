require "./db/migrate/20200429091138_create_invoices.rb"
require "./db/migrate/20200429095204_create_invoice_items.rb"

class DropInvoiceTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :invoices
    drop_table :invoice_items
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
    CreateInvoices.new.migrate(:up)
    CreateInvoiceItems.new.migrate(:up)
  end
end
