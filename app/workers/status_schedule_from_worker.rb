class StatusScheduleFromWorker
    include Sidekiq::Worker

    def perform(*args)
        StatusSchedule.where(from: (Time.now).strftime('%F')).each do |ss|
            ss.update({
                previous_status: ss.status_scheduleable.status,
                previous_status_reason: ss.status_scheduleable.status_reason,
                previous_comment: ss.status_scheduleable.status_comment
            })
            sp = ss.status_scheduleable
            sp.status = ss.status
            sp.status_reason = ss.status_reason
            sp.status_comment = ss.comment
            sp.save(validate: false)
        end
    end
end
