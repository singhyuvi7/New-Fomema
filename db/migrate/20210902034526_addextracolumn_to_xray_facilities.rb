class AddextracolumnToXrayFacilities < ActiveRecord::Migration[6.0]
  def change
    # add_column :xray_facilities, :nationality, :string
    add_column :xray_facilities, :gender, :string
    # add_column :xray_facilities, :race, :string
  end
end
