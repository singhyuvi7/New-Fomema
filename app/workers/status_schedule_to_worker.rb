class StatusScheduleToWorker
    include Sidekiq::Worker

    def perform(*args)
        StatusSchedule.where(to: Time.now.strftime('%F')).each do |ss|
            sp = ss.status_scheduleable
            if !ss.previous_status.blank?
                sp.status = ss.previous_status
            end
            sp.status_reason = ss.previous_status_reason
            sp.status_comment = ss.previous_comment
            sp.save(validate: false)
        end
    end
end
