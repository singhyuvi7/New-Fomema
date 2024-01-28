class CreateInvoiceItems < ActiveRecord::Migration[6.0]
  def change
    create_table :invoice_items do |t|
      t.belongs_to :sp_fin_batch
      t.belongs_to :transaction

      t.string :invoice_no
      t.references :itemable, polymorphic: true
      t.string :sex

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end