class AddServiceProviderTypeToSpFinBatches < ActiveRecord::Migration[6.0]
  def change
    add_column :sp_fin_batches, :service_provider_type, :string, index: true
  end
end
