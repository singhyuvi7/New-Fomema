class AddWorksheetsToUrinePregnancy < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_urine_pregnancy_tests, :worksheet_document, :string
    add_column :visit_report_urine_pregnancy_tests, :worksheet_acknowledge, :string
    add_column :visit_report_urine_pregnancy_tests, :worksheet_validate_acknowledge, :string

    add_column :visit_report_hcg_verifications, :worksheet_document, :string
    add_column :visit_report_hcg_verifications, :worksheet_acknowledge, :string
    add_column :visit_report_hcg_verifications, :worksheet_validate_acknowledge, :string
  end
end
