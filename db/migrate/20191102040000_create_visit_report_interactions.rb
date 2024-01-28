class CreateVisitReportInteractions < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_interactions do |t|
      t.belongs_to :visit_report

      t.string :name
      t.string :designation
      t.string :digital_signature

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
