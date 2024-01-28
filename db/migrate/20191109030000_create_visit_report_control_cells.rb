class CreateVisitReportControlCells < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_control_cells do |t|
      t.belongs_to :control_cellable, polymorphic: true, index: { name: "index_vr_control_cells_on_reagent_conditionable_id" }

      t.string :urine_drug_category # VisitReport::URINE_DRUG_CATEGORIES OPIATES/CANNABINOIDS
      t.belongs_to :control_cell
      t.string :rhesus
      t.belongs_to :reagent
      t.text :comment

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
