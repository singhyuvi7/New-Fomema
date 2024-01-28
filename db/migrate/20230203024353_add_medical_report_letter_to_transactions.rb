class AddMedicalReportLetterToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :medical_report_letter_download, :boolean, default: false
  end
end
