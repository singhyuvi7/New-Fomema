class AddWorksheetsToHivConfirmatories < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_hiv_confirmatories, :worksheet_document, :string
    add_column :visit_report_hiv_confirmatories, :worksheet_acknowledge, :string
    add_column :visit_report_hiv_confirmatories, :worksheet_validate_acknowledge, :string
    add_column :visit_report_hiv_confirmatories, :remarks, :string
  end
end
