require "simplecov"
SimpleCov.start "rails"

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"

require "capybara/rspec"
require "capybara/rails"

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

OmniAuth.config.test_mode = true
ActiveJob::Base.queue_adapter = :test

VCR.configure do |config|
  config.default_cassette_options = {allow_playback_repeats: true}
  config.ignore_localhost = true
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include FeatureHelpers, type: :feature
  config.include OmniauthMacros, type: :feature
  config.include OmniauthMacros, type: :model
  config.include OmniauthMacros, type: :controller
  config.include DateHelper
  config.include MarkdownHelper
end

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome,
                                      desired_capabilities: {chromeOptions: {args: %w(headless disable-gpu no-sandbox)}})
end
Capybara.javascript_driver = :selenium_chrome
