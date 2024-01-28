medical_team_recipients = ["harris@fomema.com.my", "yusoff@fomema.com.my", "munirah@fomema.com.my", "drmdridzal@fomema.com.my", "azrin@fomema.com.my", "nurlyana@fomema.com.my", "tarmie@fomema.com.my"]

["cronjob_appeal", "cronjob_reappeal", "cronjob_reject_appeal", "medical_appeal", "type_of_diseases"].each do |report_name|
    cronjob = ReportCronjob.with_deleted.find_or_initialize_by(report_name: report_name)
    cronjob.update(deleted_at: nil)

    medical_team_recipients.each do |recipient_email|
        email   = ReportCronjobEmail.with_deleted.find_or_initialize_by(report_cronjob_id: cronjob.id, email: recipient_email, recipient_type: "main")
        email.update(deleted_at: nil)
    end
end

# weeklydiseaserelease@fomema.com.my

medical_team_recipients = ["harris@fomema.com.my", "munirah@fomema.com.my", "yusoff@fomema.com.my", "DBAdmin@fomema.com.my"]

["med_monthly_stat_appeal", "med_monthly_stat_pr", "med_monthly_stat_tcupi", "med_monthly_stat_reuse_passport"].each do |report_name|
    cronjob = ReportCronjob.with_deleted.find_or_initialize_by(report_name: report_name)
    cronjob.update(deleted_at: nil)

    medical_team_recipients.each do |recipient_email|
        email   = ReportCronjobEmail.with_deleted.find_or_initialize_by(report_cronjob_id: cronjob.id, email: recipient_email, recipient_type: "main")
        email.update(deleted_at: nil)
    end
end


medical_team_recipients = ["weeklydiseaserelease@fomema.com.my"]

["cronjob_moh_weekly_email_report"].each do |report_name|
    cronjob = ReportCronjob.with_deleted.find_or_initialize_by(report_name: report_name)
    cronjob.update(deleted_at: nil)

    medical_team_recipients.each do |recipient_email|
        email   = ReportCronjobEmail.with_deleted.find_or_initialize_by(report_cronjob_id: cronjob.id, email: recipient_email, recipient_type: "main")
        email.update(deleted_at: nil)
    end
end

finance_team_recipients = ["financegroup@fomema.com.my"]

["daily_refund_payment_failed_reminder"].each do |report_name|
    cronjob = ReportCronjob.with_deleted.find_or_initialize_by(report_name: report_name)
    cronjob.update(deleted_at: nil)

    finance_team_recipients.each do |recipient_email|
        email   = ReportCronjobEmail.with_deleted.find_or_initialize_by(report_cronjob_id: cronjob.id, email: recipient_email, recipient_type: "main")
        email.update(deleted_at: nil)
    end
end