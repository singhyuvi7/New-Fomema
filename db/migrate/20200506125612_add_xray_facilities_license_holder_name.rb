class AddXrayFacilitiesLicenseHolderName < ActiveRecord::Migration[6.0]
  def change
    rename_column :xray_facilities, :facility_name, :license_holder_name
  end
end
