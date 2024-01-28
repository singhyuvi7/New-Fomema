class AddWorksheetsToVisitReportBloodGroupings < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_blood_groupings, :worksheet_document, :string
    add_column :visit_report_blood_groupings, :worksheet_acknowledge, :string
    add_column :visit_report_blood_groupings, :worksheet_validate_acknowledge, :string
  end
end
