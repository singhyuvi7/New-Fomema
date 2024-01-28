class Internal::ItReportsController < InternalController
    include ReportsPrivateMethods
    include ReportsIT
    include ReportsMedical

    before_action -> { can_access?("IT_REPORTS") }
    before_action :setting_extended_headers, only: [:it_send_mail_for_unsuitable]

    def index
        ## phase 2
        @insurances = [
            { title: "Insurances",                  path: insurances_internal_it_reports_path }
        ]
        ## end

        @biodata = [
            { title: "Daily Get Biodata",           path: daily_getbiodata_report_internal_it_reports_path },
            { title: "Daily AFIS ID",               path: daily_afisid_report_internal_it_reports_path },
            { title: "Daily Biometric",             path: daily_biometric_report_internal_it_reports_path },
            { title: "Daily Thumbprint Tested",     path: daily_thumbprint_tested_internal_it_reports_path },
            { title: "Daily MYIMMS Error Report",   path: daily_myimms_error_report_internal_it_reports_path }
        ]

        @medical = [
            { title: "Send Mail For Unsuitable",    path: it_send_mail_for_unsuitable_internal_it_reports_path }
        ]

        @reports = [
            { title: "Biodata Reports",         reports: @biodata },
            { title: "MSPD",                    reports: @medical }
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