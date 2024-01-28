class AddFinanceColumnsToSpFinBatches < ActiveRecord::Migration[6.0]
  def change
    add_column :sp_fin_batches, :invoice_no, :string
    add_column :sp_fin_batches, :invoice_date, :timestamp

    add_column :sp_fin_batches, :bank_account_number, :string
    add_reference :sp_fin_batches, :bank, index: true

    add_column :sp_fin_batches, :gst_tax, :decimal
    add_column :sp_fin_batches, :gst_code, :string
    add_column :sp_fin_batches, :gst_type, :integer
    add_column :sp_fin_batches, :gst_amount, :decimal, default: 0

    add_column :sp_fin_batches, :reference_id, :string
    add_column :sp_fin_batches, :transaction_type, :integer, default: 1

    add_column :sp_fin_batches, :created_by, :bigint, index: true
    add_column :sp_fin_batches, :updated_by, :bigint, index: true
  end
end
