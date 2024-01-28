class SystemMailer < ApplicationMailer
    def xray_server_timeout_report(options = {})
        @options = options.sort_by {|key, value| key.to_s }
        mail to: ["hweeleng@fomema.com.my", "tarmie@fomema.com.my", "nadia.azhan@fomema.com.my"], subject: "Xray Server Timeout Report"
    end
end