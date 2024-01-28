class CreateVisitReportReagents < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_reagents do |t|
      t.belongs_to :reagentable, polymorphic: true, index: { name: "index_vr_reagents_on_reagentable_id" }

      t.string :urine_drug_category # VisitReport::URINE_DRUG_CATEGORIES OPIATES/CANNABINOIDS
      t.belongs_to :anti_sera
      t.belongs_to :reagent
      t.text :comment

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
