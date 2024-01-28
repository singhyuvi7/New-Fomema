class CreateVisitReportVisitors < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_visitors do |t|
      t.belongs_to :visit_report
      t.bigint :visitor_id, index: true

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
