class AddDocumentNumberToIpay88Requests < ActiveRecord::Migration[6.0]
  def change
     add_column :ipay88_requests, :document_number, :string
  end
end
