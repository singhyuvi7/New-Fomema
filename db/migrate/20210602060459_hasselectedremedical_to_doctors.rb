class HasselectedremedicalToDoctors < ActiveRecord::Migration[6.0]
  def change
    add_column :doctors, :has_selected_re_medical, :boolean, default: false
  end
end
