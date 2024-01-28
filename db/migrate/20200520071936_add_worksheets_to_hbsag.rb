class AddWorksheetsToHbsag < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_hbsag_screenings, :worksheet_document, :string
    add_column :visit_report_hbsag_screenings, :worksheet_acknowledge, :string
    add_column :visit_report_hbsag_screenings, :worksheet_validate_acknowledge, :string

    add_column :visit_report_hbsag_verifications, :worksheet_document, :string
    add_column :visit_report_hbsag_verifications, :worksheet_acknowledge, :string
    add_column :visit_report_hbsag_verifications, :worksheet_validate_acknowledge, :string

    add_column :visit_report_hbsag_appeals , :worksheet_document, :string
    add_column :visit_report_hbsag_appeals , :worksheet_acknowledge, :string
    add_column :visit_report_hbsag_appeals , :worksheet_validate_acknowledge, :string
    add_column :visit_report_hbsag_appeals, :remarks, :string
  end
end
