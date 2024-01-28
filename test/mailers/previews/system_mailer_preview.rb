# Preview all emails at http://localhost:3000/rails/mailers/system_reports_mailer
class SystemMailerPreview < ActionMailer::Preview
    def a__xray_server_timeout_report
        options = {
            "Time" => Time.now,
            "Provider URL" => "http://nios.localhost.com:3000/rails/mailers/system_mailer/a__xray_server_timeout_report"
        }

        SystemMailer.xray_server_timeout_report(options)
    end
end