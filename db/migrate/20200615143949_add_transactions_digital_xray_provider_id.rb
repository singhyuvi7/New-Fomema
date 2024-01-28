class AddTransactionsDigitalXrayProviderId < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :digital_xray_provider_id, :bigint, index: true
  end
end
