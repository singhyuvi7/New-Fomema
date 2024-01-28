class DailyVoidCollectionWorker < ActionController::Base
    include Sidekiq::Worker
    include Sage
    include DailyVoidCollection

    def perform(*args)   
        @utc_time_format = "T00:00:00.000Z"
        @current = (Date.today - 2)

        void_collection
    end
end
