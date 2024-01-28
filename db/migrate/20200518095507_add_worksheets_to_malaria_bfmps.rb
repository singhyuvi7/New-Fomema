class AddWorksheetsToMalariaBfmps < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_malaria_bfmps, :worksheet_document, :string
    add_column :visit_report_malaria_bfmps, :worksheet_acknowledge, :string
    add_column :visit_report_malaria_bfmps, :worksheet_validate_acknowledge, :string
  end
end
