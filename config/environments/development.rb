Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.perform_caching = false

  config.action_mailer.default_url_options = {
    subdomain: ENV['APP_URL_NIOS'].try(:downcase) || 'external',
    host: ENV['APP_DOMAIN'] || 'fomema-project.development'
  }.merge(ENV.has_key?("PUMA_PORT") ? {port: ENV["PUMA_PORT"]} : {})

  config.action_mailer.default_options = {
    from: ENV["EMAIL_FROM"] || ENV["EMAIL_USERNAME"] || "uat@fomema.com.my"
  }

  if ENV["MAILER_TYPE"] == "letter_opener"
    config.action_mailer.delivery_method = :letter_opener
    config.action_mailer.perform_deliveries = true
  else
    config.action_mailer.delivery_method = :smtp

    # SMTP settings for gmail
    config.action_mailer.smtp_settings = {
      address: ENV["EMAIL_ADDRESS"] || "smtp.office365.com",
      port: ENV["EMAIL_PORT"] || 587,
      user_name: ENV['EMAIL_USERNAME'] || 'uat@fomema.com.my',
      password: ENV['EMAIL_PASSWORD'] || 'r7H5wKDt',
      authentication: ENV['EMAIL_AUTHENTICATION'] || "login",
      enable_starttls_auto: true
    }
  end

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = ENV["MIGRATION_ERROR"] || :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.active_storage.service = ENV["ACTIVE_STORAGE_SERVICE"] || :development

  config.hosts << "#{ENV['SUBDOMAIN_MERTS'].downcase}.#{ENV['APP_DOMAIN'].downcase}"
  config.hosts << "#{ENV['SUBDOMAIN_PORTAL'].downcase}.#{ENV['APP_DOMAIN'].downcase}"
  config.hosts << "#{ENV['SUBDOMAIN_NIOS'].downcase}.#{ENV['APP_DOMAIN'].downcase}"
  config.hosts << "#{ENV["SUBDOMAIN_LABWS"].downcase}.#{ENV["APP_DOMAIN"].downcase}"
  config.hosts << "#{ENV["SUBDOMAIN_XRAYWS"].downcase}.#{ENV["APP_DOMAIN"].downcase}"

  config.full_request_logger.enabled = true
  config.full_request_logger.ttl     = 1.hour
  config.full_request_logger.redis   = { host: "127.0.0.1", port: 6379, timeout: 1 }

  # To use this, put USE_BULLET=true to .env.development file.
  # Configurations for Bullet gem, this gem will check for N+1 queries.
  if ENV["USE_BULLET"] || false
    config.after_initialize do
      Bullet.enable = true
      Bullet.rails_logger = true # add warnings directly to the Rails log
    end
  end
end