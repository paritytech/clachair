require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Clachair
  class Application < Rails::Application
    config.load_defaults 5.2
    config.active_job.queue_adapter = :delayed_job

    Github.configure do |c|
      c.client_id       = ENV['GITHUB_CLIENT_ID']
      c.client_secret   = ENV['GITHUB_CLIENT_SECRET']
      c.auto_pagination = true
    end
  end
end
