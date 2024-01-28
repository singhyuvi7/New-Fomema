class RemoveSpDoctorNameFacilityName < ActiveRecord::Migration[6.0]
  def change
    remove_column :doctors, :doctor_name, :string
    remove_column :doctors, :facility_name, :string
    remove_column :laboratories, :doctor_name, :string
    remove_column :laboratories, :facility_name, :string
  end
end
