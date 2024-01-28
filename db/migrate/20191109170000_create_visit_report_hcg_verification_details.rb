class CreateVisitReportHcgVerificationDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_hcg_verification_details do |t|
      t.references :hcg_verification_detailable, polymorphic: true, index: { name: "index_vr_uhv_details_on_uhv_detailable" }
      
      t.boolean :referred_laboratory
      t.string :referred_laboratory_name
      t.string :referred_laboratory_send_record
      t.boolean :conducted
      t.text :comment

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
