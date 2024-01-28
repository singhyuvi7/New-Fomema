class AddDigitalXrayProviderCodeIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :digital_xray_providers, :code
  end
end
