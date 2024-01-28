class AddWorksheetsToHivVerifications < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_hiv_verifications, :worksheet_document, :string
    add_column :visit_report_hiv_verifications, :worksheet_acknowledge, :string
    add_column :visit_report_hiv_verifications, :worksheet_validate_acknowledge, :string
  end
end