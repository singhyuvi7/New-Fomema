class Internal::FinanceReportsController < InternalController
    include ReportsFinance

    before_action -> { can_access?("FINANCE_REPORTS") }

    def index
        @finance = [
            { title: "Summary Draft Collection",                        path: summary_draft_collection_internal_finance_reports_path },
            { title: "Summary Worker Registration",                     path: summary_worker_registration_internal_finance_reports_path },
            { title: "Summary Worker Certification",                    path: summary_worker_certification_internal_finance_reports_path },
            { title: "Summary Transaction Expired Without Examination", path: summary_transaction_expired_without_examination_internal_finance_reports_path },
            { title: "Summary Transaction Expired With Examination",    path: summary_transaction_transmission_expired_internal_finance_reports_path },
            { title: "SP Payment Mode Statistic",                       path: sp_payment_mode_statistic_internal_finance_reports_path },
            { title: "Payment Listing",                                 path: internal_payment_listing_view_payment_listing_path },
            { title: "Manual Payment Listing",                          path: internal_manual_payment_view_transactions_path },
            { title: "Summary Misc Income",                             path: summary_misc_income_internal_finance_reports_path },
            { title: "Portal Transactions",                             path: portal_transactions_internal_finance_reports_path },
            { title: "Employer Account",                                path: employer_account_internal_finance_reports_path },
        ]

        @certification = [
            { title: "Doctor Summary",        path: summary_doctor_certification_internal_finance_reports_path },
            { title: "Doctor Details",        path: doctor_certification_details_internal_finance_reports_path },
            { title: "Xray Summary",          path: summary_xray_certification_internal_finance_reports_path },
            { title: "Xray Details",          path: xray_certification_details_internal_finance_reports_path },
            { title: "Xray Not Done",         path: xray_not_done_certifications_internal_finance_reports_path },
            { title: "Laboratory Summary",    path: summary_laboratory_certification_internal_finance_reports_path },
            { title: "Laboratory Details",    path: laboratory_certification_details_internal_finance_reports_path },
            { title: "Laboratory By Gender",  path: laboratory_certification_by_gender_internal_finance_reports_path },
            { title: "Laboratory Not Done",   path: laboratory_not_done_certification_internal_finance_reports_path }
        ]

        ## finance decided not to have this report
            #{ title: "Summary Worker Insurance",            path: summary_worker_insurance_internal_finance_reports_path } 
        ## decide end
        @insurance = [
            { title: "Details Worker Insurance Report",     path: details_worker_insurance_internal_finance_reports_path }
        ]

        @cronjob = [
            { title: "Refund Payment Failed Reminder",      path: daily_refund_payment_failed_reminder_internal_finance_reports_path },            
        ]
        @reports = [
            { title: "Finance Reports",         reports: @finance },
            { title: "Certification Reports",   reports: @certification },
            { title: "Insurance Reports",       reports: @insurance },
            { title: "Cronjob Reports",       reports: @cronjob },
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
             page_height: '29.7cm',
             page_width: '21cm',
             dpi: '300'
        }
     end
end