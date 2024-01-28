class Internal::XqccReportsController < InternalController
    include ReportsPrivateMethods
    include ReportsXQCC
    include ReportsXqccRadiographers
    include ReportsXqccMisc
    include ReportsXqccNonCompliance

    before_action -> { can_access?('XQCC_REPORTS') }
    before_action -> { can_access?("XQCC_PENDING_RADIOGRAPHER_REPORT") }, only: [:xqcc_pending_radiographer_report]
    before_action -> { can_access?("XQCC_MONTHLY_XRAY_RECEIVED_AND_VIEWED") }, only: [:xqcc_monthly_xray_received_and_viewed]
    before_action -> { can_access?("XQCC_MONTHLY_NON_COMPLIANCE_REPORT") }, only: [:xqcc_monthly_non_compliance_report]
    before_action -> { can_access?("XQCC_DX_FILM_CONFIRMED_AS_ABNORMAL") }, only: [:xqcc_dx_film_confirmed_as_abnormal]
    before_action -> { can_access?('XQCC_DX_AUDIT_STATISTICS') }, only: [:xqcc_dx_audit_statistics]
    before_action -> { can_access?("XQCC_DX_TAT_REVIEW_REPORT") }, only: [:xqcc_digital_xray_tat_review]
    before_action -> { can_access?("XQCC_PENDING_AUDIT_PCR_REPORT") }, only: [:xqcc_pending_audit_pcr_report]
    before_action -> { can_access?('XQCC_DAILY_SUMMARY_PENDING_REVIEW_REPORT') }, only: [:xqcc_daily_summary_pending_review]
    before_action -> { can_access?('PCR_AUDIT_SUMMARY_REPORTS') }, only: [:pcr_audit_summary_report]
    before_action :setting_extended_headers

    def index
        xqcc_reports = [
            { title: 'Radiographer Daily Summary Report',   path: radiographer_daily_summary_internal_xqcc_reports_path },
            { title: 'XQCC Quality Summary',                path: xqcc_quality_summary_internal_xqcc_reports_path },
            { title: 'XQCC Daily Total Xray Received (By Received Date)',           path: xqcc_daily_total_xray_received_internal_xqcc_reports_path },
            { title: 'XQCC Daily Total Xray Received (By Certification Date)',      path: xqcc_daily_total_xray_received_by_certification_internal_xqcc_reports_path },
            { title: 'XQCC Digital X-ray - Certified',      path: xqcc_digital_xray_certified_internal_xqcc_reports_path },
            { title: 'XQCC Daily Dispatch List',            path: xqcc_daily_dispatch_list_internal_xqcc_reports_path },
            { title: 'XQCC Daily Film Review',              path: xqcc_daily_film_review_internal_xqcc_reports_path },
            { title: 'XQCC Pending Radiographer Report',    path: xqcc_pending_radiographer_report_internal_xqcc_reports_path },
            { title: 'XQCC Daily Non Compliance Report',    path: daily_non_compliance_report_internal_xqcc_reports_path },
            { title: 'XQCC Monthly Xray Received and Viewed', path: xqcc_monthly_xray_received_and_viewed_internal_xqcc_reports_path },
            { title: 'Radiographer Pending Review Report',  path: radiographer_pending_review_report_internal_xqcc_reports_path },
            { title: 'XQCC Monthly Non-Compliance Report',  path: xqcc_monthly_non_compliance_report_internal_xqcc_reports_path },
            { title: 'XQCC DX Film Confirmed As Abnormal',  path: xqcc_dx_film_confirmed_as_abnormal_internal_xqcc_reports_path },
            { title: 'XQCC DX Pending Audit (PCR)',         path: xqcc_dx_pending_audit_pcr_internal_xqcc_reports_path},
            { title: 'XQCC DX Audit Statistics',            path: xqcc_dx_audit_statistics_internal_xqcc_reports_path },
            { title: 'XQCC Digital X-ray TAT Review (Send to JIM)',    path: xqcc_digital_xray_tat_review_internal_xqcc_reports_path },
            { title: "XQCC Daily Boxes Store",              path: xqcc_daily_boxes_store_internal_xqcc_reports_path },
            { title: 'XQCC Daily Film Store',               path: xqcc_daily_film_store_internal_xqcc_reports_path },
            { title: 'XQCC Summary Pending Review Report',  path: xqcc_summary_pending_review_internal_xqcc_reports_path },
            { title: 'XQCC Misread Report',                 path: xqcc_misread_internal_xqcc_reports_path },
            { title: 'XQCC Detail Misread Report',          path: xqcc_detail_misread_internal_xqcc_reports_path },
            { title: 'PCR Audit Summary Report',            path: pcr_audit_summary_report_internal_xqcc_reports_path }
        ]

        xqcc_radiographer_reports = [
            { title: "Monthly Radiographer Summary",        path: radiographer_monthly_summary_report_internal_xqcc_reports_path },
            { title: "Weekly Radiographer Receive, Review & Auto Release",
                path: weekly_radiographer_receive_review_auto_release_internal_xqcc_reports_path }
        ]

        misc_reports = [
            { title: "Pending Result Release (Pending Decision)",   path: xqcc_result_release_pending_decision_internal_xqcc_reports_path },
            { title: "Pending Result Release (Amend Cases)",        path: xqcc_result_release_amend_cases_internal_xqcc_reports_path },
            { title: "Amended Unsuitable by XQCC",                  path: xqcc_amend_unsuitable_report_internal_xqcc_reports_path },
            { title: "Monthly XQCC Programme Report",               path: monthly_xqcc_programme_report_internal_xqcc_reports_path }
        ]

        @reports = [
            { title: 'XQCC Reports',                        reports: xqcc_reports },
            { title: 'Misc XQCC Reports',                   reports: misc_reports },
            { title: 'XQCC Radiographer Reports',           reports: xqcc_radiographer_reports }
        ]

        render 'shared/reports/index'
    end
private
    def parse_output_format(filename)
        respond_to do |format|
            format.html { @filename = filename; render "shared/reports/reports_preview_table" }
            format.csv { send_data CSV.generate {|csv| @csv.each {|row| csv << row}}, filename: "#{ filename }.csv" }
            format.xlsx { render template: 'shared/reports/excel_caxlsx_template', xlsx: "#{ filename }" }
        end
    end

    def pdf_margin
        {
            top: 50,
            left: 12,
            right: 12,
            bottom: 10
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
end
