class CreateVisitReportCoverages < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_coverages do |t|
      t.belongs_to :visit_report
      t.belongs_to :state
      t.belongs_to :town

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
