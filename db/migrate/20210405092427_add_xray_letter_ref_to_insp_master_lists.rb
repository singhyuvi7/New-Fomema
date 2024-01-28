class AddXrayLetterRefToInspMasterLists < ActiveRecord::Migration[6.0]
  def change
    add_column :insp_master_lists, :xray_letter_ref, :string
    add_column :insp_master_lists, :xray_letter_date, :date
  end
end
