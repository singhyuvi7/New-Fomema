class DoctorQuotaQuarterlyReimbursementWorker
    include Sidekiq::Worker

    def perform(*args)
        today = Date.today

        if today.month == 1     #January
            quota = 125
        elsif today.month == 4  #April
            quota = 250
        elsif today.month == 7  #July
            quota = 375
        elsif today.month == 10 #October
            quota = 500
        end 

        # Set quota, reset quota_used to 0 at the beginning of the year, reset quota_modifier to 0 at the beginning of each quarter.
        if today.month == 1
            Doctor.all.update(quota: quota, quota_used: 0, quota_modifier: 0)
        else
            Doctor.all.update(quota: quota, quota_modifier: 0)
        end
    end
end