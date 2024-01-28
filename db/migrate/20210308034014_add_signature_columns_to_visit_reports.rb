class AddSignatureColumnsToVisitReports < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_xray_facilities, :fomema_officer_signature, :text
    add_column :visit_report_xray_facilities, :fomema_officer_name, :string
    add_column :visit_report_xray_facilities, :personnel_signature, :text
    add_column :visit_report_xray_facilities, :personnel_name, :string
    add_column :visit_report_xray_facilities, :personnel_designation, :string

    add_column :visit_report_doctors, :fomema_officer_signature, :text
    add_column :visit_report_doctors, :fomema_officer_name, :string
    add_column :visit_report_doctors, :personnel_signature, :text
    add_column :visit_report_doctors, :personnel_name, :string
    add_column :visit_report_doctors, :personnel_designation, :string
  end
end
