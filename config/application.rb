require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ZackFacebookClone
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.action_mailer.delivery_method = :google_http_actionmailer

    puts "--------------------- STARTING !!!! ----------------------"

    strategy = OmniAuth::Strategies::GoogleOauth2.new(nil, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"])
    client = strategy.client
    #token = OAuth2::AccessToken.new(client)

    #config.action_mailer.google_http_actionmailer_settings = {
    #  authorization: token
    #}

  end
end
