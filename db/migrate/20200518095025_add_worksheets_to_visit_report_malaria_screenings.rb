class AddWorksheetsToVisitReportMalariaScreenings < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_malaria_screenings, :worksheet_document, :string
    add_column :visit_report_malaria_screenings, :worksheet_acknowledge, :string
    add_column :visit_report_malaria_screenings, :worksheet_validate_acknowledge, :string
  end
end
