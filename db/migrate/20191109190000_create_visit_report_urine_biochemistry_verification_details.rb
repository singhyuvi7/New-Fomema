class CreateVisitReportUrineBiochemistryVerificationDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_urine_biochemistry_verification_details do |t|
      short = "vr_ubv_details"
      t.references :urine_biochemistry_verification_detailable, polymorphic: true, index: { name: "index_#{short}_on_ubv_detailable" }
      
      t.boolean :referred_laboratory
      t.string :referred_laboratory_name
      t.string :referred_laboratory_send_record
      t.boolean :conducted
      t.text :comment

      t.timestamps
      t.bigint :created_by, index: { name: "index_#{short}_on_created_by" }
      t.bigint :updated_by, index: { name: "index_#{short}_on_updated_by" }
    end
  end
end
