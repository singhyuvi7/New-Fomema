class AddDocumentNumberToRefunds < ActiveRecord::Migration[6.0]
  def change
    add_column :refunds, :document_number, :string
  end
end
