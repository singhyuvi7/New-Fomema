class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.belongs_to :fin_batch
      t.string :invoice_no
      
      t.bigint :batchable_id
      t.string :batchable_type

      t.decimal :total_amount
      t.decimal :gst_amount
      t.decimal :invoice_amount

      t.decimal :male_rate
      t.decimal :female_rate

      t.string :gst_code
      t.integer :gst_type
      t.integer :gst_tax

      t.string :status

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
