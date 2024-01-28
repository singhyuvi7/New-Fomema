class AddWorksheetsToVdrlTpha < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_vdrls, :worksheet_document, :string
    add_column :visit_report_vdrls, :worksheet_acknowledge, :string
    add_column :visit_report_vdrls, :worksheet_validate_acknowledge, :string

    add_column :visit_report_tphas, :worksheet_document, :string
    add_column :visit_report_tphas, :worksheet_acknowledge, :string
    add_column :visit_report_tphas, :worksheet_validate_acknowledge, :string
  end
end
