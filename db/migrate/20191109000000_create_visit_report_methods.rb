class CreateVisitReportMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_methods do |t|
      t.references :methodable, polymorphic: true, index: { name: "index_vr_methods_on_methodable_id" }

      t.string :code
      t.string :instrumentation
      t.string :semi_auto
      t.string :fully_auto
      t.text :comment

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
