class CreateIpInvoices < ActiveRecord::Migration[6.0]
  def change
    ## use polymorphic due to finance might change their mind one day on the way the payment send to sage
    ## and for future new insurance vendor
    
    create_table :ip_invoices do |t|
      t.bigint :batchable_id
      t.string :batchable_type
      t.string :payment_to
      t.date :payment_date
      t.decimal :total_amount
      t.string :document_number, index: true
      t.string :status
      t.text :fail_reason

      t.timestamps
    end

    add_index :ip_invoices, [:batchable_id, :batchable_type]
  end
end
