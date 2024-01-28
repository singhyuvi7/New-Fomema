class AddIndexhasselectedremedicalToDoctors < ActiveRecord::Migration[6.0]
  def change
    add_index :doctors, :has_selected_re_medical
  end
end
