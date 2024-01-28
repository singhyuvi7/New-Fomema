class AddIndexToHasselectedremedicalToXrayFacilites < ActiveRecord::Migration[6.0]
  def change
    add_index :xray_facilities, :has_selected_re_medical
  end
end
