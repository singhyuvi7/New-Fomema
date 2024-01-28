class AddUnacceptableFieldsToVisitReportXrayFacilities < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_xray_facilities, :unacceptable_fields, :text

    remove_column :visit_report_xray_facilities, :foreign_worker_present_comment
    remove_column :visit_report_xray_facilities, :apc_comment
    remove_column :visit_report_xray_facilities, :private_healthcare_registration_number_comment
    remove_column :visit_report_xray_facilities, :license_comment
    remove_column :visit_report_xray_facilities, :medical_record_maintenance_comment
    remove_column :visit_report_xray_facilities, :adequate_facility_comment
    remove_column :visit_report_xray_facilities, :dispatch_record_comment
    remove_column :visit_report_xray_facilities, :operating_hour_comment
  end
end
