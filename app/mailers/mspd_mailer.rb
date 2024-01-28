# bundle exec sidekiq -q default -q mailers

class MspdMailer < ApplicationMailer

    def group_schedule_inactive
        email               = params[:email]
        csv                 = params[:csv]
        @today               = params[:today]
        @previous_month_date = params[:previous_month_date]

        attachments["Service Provider.csv"] = { mime_type: 'text/csv', content: csv }
        mail(to: email, subject: 'LIST OF INACTIVE SP IN SERVICE PROVIDER GROUP PAYMENT / COMPANY')
    end

    def daily_balance_full_quota
        email               = params[:email]
        csv                 = params[:csv]

        attachments["Doctor.csv"] = { mime_type: 'text/csv', content: csv }
        mail(to: email, subject: 'LIST OF DOCTOR - BALANCE QUOTA < 30')
    end
end