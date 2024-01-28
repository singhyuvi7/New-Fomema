class CreateVisitReportXrayFacilities < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_xray_facilities do |t|
      t.belongs_to :visit_report
      t.belongs_to :xray_facility

      t.string :license_holder_name
      
      # remark
      t.string :type_of_visit
      t.string :interacted_with
      t.string :radiographer_name
      t.string :number_of_visit_checklist

      t.integer :foreign_worker_present
      t.string :foreign_worker_present_acceptable
      t.text :foreign_worker_present_comment

      t.string :apc_number
      t.integer :apc_year
      t.string :apc_acceptable
      t.text :apc_comment

      t.string :private_healthcare_registration_number
      t.string :private_healthcare_registration_number_acceptable
      t.text :private_healthcare_registration_number_comment

      t.string :license_serial_number
      t.date :license_expiry_date
      t.string :license_storing_acceptable
      t.string :license_using_acceptable
      t.text :license_comment

      t.string :xray_license_menstor_acceptable
      t.string :xray_license_mengguna_acceptable

      t.string :medical_record_maintenance_acceptable
      t.text :medical_record_maintenance_comment
      
      t.string :adequate_facility_acceptable
      t.text :adequate_facility_comment

      t.string :dispatch_record_acceptable
      t.text :dispatch_record_comment

      t.string :operating_hour_acceptable
      t.text :operating_hour_comment

      t.boolean :satisfactory
      t.boolean :non_verify_original_passport_fw_present
      t.boolean :non_verify_original_passport_fw_not_present
      t.boolean :unable_to_produce_apc
      t.boolean :no_xray_license_for_mengguna
      t.boolean :inadequate_equipment
      t.boolean :insufficient_operation_hour
      t.boolean :expired_license_menstor_mengguna
      t.boolean :no_produce_medical_record
      t.boolean :closed
      t.boolean :no_produce_borang_b
      t.boolean :other
      t.text :other_comment

      t.string :recommendation

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
