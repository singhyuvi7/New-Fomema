class AddWorksheetsToUrineBiochemistry < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_urine_biochemistries, :worksheet_document, :string
    add_column :visit_report_urine_biochemistries, :worksheet_acknowledge, :string
    add_column :visit_report_urine_biochemistries, :worksheet_validate_acknowledge, :string

    add_column :visit_report_urine_biochemistry_verifications, :worksheet_document, :string
    add_column :visit_report_urine_biochemistry_verifications, :worksheet_acknowledge, :string
    add_column :visit_report_urine_biochemistry_verifications, :worksheet_validate_acknowledge, :string
  end
end
