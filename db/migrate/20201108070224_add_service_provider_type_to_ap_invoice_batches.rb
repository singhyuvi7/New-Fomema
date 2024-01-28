class AddServiceProviderTypeToApInvoiceBatches < ActiveRecord::Migration[6.0]
  def change
    add_column :ap_invoice_batches, :service_provider_type, :string, index: true
    add_column :ap_invoice_batches, :remark, :string
  end
end
