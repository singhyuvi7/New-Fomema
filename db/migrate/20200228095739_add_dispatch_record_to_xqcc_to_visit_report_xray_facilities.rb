class AddDispatchRecordToXqccToVisitReportXrayFacilities < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_report_xray_facilities, :dispatch_record_to_xqcc, :boolean
  end
end
