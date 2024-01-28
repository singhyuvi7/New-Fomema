class Internal::MspdReportsController < InternalController
    include ReportsPrivateMethods
    include ReportsMSPD
    include ReportsMohMonthlyMedical
    include ReportsMedicalWrongTransmissions
    include ReportsDiffBloodgroup

    before_action -> { can_access?("MSPD_REPORTS") }
    before_action :set_company_name
    before_action :setting_extended_headers

    def index
        ## phase2
        phase2_mspd = [
            { title: "GP Unutilized Quota",                 path: gp_unutilized_quota_internal_mspd_reports_path },
        ]

        @statistician = [
            { title: "Weekly  Radiographer Receive, Review and Auto Release", path: radiographer_report_internal_mspd_reports_path },
            { title: "List of GP (active + Temp.Suspended)", path: internal_doctors_path },
            { title: "List of Lab (active + Temp.Suspended)", path: internal_laboratories_path },
            { title: "List of Xray (active + Temp.Suspended)", path: internal_xray_facilities_path }
        ]
        ## end

        @mspd = [
            { title: "New Registration Doctor",             path: list_doc_register_internal_mspd_reports_path },
            { title: "New Registration X-Ray Facility",     path: list_xray_register_internal_mspd_reports_path },
            { title: "New Registration Laboratory",         path: list_lab_register_internal_mspd_reports_path },
            { title: "Foreign Worker Registrations",        path: foreign_worker_registrations_internal_mspd_reports_path },
            { title: "Suspended Doctors",                   path: suspended_doctors_internal_mspd_reports_path },
            { title: "Unsuitable Foreign Worker",           path: unsuitable_foreign_workers_internal_mspd_reports_path },
            { title: "Laboratory Delay Transmission",       path: lab_delay_transmission_internal_mspd_reports_path },
            { title: "Xray Delay Transmission",             path: xray_delay_transmission_internal_mspd_reports_path },
            { title: "List of Worker (details) by doctor",  path: list_of_workers_by_doctor_internal_mspd_reports_path },
            { title: "List of allocated workers to doctor", path: internal_doctors_path },
            { title: "Xray Allocation to Radiologist",      path: xray_allocation_to_radiologist_internal_mspd_reports_path },
            { title: "List of Xray",                        path: list_of_xray_internal_mspd_reports_path },
            { title: "List of Laboratories",                path: list_of_laboratories_internal_mspd_reports_path },
            { title: "List of GP",                          path: list_of_gp_internal_mspd_reports_path },
            { title: "Clinic Allocation to Xray Facility and Lab",   path: clinic_allocation_to_xray_and_lab_internal_mspd_reports_path },
            { title: "MCLX Report",                         path: mclx_report_internal_mspd_reports_path },
            { title: "Full Quota",                          path: full_quota_internal_mspd_reports_path },
            { title: "New DXLR",                            path: new_dxlr_internal_mspd_reports_path },
            { title: "Active DXLR",                         path: active_dxlr_internal_mspd_reports_path },
            { title: "Non Transmission For GP",             path: non_transmission_doctor_internal_mspd_reports_path },
            { title: "Worker Block Send To JIM",            path: worker_block_send_to_jim_internal_mspd_reports_path },
            { title: "Quota Summary",                       path: quota_summary_internal_mspd_reports_path },
            { title: "Daily Balance Quota",                 path: daily_balance_quota_internal_mspd_reports_path },
        ]

        @proddbmon = [
            { title: "Doctor",                 path: doctor_information_internal_mspd_reports_path },
            { title: "Laboratory",             path: lab_allocation_internal_mspd_reports_path }
        ]
        @suspension = [
            { title: "MSPD Suspension",        path: mspd_suspension_internal_mspd_reports_path },
            { title: "Doctor",                 path: internal_doctors_path },
            { title: "Laboratory",             path: internal_laboratories_path },
            { title: "X-ray Facility",         path: internal_xray_facilities_path }
        ]

        @delay = [
            { title: "Doctor",                 path: doctor_delay_transactions_internal_mspd_reports_path },
            { title: "Laboratory",             path: laboratory_delay_transactions_internal_mspd_reports_path },
            { title: "X-ray Facility",         path: xray_delay_transactions_internal_mspd_reports_path }
        ]

        @moh_medical_monthly_reports = [
            { title: "FOMEMA 2A Reports",               path: fomema2a_reports_internal_mspd_reports_path },
            { title: "FOMEMA 2B Reports",               path: fomema2b_reports_internal_mspd_reports_path },
            { title: "FOMEMA 3A Reports",               path: fomema3a_reports_internal_mspd_reports_path },
            { title: "FOMEMA 3B Reports",               path: fomema3b_reports_internal_mspd_reports_path },
            { title: "FOMEMA 4B Reports",               path: fomema4b_reports_internal_mspd_reports_path },
            { title: "FOMEMA 2B Cumulative Reports",    path: fomema2b_cumulative_reports_internal_mspd_reports_path },
            { title: "FOMEMA 3B Cumulative Reports",    path: fomema3b_cumulative_reports_internal_mspd_reports_path },
            { title: "FOMEMA 4B Cumulative Reports",    path: fomema4b_cumulative_reports_internal_mspd_reports_path }
        ]

        @wrong_transmissions = [
            { title: "Wrong Transmission For GP",   path: wrong_transmission_doctor_internal_mspd_reports_path },
            { title: "Wrong Transmission For Lab",  path: wrong_transmission_lab_internal_mspd_reports_path },
            { title: "Wrong Transmission For Xray", path: wrong_transmission_xray_internal_mspd_reports_path },
        ]

        @diff_bloodgroup = [
            { title: "Different Blood Group by Doctor", path: different_blood_group_by_doctor_internal_mspd_reports_path },
            { title: "Different Blood Group by Lab",    path: different_blood_group_by_lab_internal_mspd_reports_path }
        ]

        @reports = [
            { title: "MSPD Reports",                    reports: @mspd },
            { title: "Suspension History",              reports: @suspension},
            { title: "Delay Transactions",              reports: @delay },
            { title: "Report generated from proddbmon", reports: @proddbmon},
            { title: "MOH Medical Monthly Reports",     reports: @moh_medical_monthly_reports },
            { title: "Wrong Transmission Reports",      reports: @wrong_transmissions },
            { title: "Different Bloodgroup Reports",    reports: @diff_bloodgroup },
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

    def set_company_name
        @company_name = SystemConfiguration.find_by(code: 'COMPANY_NAME')&.value.try(:upcase)
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