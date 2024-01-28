class MspdMonthlyReportingMailer < ApplicationMailer
    include ReportsPrivateMethods
    include ReportsMohMonthlyMedical

    # MSPD Monthly Medical Reports - Sends all these reports together.
    def mspd_moh_monthly
        temp_file   = Tempfile.new("temporary_mspd_moh.zip")
        @to_delete  = []

        begin
            Zip::OutputStream.open(temp_file) {|zos|}

            Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
                list_of_reports.each do |generated_report, filename|
                    data        = temporary_xlsx_file(generated_report)
                    xlsx_file   = File.new("tmp/#{ filename }.xlsx", 'w')
                    xlsx_file.write(data)
                    xlsx_file.close
                    zipfile.add("#{ filename }.xlsx", xlsx_file.path)
                    @to_delete << xlsx_file.path
                end
            end

            zip_data = File.read(temp_file.path)
        ensure
            # Close and delete the temp file
            temp_file.close
            temp_file.unlink
        end

        attachments["Monthly Stats - #{ Date.today.last_month.strftime("%Y%m") }.zip"] = zip_data

        @to_delete.each do |file_path|
            File.delete(file_path)
        end

        # Note, this does not use normal cron settings. Data manually added in.
        send_email_with_settings(report_name: "mspd_moh_monthly_report", subject: "MOH Monthly Reports")
    end
private
    def parse_output_format(filename)
        return @excel, filename
    end

    def temporary_xlsx_file(excel)
        @excel = excel
        render_to_string(handlers: [:axlsx], formats: [:xlsx], layout: false, template: "shared/reports/excel_caxlsx_template")
    end

    def send_email_with_settings(parameters = {})
        cron = ReportCronjob.find_by(report_name: parameters[:report_name])

        if cron.present?
            main_emails = cron.report_cronjob_emails.where(recipient_type: "main").pluck(:email)
            cc_emails   = cron.report_cronjob_emails.where(recipient_type: "cc").pluck(:email)
        else
            main_emails = []
            cc_emails   = []
        end

        mail to: main_emails, cc: cc_emails, subject: parameters[:subject]
        ReportCronjobMailSent.create(report_cronjob_id: cron.id, main_recipients: main_emails, cc_recipients: cc_emails) if cron.present?
    end

    def list_of_reports
        date        = Date.today.last_month.beginning_of_month.to_s
        state_list  = ["JOHOR", "KEDAH", "KELANTAN", "KUALA LUMPUR", "LABUAN", "MELAKA", "NEGERI SEMBILAN", "PAHANG", "PERAK", "PERLIS", "PULAU PINANG", "PUTRAJAYA", "SELANGOR", "TERENGGANU"]

        reports_2a      = state_list.map {|state| fomema2a_reports(query_month: date, selected_state: state) }
        reports_3a      = state_list.map {|state| fomema3a_reports(query_month: date, selected_state: state) }

        b_reports       = [
            fomema2b_reports(query_month: date),
            fomema3b_reports(query_month: date),
            fomema4b_reports(query_month: date),
            fomema2b_cumulative_reports(query_month: date),
            fomema3b_cumulative_reports(query_month: date),
            fomema4b_cumulative_reports(query_month: date)
        ]

        reports_2a + reports_3a + b_reports
    end

    # This was used to seed.
    # cron = ReportCronjob.find_or_create_by(report_name: "mspd_moh_monthly_report")
    # ["nurlyana@fomema.com.my", "fawzul@fomema.com.my", "drmdridzal@fomema.com.my", "DBAdmin@fomema.com.my"].each {|email| ReportCronjobEmail.find_or_create_by(report_cronjob_id: cron.id, email: email, recipient_type: "main") }
end