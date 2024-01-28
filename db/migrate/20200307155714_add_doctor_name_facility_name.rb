class AddDoctorNameFacilityName < ActiveRecord::Migration[6.0]
  def change
    add_column :doctors, :doctor_name, :string
    add_column :doctors, :facility_name, :string
    add_column :xray_facilities, :doctor_name, :string
    add_column :xray_facilities, :facility_name, :string
    add_column :laboratories, :doctor_name, :string
    add_column :laboratories, :facility_name, :string
    add_column :radiologists, :doctor_name, :string
    add_column :radiologists, :facility_name, :string
  end
end
