class Internal::MedicalReportsController < InternalController
    include ReportsPrivateMethods
    include ReportsAppeal
    include ReportsMedicalMonthlyStat
    include ReportsMedical
    include ReportsMedicalWrongTransmissions

    before_action -> { can_access?("MEDICAL_REPORTS") }
    before_action :setting_extended_headers

    def index
        @appeals = [
            { title: "Medical Appeal",                      path: medical_appeal_internal_medical_reports_path },
            { title: "Type Of Diseases",                    path: type_of_diseases_internal_medical_reports_path },
            { title: "Cronjob - Daily Appeal",              path: cronjob_appeal_internal_medical_reports_path },
            { title: "Cronjob - Daily Reappeal",            path: cronjob_reappeal_internal_medical_reports_path },
            { title: "Cronjob - Daily Reject Appeal",       path: cronjob_reject_appeal_internal_medical_reports_path }
            # { title: "Appeal Weekly Report",                path: appeal_weekly_report_internal_medical_reports_path } # This is shown in appeals index page.
        ]

        @monthly_stats = [
            { title: "Med Monthly Stat - Appeal",           path: med_monthly_stat_appeal_internal_medical_reports_path },
            { title: "Med Monthly Stat - PR",               path: med_monthly_stat_pr_internal_medical_reports_path },
            { title: "Med Monthly Stat - TCUPI",            path: med_monthly_stat_tcupi_internal_medical_reports_path },
            { title: "Med Monthly Stat - Reuse Passport",   path: med_monthly_stat_reuse_passport_internal_medical_reports_path },
            { title: "Med Monthly Stat - Unfit Reason",     path: med_monthly_stat_unfit_reason_internal_medical_reports_path }
        ]

        @medicals = [
            { title: "Cronjob - Weekly MOH Notification Report (Email)",            path: cronjob_moh_weekly_email_report_internal_medical_reports_path },
            { title: "Cronjob - Weekly MOH Notification Report by State (System)",  path: cronjob_moh_weekly_system_report_by_state_internal_medical_reports_path },
            { title: "Email Of Repatriation Notice To Employer",                    path: email_of_repatriation_notice_internal_medical_reports_path },
            { title: "Report On Unfit Notification To Employer",                    path: report_unfit_notice_internal_medical_reports_path },
            { title: "Report On Review QA",                                            path: report_review_qa_internal_medical_reports_path }
        ]

        @wrong_transmissions = [
            { title: "Wrong Transmission For GP",   path: wrong_transmission_doctor_internal_medical_reports_path },
            { title: "Wrong Transmission For Lab",  path: wrong_transmission_lab_internal_medical_reports_path },
            { title: "Wrong Transmission For Xray", path: wrong_transmission_xray_internal_medical_reports_path }
        ]

        @reports = [
            { title: "Appeal Reports",              reports: @appeals },
            { title: "Monthly Stats Reports",       reports: @monthly_stats },
            { title: "Medical Reports",             reports: @medicals },
            { title: "Wrong Transmission Reports",  reports: @wrong_transmissions }
        ]

        render "shared/reports/index"
    end
private
    def parse_output_format(filename)
        respond_to do |format|
            format.html { @filename = filename; render "shared/reports/reports_preview_table" }
            format.csv { send_data CSV.generate {|csv| @csv.each {|row| csv << row}}, filename: "#{ filename }.csv" }
            format.xlsx { render template: 'shared/reports/excel_caxlsx_template', xlsx: "#{ filename }" }
        end
    end
end