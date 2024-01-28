# config valid for current version and patch releases of Capistrano
# lock "~> 3.12.0"
lock "~> 3.14.1"

set :rvm_ruby_version, 'ruby-2.6.5'

set :application, "fomema"
# set :repo_url, "https://github.com/bookdocmanagement/New-Fomema.git"
# set :repo_url, "git@github.com:bookdocmanagement/New-Fomema.git"
set :repo_url, "git@github.com:fomema/New-Fomema.git"
set :user, 'deployer'
set :puma_conf, "#{shared_path}/config/puma.rb"
set :puma_threads, [2, 8]
set :puma_workers, 1

# Don't change these unless you know what you're doing
set :pty, true
set :use_sudo, false
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_conf, "#{shared_path}/config/puma.rb"
set :puma_bind,  "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log, "#{release_path}/log/puma.access.log"
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa) }
set :puma_preload_app, true
set :puma_worker_timeout, 3600
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

## Defaults:
set :branch, ENV['BRANCH'] || 'master'
set :format, :pretty
set :log_level, :debug
set :keep_releases, 5

## Linked Files & Directories (Default None):
set :linked_files, %w{config/database.yml config/secrets.yml config/puma.rb config/master.key .env.staging .env.production1 .env.production2 .env.production3}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :linked_dirs,  %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  #before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, "public/packs", ".bundle", "node_modules"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

before "deploy:assets:precompile", "deploy:yarn_install"
namespace :deploy do
  desc "Run rake yarn install"
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end
end