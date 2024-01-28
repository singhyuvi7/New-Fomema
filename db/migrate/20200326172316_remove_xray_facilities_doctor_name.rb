class RemoveXrayFacilitiesDoctorName < ActiveRecord::Migration[6.0]
  def change
    remove_column :xray_facilities, :doctor_name, :string
    remove_column :xray_facilities, :license_holder_name, :string
  end
end
