class Internal::OperationReportsController < InternalController
    include ReportsPrivateMethods
    include ReportsOperation
    include ReportsOperationCronjob
    include StatistikSaringanKesihatan
    include ReportsBranchMonthlyCertifications

    before_action -> { can_access?("OPERATION_REPORTS") }
    before_action :setting_extended_headers

    def index
        ## phase 2
        phase2_operation = [
            { title: "Monthly Registration by Job Type",                path: monthly_registration_by_job_type_internal_operation_reports_path },
            { title: "Monthly Registration by Branch",                  path: monthly_registration_by_branch_internal_operation_reports_path },
            { title: "Foreign Worker Health Screening Statistics",      path: health_screening_statistics_internal_operation_reports_path },
        ]
        ## end

        @stats_and_certs = [
            { title: "Statistik Mengikut Sektor",                       path: statistik_mengikut_sektor_internal_operation_reports_path },
            { title: "Statistik Mengikut Negeri",                       path: statistik_mengikut_negeri_internal_operation_reports_path },
            { title: "Statistik Mengikut Negara Sumber",                path: statistik_mengikut_negara_sumber_internal_operation_reports_path },
            { title: "Statistik Mengikut Tahun",                        path: statistik_mengikut_tahun_internal_operation_reports_path },
            { title: "Statistik Mengikut Sebab",                        path: statistik_mengikut_sebab_internal_operation_reports_path },
            { title: "Monthly Reports by Statuses",                     path: branch_monthly_status_internal_operation_reports_path },
            { title: "Monthly Reports by Diseases",                     path: branch_monthly_diseases_internal_operation_reports_path },
            { title: "Monthly Reports by Country Status",               path: branch_monthly_country_status_internal_operation_reports_path },
            { title: "Pati Certification Monthly Reports by Diseases",  path: pati_certification_monthly_diseases_internal_operation_reports_path }
        ]

        @operation = [
            { title: "Daily Branch Registration",                       path: daily_branch_registration_internal_operation_reports_path },
            { title: "Daily & Monthly Registration Report with YTD",    path: daily_monthly_registration_with_ytd_internal_operation_reports_path },
            { title: "Regpatiday",                                      path: regpatiday_internal_operation_reports_path },
            { title: "Daily & Monthly Worker Insurance Report" ,        path: daily_monthly_worker_insurance_internal_operation_reports_path},
            { title: "Details Worker Insurance Report",                 path: details_worker_insurance_internal_operation_reports_path}
        ]
        @cronjob = [
            { title: 'Daily Branch Registration Cronjob',               path: daily_branch_registration_cronjob_internal_operation_reports_path },
            { title: 'Daily Branch Registration Interim Cronjob',       path: daily_branch_registration_interim_cronjob_internal_operation_reports_path },
            { title: 'Daily & Monthly Registration Report with YTD',    path: daily_monthly_registration_with_ytd_cronjob_internal_operation_reports_path }
        ]

        @reports = [
            { title: "Statistic & Certification", reports: @stats_and_certs },
            { title: "Operation Reports",         reports: @operation },
            { title: 'Cronjob Reports',           reports: @cronjob }
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

    def set_date_time
        @date = DateTime.current.strftime('%d/%m/%Y')
        @time = DateTime.current.strftime('%H:%M:%S %p')
    end

    def pdf_margin
        {
            top: 50,
            left: 12,
            right: 12,
            bottom: 10,
        }
    end

    def default_pdf_options
        {
             layout: 'pdf.html',
             margin: pdf_margin,
             page_size: nil,
             page_height: '21cm',
             page_width: '29.7cm',
             dpi: '300'
        }
     end

    def check_format_html # need to keep this here for the mailers
        begin
            # Can't run presence check on request. So only way is to rescue a request from email.
            response = request&.format == "html"
        rescue
            response = false
        end

        response
    end
end