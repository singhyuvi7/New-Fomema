class AddDocumentNumberToBankDrafts < ActiveRecord::Migration[6.0]
  def change
    add_column :bank_drafts, :document_number, :string
  end
end
