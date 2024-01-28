class AddAdditionalDetailsToSpFinBatches < ActiveRecord::Migration[6.0]
  def change
    add_column :sp_fin_batches, :company_name, :string
    add_column :sp_fin_batches, :clinic_name, :string

    # sp_fin_batch_items table
    add_reference :sp_fin_batch_items, :itemable, polymorphic: true
    add_column :sp_fin_batch_items, :company_name, :string
    add_column :sp_fin_batch_items, :clinic_name, :string
  end
end
