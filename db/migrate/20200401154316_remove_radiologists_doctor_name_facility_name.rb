class RemoveRadiologistsDoctorNameFacilityName < ActiveRecord::Migration[6.0]
  def change
    remove_column :radiologists, :doctor_name, :string
    remove_column :radiologists, :facility_name, :string
  end
end
