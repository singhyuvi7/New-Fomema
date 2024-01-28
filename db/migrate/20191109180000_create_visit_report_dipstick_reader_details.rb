class CreateVisitReportDipstickReaderDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_dipstick_reader_details do |t|
      t.references :dipstick_reader_detailable, polymorphic: true, index: { name: "index_vr_dipstick_reader_details_on_dipstick_reader_detailable" }
      
      t.string :code
      t.text :comment

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
