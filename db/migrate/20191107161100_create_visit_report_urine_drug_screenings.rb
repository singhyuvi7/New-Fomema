class CreateVisitReportUrineDrugScreenings < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_urine_drug_screenings do |t|
      t.belongs_to :visit_report

      t.text :method_comment

      t.string :opiates_iqa
      t.text :opiates_iqa_detail_comment
      t.string :opiates_iqa_record
      t.string :opiates_iqa_perform_acknowledge
      t.string :opiates_iqa_validate_acknowledge

      t.string :opiates_eqa
      t.text :opiates_eqa_detail_comment

      t.string :opiates_test_worksheet
      t.text :opiates_test_worksheet_comment

      t.string :opiates_sop
      t.text :opiates_sop_comment

      t.string :opiates_iso
      t.text :opiates_iso_comment

      t.string :opiates_instrument_maintenance_record
      t.text :opiates_instrument_maintenance_record_comment

      t.decimal :opiates_duration_per_cycle
      t.decimal :opiates_sample_per_cycle

      t.string :opiates_troubleshoot
      t.text :opiates_troubleshoot_comment

      t.numeric :opiates_drug_detection_level
      
      t.string :cannabinoids_iqa
      t.text :cannabinoids_iqa_detail_comment
      t.string :cannabinoids_iqa_record
      t.string :cannabinoids_iqa_perform_acknowledge
      t.string :cannabinoids_iqa_validate_acknowledge

      t.string :cannabinoids_eqa
      t.text :cannabinoids_eqa_detail_comment

      t.string :cannabinoids_test_worksheet
      t.text :cannabinoids_test_worksheet_comment

      t.string :cannabinoids_sop
      t.text :cannabinoids_sop_comment

      t.string :cannabinoids_iso
      t.text :cannabinoids_iso_comment

      t.string :cannabinoids_instrument_maintenance_record
      t.text :cannabinoids_instrument_maintenance_record_comment

      t.decimal :cannabinoids_duration_per_cycle
      t.decimal :cannabinoids_sample_per_cycle

      t.string :cannabinoids_troubleshoot
      t.text :cannabinoids_troubleshoot_comment

      t.numeric :cannabinoids_drug_detection_level

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
