class CreateVisitReportBarcodings < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_barcodings do |t|
      t.belongs_to :visit_report

      t.string :mode, index: true

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
