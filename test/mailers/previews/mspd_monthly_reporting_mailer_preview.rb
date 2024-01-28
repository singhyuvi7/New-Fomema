# Preview all emails at http://localhost:3000/rails/mailers/mspd_monthly_reporting
class MspdMonthlyReportingMailerPreview < ActionMailer::Preview
    def l_mspd_mail_report_fomema_medical_monthly
        MspdMonthlyReportingMailer.mspd_moh_monthly
    end
end