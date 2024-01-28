class CreateVisitReportUrineBiochemistryVerifications < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_urine_biochemistry_verifications do |t|
      short = "vr_urine_biochemistry_verifications"
      t.belongs_to :visit_report, index: { name: "index_#{short}_on_visit_report_id" }

      t.text :method_comment

      t.string :iqa
      t.text :iqa_detail_comment
      t.string :iqa_record
      t.string :iqa_perform_acknowledge
      t.string :iqa_validate_acknowledge

      t.string :eqa
      t.text :eqa_detail_comment

      t.string :test_worksheet
      t.text :test_worksheet_comment

      t.string :sop
      t.text :sop_comment

      t.string :iso
      t.text :iso_comment

      t.string :instrument_maintenance_record
      t.text :instrument_maintenance_record_comment

      t.decimal :duration_per_cycle
      t.decimal :sample_per_cycle

      t.string :troubleshoot
      t.text :troubleshoot_comment

      t.timestamps
      t.bigint :created_by, index: { name: "index_#{short}_on_created_by" }
      t.bigint :updated_by, index: { name: "index_#{short}_on_updated_by" }
    end
  end
end
