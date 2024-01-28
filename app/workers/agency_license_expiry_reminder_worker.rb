class AgencyLicenseExpiryReminderWorker
    include Sidekiq::Worker

    def perform(*args)
        # Send reminder email x days before license expired
        days_ago = [30, 60, 90]
        days_ago.each do |d|
            Agency.where("agencies.status = ? and agencies.license_expired_at = ?", 'ACTIVE', DateTime.now.beginning_of_day + d.days)
            .joins("inner join users on agencies.code = users.code").each do |agency|
                if !agency&.email.blank?
                    AgencyMailer.with({
                        agency: agency
                    }).license_expiry_reminder_email.deliver_later
                end
            end
        end
    end
end