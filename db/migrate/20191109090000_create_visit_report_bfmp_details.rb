class CreateVisitReportBfmpDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_bfmp_details do |t|
      t.references :bfmp_detailable, polymorphic: true, index: { name: "index_vr_bfmp_details_on_bfmp_detailable" }
      
      t.string :name
      t.string :laboratory_name
      t.string :referred_laboratory_send_record

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
