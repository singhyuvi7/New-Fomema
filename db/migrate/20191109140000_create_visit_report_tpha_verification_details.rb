class CreateVisitReportTphaVerificationDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_tpha_verification_details do |t|
      t.references :tpha_verification_detailable, polymorphic: true, index: { name: "index_vr_tv_details_on_tv_detailable" }
      
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
