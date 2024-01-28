class AddDocumentNumberToOrderPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :order_payments, :document_number, :string
  end
end
