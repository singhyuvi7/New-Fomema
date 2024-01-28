class DailyCollectionWorker < ActionController::Base
    include Sidekiq::Worker
    include Sage
    include DailyCollection

    def perform(*args)
        @utc_time_format = "T00:00:00.000Z"
        @current = (Date.today - 2)

        collection
    end

end
