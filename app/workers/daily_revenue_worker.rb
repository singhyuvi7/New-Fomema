class DailyRevenueWorker < ActionController::Base
    include Sidekiq::Worker
    include Sage
    include DailyRevenue 

    def perform(*args)
        @utc_time_format = "T00:00:00.000Z"
        @current = Date.yesterday

        revenue
    end
end
