source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
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
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'slim-rails'
# Bootstrap JavaScript depends on jQuery. For Rails 5.1+ this gem is needed
gem 'jquery-rails'
# AUTH mega-module
gem 'devise', '~> 4.0'
#  AWS SDK for ruby, v.3
gem 'aws-sdk-s3', '~> 1'
# Validates URL to AR and AM
gem 'validate_url'
# Cocoon makes it easier to handle nested forms
gem "cocoon"
# Manipulates images with minimall use of memory via ImageMagick
gem 'mini_magick', '~> 4.5', '>= 4.5.1'
# Dynamically builds an AR Model before each test and destroys it afterwards
gem 'with_model'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing
  gem 'capybara', '>= 3.28'
  # RSpec gem to test Rails Apps
  gem 'rspec-rails', '~> 3.8'
  # Gem to seed test databases
  gem 'factory_bot_rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing (moved up) and selenium driver
  ## gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver', '> 3.142.3'
  gem 'webdrivers', '~> 4.1'
  # Easy installation and use of chromedriver to run system tests with Chrome -> deprecated !
  ## gem 'chromedriver-helper'
  # Simple One-liner tests for Rails
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  # for 'save_and_open_page' testing
  gem 'launchy'
end

# Windows does not include zoneinfo attachments, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
