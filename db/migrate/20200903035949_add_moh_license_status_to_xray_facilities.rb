class AddMohLicenseStatusToXrayFacilities < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_facilities, :moh_license_status, :string
  end
end
