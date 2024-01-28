class RenameRadiologistCompanyName < ActiveRecord::Migration[6.0]
  def change
    rename_column :radiologists, :company_name, :xray_facility_name
  end
end
