class CreateVisitReportControlCellConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_control_cell_conditions do |t|
      t.belongs_to :control_cell_conditionable, polymorphic: true, index: { name: "index_vr_control_cell_conditions_on_control_cell_conditionable" }

      t.string :urine_drug_category # VisitReport::URINE_DRUG_CATEGORIES OPIATES/CANNABINOIDS
      t.belongs_to :control_cell
      t.string :rhesus
      t.string :control_name
      t.string :lot_number
      t.date :expiry

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
