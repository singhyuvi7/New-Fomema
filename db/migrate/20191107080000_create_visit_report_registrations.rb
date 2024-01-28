class CreateVisitReportRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_registrations do |t|
      t.belongs_to :visit_report

      t.string :category, index: true
      t.string :mode, index: true

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
