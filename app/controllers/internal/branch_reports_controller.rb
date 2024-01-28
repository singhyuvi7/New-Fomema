class Internal::BranchReportsController < InternalController
    include ReportsPrivateMethods
    include ReportsBranchRegistration
    include ReportsBranchPatiMonthly
    include ReportsBranchMisc
    include ReportsBranchInsurance

    before_action -> { can_access?("BRANCH_REPORTS") }
    before_action :setting_extended_headers

    def index
        @registrations = [
            { title: "Registration by Job Sector",              path: registration_by_job_sector_internal_branch_reports_path },
            { title: "Registration Breakdown",                  path: registration_breakdown_internal_branch_reports_path },
            { title: "New vs Renewal Breakdown",                path: new_vs_renewal_internal_branch_reports_path },
            { title: "Monthly Registration by Branch",          path: monthly_registration_by_branch_internal_branch_reports_path },
            { title: "Monthly Registration by Job Type",        path: monthly_registration_by_job_type_internal_branch_reports_path },
            { title: "Statistic Male VS Female",                path: statistic_male_female_internal_branch_reports_path },
            { title: "Amendment of Critical Information Due to Input Error",   path: input_error_critical_amendment_internal_branch_reports_path },
        ]

        @pati_monthly = [
            { title: "Pati Registration Statistics",            path: pati_registration_statistics_internal_branch_reports_path },
            { title: "Pati Registrations by Country by Months", path: pati_registration_monthly_country_by_month_internal_branch_reports_path },
            { title: "Pati Registrations by Branch by Months",  path: pati_registration_monthly_branch_by_month_internal_branch_reports_path }
        ]

        @misc_reports = [
            { title: "Employer Registration By State",          path: employer_registration_by_state_internal_branch_reports_path },
            { title: "Total Change Of Clinic",                  path: total_change_clinic_internal_branch_reports_path },
            { title: "Total Amendment Cases",                   path: total_amendment_cases_internal_branch_reports_path },
            { title: "Total Daily Collection",                  path: branch_collection_internal_branch_reports_path },
        ]

        @insurance_reports = [
            { title: "Details Worker Insurance Report",         path: details_worker_insurance_internal_branch_reports_path },
        ]

        @reports = [
            { title: "Registration Reports",                    reports: @registrations },
            { title: "Pati Registrations Reports",              reports: @pati_monthly },
            { title: "Misc Reports",                            reports: @misc_reports },
            { title: "Insurance Reports",                       reports: @insurance_reports },
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