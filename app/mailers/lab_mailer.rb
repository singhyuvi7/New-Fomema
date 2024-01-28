# bundle exec sidekiq -q default -q mailers

class LabMailer < ApplicationMailer

    def lab_license_expiry_reminder_email 
        @laboratory = params[:laboratory]
        mail(to: @laboratory.email, subject: "Laboratories SAMM Expiry Reminder")
    end

end