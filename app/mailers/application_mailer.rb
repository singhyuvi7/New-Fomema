class ApplicationMailer < ActionMailer::Base
    # default from: 'from@example.com'
    default from: ENV["EMAIL_FROM"] || ENV["EMAIL_USERNAME"] || "uat@fomema.com.my"
    layout "mailer"

    def self.inherited(subclass)
        subclass.default template_path: "mailers/#{subclass.name.to_s.underscore}"
    end
end

class SmtpAddressBlankError < StandardError; end
