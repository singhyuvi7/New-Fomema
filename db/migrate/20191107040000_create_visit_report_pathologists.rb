class CreateVisitReportPathologists < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_pathologists do |t|
      t.belongs_to :visit_report
      t.string :name
      t.string :category, index: true
      t.string :log_book, index: true
      t.text :comment

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
