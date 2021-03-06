# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Capybara Test Mail messages
require 'capybara/email/rspec'

# Add additional requires below this line. Rails is not loaded until this point!
# Extend WithModel into RSpec
require 'with_model'

# Requires supporting ruby attachments with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec attachments by default. This means that attachments in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name attachments matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all attachments in the support
# directory. Alternatively, in the individual `*_spec.rb` attachments, manually
# require only the support attachments necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # FactoryBot methods quick ref.
  config.include FactoryBot::Syntax::Methods
  # Helpers for testing (for ex., controllers) with Devise engaged
  config.include Devise::Test::ControllerHelpers, type: :controller
  # Add our helpers, created in 'support' dir
  config.include ControllerHelpers, type: :controller
  config.include FeatureHelpers, type: :feature
  config.include OmniauthMacros
  config.include ApiHelpers, type: :request
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Extend WithModel into RSpec
  config.extend WithModel

  # Clear junk in tmp/storage
  config.after(:all) do
    FileUtils.rm_rf("#{Rails.root}/tmp/storage")
  end

  # Run acceptance tests in Chrome rather than in FireFox
  # Default install path for chromium in Ubuntu differs from standard ('/usr/bin/google-chrome').
  # check with '$which chromium-browser'
  Selenium::WebDriver::Chrome.path = '/usr/bin/chromium-browser'
  Webdrivers::cache_time = 86_400
  ## Capybara.javascript_driver = :selenium_chrome
  # no Chrome interaction
  Capybara.javascript_driver = :selenium_chrome_headless
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Turn on "test mode" for OmniAuth
OmniAuth.config.test_mode = true

# CanCan rspec matchers
require 'cancan/matchers'

#Background jobs 'inline' in test mode
require 'sidekiq/testing'
Sidekiq::Testing.fake!
