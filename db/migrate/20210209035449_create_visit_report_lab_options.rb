class CreateVisitReportLabOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :visit_report_lab_options do |t|
      t.string :report_category
      t.string :field_name
      t.string :code
      t.string :name
      
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
