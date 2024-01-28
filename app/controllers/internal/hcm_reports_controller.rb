class Internal::HcmReportsController < InternalController
    include ReportsPrivateMethods
    include ReportsItHcm

    before_action -> { can_access?("HCM_REPORTS") }
    before_action :setting_extended_headers

    def index
        @hcm_reports = [
            { title: "Total Workers Registered By Branch",  path: total_workers_registered_by_branch_internal_hcm_reports_path },
            { title: "Number Of Errors",                    path: number_of_errors_internal_hcm_reports_path }
        ]

        @reports = [
            { title: "HCM Reports",     reports: @hcm_reports }
        ]

        render "shared/reports/index"
    end
private
    def parse_output_format(filename)
        respond_to do |format|
            format.html { @filename = filename; render "shared/reports/reports_preview_table"}
            format.csv { send_data CSV.generate {|csv| @csv.each {|row| csv << row}}, filename: "#{ filename }.csv" }
            format.xlsx { render template: 'shared/reports/excel_caxlsx_template', xlsx: "#{ filename }" }
        end
    end
end