class CreateVisitReportGcmsDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_gcms_details do |t|
      t.references :gcms_detailable, polymorphic: true, index: { name: "index_vr_gcms_details_on_gcms_detailable" }
      
      t.string :urine_drug_category # VisitReport::URINE_DRUG_CATEGORIES OPIATES/CANNABINOIDS
      t.string :code
      t.text :comment

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
