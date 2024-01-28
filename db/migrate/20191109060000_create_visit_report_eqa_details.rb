class CreateVisitReportEqaDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_eqa_details do |t|
      t.references :eqa_detailable, polymorphic: true, index: { name: "index_vr_eqa_details_on_eqa_detailable" }
      
      t.string :urine_drug_category # VisitReport::URINE_DRUG_CATEGORIES OPIATES/CANNABINOIDS
      t.string :code, index: true

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
