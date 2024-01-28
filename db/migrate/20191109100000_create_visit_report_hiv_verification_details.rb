class CreateVisitReportHivVerificationDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_hiv_verification_details do |t|
      t.references :hiv_verification_detailable, polymorphic: true, index: { name: "index_vr_hivv_details_on_hivv_detailable" }
      
      t.boolean :referred_laboratory
      t.string :referred_laboratory_name
      t.string :referred_laboratory_send_record
      t.boolean :conducted

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
