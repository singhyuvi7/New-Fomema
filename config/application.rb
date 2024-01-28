require_relative 'boot'
require 'csv'

# Include each railties manually, excluding `active_storage/engine`
%w(
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  rails/test_unit/railtie
  sprockets/railtie
  active_storage/engine
).each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fomema
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.autoload_paths += %W(#{config.root}/lib)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Set timezone
    config.time_zone = 'Kuala Lumpur'

    config.active_record.default_timezone = :local
    config.active_record.time_zone_aware_attributes = false
    # config.active_record.schema_format = :sql
    config.active_record.dump_schema_after_migration = false

    config.active_job.queue_adapter = :sidekiq

    config.action_dispatch.cookies_same_site_protection = :none

    #cors configuration
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :delete, :put, :patch, :options]
      end
    end

    # config.action_controller.forgery_protection_origin_check = false

    # Logster.set_environments([:stagingali])

    # if Rails.env.stagingali? || Rails.env.stagingali2?
      # config.skylight.environments += ["development", "staging", "production1", "production2", "production3"]
    # end
  end
end
