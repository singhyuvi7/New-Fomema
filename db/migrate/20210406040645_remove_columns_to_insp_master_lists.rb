class RemoveColumnsToInspMasterLists < ActiveRecord::Migration[6.0]
  def change
    rename_column :insp_master_lists, :doctor_code, :sp_code
    rename_column :insp_master_lists, :nc_clinic, :nc

    remove_column :insp_master_lists, :xray_code, :varchar
    remove_column :insp_master_lists, :nc_xray, :varchar
    remove_column :insp_master_lists, :xray_letter_ref, :string
    remove_column :insp_master_lists, :xray_letter_date, :date

    rename_column :visit_reports, :doctor_explanation_letter_date, :explanation_letter_date
    remove_column :visit_reports, :xray_explanation_letter_date, :timestamp
  end
end
