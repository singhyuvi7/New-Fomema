class MedicalReportsMailer < ApplicationMailer
    include ReportsPrivateMethods
    include ReportsMedical
    include ReportsAppeal
    include ReportsMedicalMonthlyStat

    # IT Report For Unsuitable Letters Sent
        def medical_mail_report_for_unsuitable
            @csv = it_send_mail_for_unsuitable
            # The report name corresponds to the action_name when in a controller.
            send_email_with_settings(report_name: "it_send_mail_for_unsuitable", subject: "Unsuitable Letters Sent")
        end

    # Weekly Moh Notification
        def medical_reports_weekly_cronjob_moh_weekly_email_report
            attachments["Weekly MOH Disease Released.xlsx"] = attach_xlsx_file(cronjob_moh_weekly_email_report)
            send_email_with_settings(report_name: "cronjob_moh_weekly_email_report", subject: "Weekly MOH Notification Report")
        end

    # Monthly Appeal Reporting
        def medical_reports_monthly_medical_appeal
            attachments["Medical Appeal.csv"] = attach_csv_file(medical_appeal)
            send_email_with_settings(report_name: "medical_appeal", subject: "Monthly reporting - Medical Appeal")
        end

        def medical_reports_monthly_type_of_diseases
            attachments["Types of Diseases.xlsx"] = attach_xlsx_file(type_of_diseases)
            send_email_with_settings(report_name: "type_of_diseases", subject: "Monthly Reporting - Type of Diseases")
        end

    # Medical Monthly Stat
        def medical_reports_med_monthly_stat_appeal
            attachments["med_monthly_stat_appeal.xlsx"] = attach_xlsx_file(med_monthly_stat_appeal)
            send_email_with_settings(report_name: "med_monthly_stat_appeal", subject: "Medical Monthly Statistics - Appeal")
        end

        def medical_reports_med_monthly_stat_pr
            attachments["med_monthly_stat_pr.xlsx"] = attach_xlsx_file(med_monthly_stat_pr)
            send_email_with_settings(report_name: "med_monthly_stat_pr", subject: "Medical Monthly Statistics - PR")
        end

        def medical_reports_med_monthly_stat_tcupi
            attachments["med_monthly_stat_tcupi.xlsx"] = attach_xlsx_file(med_monthly_stat_tcupi)
            send_email_with_settings(report_name: "med_monthly_stat_tcupi", subject: "Medical Monthly Statistics - TCUPI")
        end

        def medical_reports_med_monthly_stat_reuse_passport
            attachments["med_monthly_stat_reuse_passport.xlsx"] = attach_xlsx_file(med_monthly_stat_reuse_passport)
            send_email_with_settings(report_name: "med_monthly_stat_reuse_passport", subject: "Medical Monthly Statistics - Reuse Passport")
        end

        def medical_reports_med_monthly_stat_unfit_reason
            attachments["med_monthly_stat_unfit_reason.xlsx"] = attach_xlsx_file(med_monthly_stat_unfit_reason)
            send_email_with_settings(report_name: "med_monthly_stat_unfit_reason", subject: "Medical Monthly Statistics - Unfit Reason")
        end
private
    def parse_output_format(filename)
        if @csv.present?
            return @csv
        elsif @excel.present?
            return @excel
        end
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

    def attach_csv_file(csv = nil)
        @csv            = csv
        generated_csv   = CSV.generate {|csv| @csv.each {|row| csv << row }}
        { mime_type: "text/csv", content: generated_csv }
    end

    def attach_xlsx_file(excel = nil)
        @excel                  = excel
        render_xlsx_attachment  = render_to_string(handlers: [:axlsx], formats: [:xlsx], layout: false, template: "shared/reports/excel_caxlsx_template")
        { mime_type: Mime[:xlsx], content: render_xlsx_attachment }
    end
end