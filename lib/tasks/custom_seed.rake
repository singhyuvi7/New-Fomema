# This routine will look at the db folder, look for a seeds folder and then search the seeds folder for a file that matches the name we type after
# E.g.: rails db:seed:<filename in the db/seeds xxx.rb>
namespace :db do
  namespace :seed do
    Dir[Rails.root.join('db', 'seeds', '*.rb')].each do |filename|
      task_name = File.basename(filename, '.rb')
      desc "Seed " + task_name + ", based on the file with the same name in `db/seeds/*.rb`"
      task task_name.to_sym => :environment do
        load(filename) if File.exist?(filename)
      end
    end
  end
end