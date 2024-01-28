class AddWorksheetsToUrineDrug < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_urine_drug_screenings, :opiates_worksheet_document, :string
    add_column :visit_report_urine_drug_screenings, :opiates_worksheet_acknowledge, :string
    add_column :visit_report_urine_drug_screenings, :opiates_worksheet_validate_acknowledge, :string
    add_column :visit_report_urine_drug_screenings, :cannabinoids_worksheet_document, :string
    add_column :visit_report_urine_drug_screenings, :cannabinoids_worksheet_acknowledge, :string
    add_column :visit_report_urine_drug_screenings, :cannabinoids_worksheet_validate_acknowledge, :string

    add_column :visit_report_urine_drug_verifications, :opiates_worksheet_document, :string
    add_column :visit_report_urine_drug_verifications, :opiates_worksheet_acknowledge, :string
    add_column :visit_report_urine_drug_verifications, :opiates_worksheet_validate_acknowledge, :string
    add_column :visit_report_urine_drug_verifications, :cannabinoids_worksheet_document, :string
    add_column :visit_report_urine_drug_verifications, :cannabinoids_worksheet_acknowledge, :string
    add_column :visit_report_urine_drug_verifications, :cannabinoids_worksheet_validate_acknowledge, :string
  end
end
