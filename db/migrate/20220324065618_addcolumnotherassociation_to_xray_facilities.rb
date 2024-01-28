class AddcolumnotherassociationToXrayFacilities < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_facilities, :associations, :json
  end
end
