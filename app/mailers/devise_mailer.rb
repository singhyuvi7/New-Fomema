class DeviseMailer < Devise::Mailer
    helper :application
    include Devise::Controllers::UrlHelpers
    default template_path: 'devise/mailer', from: ENV["EMAIL_FROM"] || ENV["EMAIL_USERNAME"] || "uat@fomema.com.my"

    def reset_password_instructions(record, token, opts = {})
        @site = record.role.site.downcase
        @name = record.name
        @code = record.code
        super
    end

    def confirmation_instructions(record, token, opts={})
        @site = record.role.site.downcase
        super
    end
end