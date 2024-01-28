class AddUnacceptableFieldsToVisitReportDoctors < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_doctors, :unacceptable_fields, :text
    add_column :visit_report_doctors, :notification_via_notification_form, :boolean
    add_column :visit_report_doctors, :notification_via_e_notifikasi, :boolean

    remove_column :visit_report_doctors, :foreign_worker_present_comment
    remove_column :visit_report_doctors, :apc_comment
    remove_column :visit_report_doctors, :private_healthcare_registration_number_comment
    remove_column :visit_report_doctors, :written_consent_comment
    remove_column :visit_report_doctors, :medical_record_maintenance_comment
    remove_column :visit_report_doctors, :communicable_disease_comment
    remove_column :visit_report_doctors, :vacutainer_comment
    remove_column :visit_report_doctors, :adequate_facility_comment
    remove_column :visit_report_doctors, :dispatch_record_comment
    remove_column :visit_report_doctors, :operating_hour_comment
  end
end
