namespace :migration_task do # rake migration_task:rake_2020_09_05_updates_for_various_models
    desc "Converts examination columns to details and comments"
    task rake_2020_09_05_updates_for_various_models: :environment do
        puts "Starting Rake Run - Updates For Various Models"
        puts

        TcupiTodo.where(id: 1..7).update(is_active: true)
        TcupiTodo.where.not(id: 1..7).update(is_active: false)
        AppealTodo.where(id: 1..26).update(is_active: true)
        AppealTodo.where.not(id: 1..26).update(is_active: false)

        puts "Ending Rake Run - Updates For Various Models"
        puts
    end
end