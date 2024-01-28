class CreateVisitReportLabDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :visit_report_lab_details do |t|
      
      t.belongs_to :visit_report_laboratory
      t.string :report_category

      t.string :iso_status
      t.text :iso_status_comment

      t.string :same_as_screening

      t.text :dipstick_reader, array: true, default: []

      t.decimal :drug_level_opiates
      t.decimal :drug_level_cannabinoids
      t.decimal :hcg_level

      t.text :method, array: true, default: []
      t.text :method_comment

      t.text :instrumentation, array: true, default: []

      t.text :reagent_name, array: true, default: []
      t.string :reagent_condition
      t.date :reagent_condition_expiry_date

      t.text :control_cell_name, array: true, default: []
      t.string :control_cell_condition
      t.date :control_cell_condition_expiry_date

      t.string :iqa
      t.text :iqa_comment

      t.string :eqa
      t.text :eqa_comment

      t.string :test_worksheet
      t.text :test_worksheet_comment

      t.string :tpm
      t.text :tpm_comment

      t.string :instrument_maintenance_record
      t.text :instrument_maintenance_record_comment

      t.string :test_compliance

      t.string :in_house
      t.text :in_house_comment

      t.string :traceability
      t.text :traceability_comment

      t.decimal :urine_sugar_level
      t.string :urine_sugar_qualitative
      t.decimal :urine_albumin_level
      t.string :urine_albumin_qualitative

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
