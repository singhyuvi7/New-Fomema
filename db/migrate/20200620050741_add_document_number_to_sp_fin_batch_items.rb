class AddDocumentNumberToSpFinBatchItems < ActiveRecord::Migration[6.0]
  def change
    add_column :sp_fin_batch_items, :document_number, :string
  end
end
