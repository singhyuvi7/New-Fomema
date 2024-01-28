source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'
# ruby '2.7.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.0.3.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# new added
gem 'typhoeus'
gem 'rack-cors'
gem 'dotenv-rails' # load environment variables from .env - https://github.com/bkeepers/dotenv
gem 'devise' # authentication - https://github.com/plataformatec/devise
gem 'kaminari' # pagination - https://github.com/kaminari/kaminari
gem 'paranoia' # soft delete - https://github.com/rubysherpas/paranoia
gem 'coreui-rails', '~> 1.1'
gem "select2-rails"
gem 'devise-security'
gem 'approval', path: './sources/approval'
gem 'carrierwave', '~> 1.0'
gem 'file_validators'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem "audited", "~> 4.7"
gem "poppler"
gem 'wicked_pdf'
gem "browser"
#gem 'approval'
#gem 'wkhtmltopdf-binary'
#gem "image_processing", "~> 1.9"
#gem 'wdm', '>= 0.1.0' if Gem.win_platform?
gem 'sidekiq', "~> 5.2"
gem "sidekiq-cron", "~> 1.1"
gem 'nested_form'
gem 'tzinfo-data'
gem 'acts_as_tree', '~> 2.4'
gem 'has_scope'
gem 'barby', require: %w(barby barby/barcode/code_128 barby/outputter/png_outputter)
gem 'chunky_png'
gem 'recaptcha'
gem 'sablon'
gem 'active_link_to'
gem 'webpacker', '~> 4.x'
gem "savon", '~> 2.12.0'
gem "wash_out", path: './sources/wash_out' #git: "https://github.com/joiechian-bookdoc/wash_out", ref: '44b0440'
gem 'momentjs-rails'
# postgresql partition
gem 'pg_party'

gem 'faker', :git => 'https://github.com/faker-ruby/faker.git', :branch => 'master' # Adds random name, quote, number, location, etc generator.
gem 'full_request_logger'
# gem 'logster'
gem 'public_activity'

gem "activestorage-aliyun"
gem "caxlsx"
gem "caxlsx_rails"
gem "draper", "~> 4.0"
gem "haml", "~> 5.1"
# gem 'newrelic_rpm'

gem 'activerecord-session_store'
gem 'john_hancock'

gem 'combine_pdf'
gem 'rmagick'

gem 'azure-storage-blob'
# group :stagingali, :production1, :production2, :production3 do
  # gem "skylight"
# end
#gem 'roo'
# This library extends Roo to add support for handling class Excel files, including:
# .xls files
# .xml files in the SpreadsheetML format (circa 2003)
# @dependent on roo gem
# @link https://github.com/roo-rb/roo-xls
#gem 'roo-xls'
# conversion into excel
# @link https://github.com/liangwenke/to_xls-rails
#gem 'to_xls-rails'

group :development, :test, :staging, :stagingali, :stagingali2, :production, :production1, :production2, :production3 do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem "sentry-raven"
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano3-puma'
  gem 'capistrano-sidekiq'
end

group :development do
  gem "better_errors" # comment this if want to use sentry-raven
  gem "binding_of_caller"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rb-readline'
  gem 'awesome_print'
  # gem 'capistrano'
  # gem 'capistrano-rvm'
  # gem 'capistrano-rails'
  # gem 'capistrano-bundler'
  # gem 'capistrano3-puma'
  # gem 'capistrano-sidekiq'
  gem "letter_opener" # Opens the email in your development web browser, instead of sending via smtp.
  gem 'pry', '~> 0.12.2' # Nicer text format in rails console.
  gem 'bullet'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers'
end

# for customer survey upload
gem 'creek'