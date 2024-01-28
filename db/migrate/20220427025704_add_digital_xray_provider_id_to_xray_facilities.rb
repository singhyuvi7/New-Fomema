class AddDigitalXrayProviderIdToXrayFacilities < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_facilities, :digital_xray_provider_id, :bigint
  end
end
