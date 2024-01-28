class ActiveRecordSessionTrim
    require "rake"
    include Sidekiq::Worker

    def perform(*args)
        puts "Running ActiveRecordSessionTrim => db:sessions:trim"
        Rails.application.load_tasks
        Rake::Task["db:sessions:trim"].invoke
        puts "Completed ActiveRecordSessionTrim => db:sessions:trim"
        # To prevent unnecessarily large growth of storage.
        # https://github.com/rails/activerecord-session_store
    end
end