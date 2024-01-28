class CreateApInvoiceBatches < ActiveRecord::Migration[6.0]
  def change
    create_table :ap_invoice_batches do |t|
      t.string :batch_number

      t.bigint :batchable_id
      t.string :batchable_type

      t.timestamps
    end
  end
end
