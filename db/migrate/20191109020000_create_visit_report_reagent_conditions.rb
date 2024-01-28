class CreateVisitReportReagentConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_reagent_conditions do |t|
      t.belongs_to :reagent_conditionable, polymorphic: true, index: { name: "index_vr_reagent_conditions_on_reagent_conditionable_id" }

      t.string :urine_drug_category # VisitReport::URINE_DRUG_CATEGORIES OPIATES/CANNABINOIDS
      t.belongs_to :anti_sera
      t.string :reagent_name
      t.string :lot_number
      t.date :expiry

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
