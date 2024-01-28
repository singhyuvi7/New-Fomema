class CreateVisitReportMalariaBfmps < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_malaria_bfmps do |t|
      t.belongs_to :visit_report

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

      t.decimal :duration_per_slide

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
