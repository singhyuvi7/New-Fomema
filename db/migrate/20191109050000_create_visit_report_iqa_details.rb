class CreateVisitReportIqaDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_iqa_details do |t|
      t.references :iqa_detailable, polymorphic: true, index: { name: "index_vr_iqa_details_on_iqa_detailable" }
      
      t.string :urine_drug_category # VisitReport::URINE_DRUG_CATEGORIES OPIATES/CANNABINOIDS
      t.string :code, index: true

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
