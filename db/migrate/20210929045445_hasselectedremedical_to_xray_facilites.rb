class HasselectedremedicalToXrayFacilites < ActiveRecord::Migration[6.0]
  def change
     add_column :xray_facilities, :has_selected_re_medical, :boolean, default: false
  end
end
