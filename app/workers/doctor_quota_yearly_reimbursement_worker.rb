class DoctorQuotaYearlyReimbursementWorker
    include Sidekiq::Worker

    def perform(*args)
        # Resets all quota_used to 0 at the start of the year.
        Doctor.all.update(quota_used: 0, quota_modifier: 0)
    end
end