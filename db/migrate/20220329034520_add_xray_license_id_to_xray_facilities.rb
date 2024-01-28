class AddXrayLicenseIdToXrayFacilities < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_facilities, :xray_license_purposes_id, :json 
  end
end
