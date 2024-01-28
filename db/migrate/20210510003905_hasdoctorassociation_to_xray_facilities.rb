class HasdoctorassociationToXrayFacilities < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_facilities, :has_doctor_association, :boolean
    add_column :xray_facilities, :membership_number, :string
    add_column :xray_facilities, :name_of_association, :string
  end
end
