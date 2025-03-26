require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TechnoServe
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = { api_token: Rails.application.credentials.dig(:postmark, :api_token) }

    config.x.project_settings.name = 'Techno Serve'
    config.x.project_settings.slug = 'techno_serve'
    config.x.project_settings.logo_url = 'https://technoserve-production.s3.us-east-2.amazonaws.com/techno_serve_logo.png'
    config.x.project_settings.default_from_email = 'no-reply@commutatus.com'

    config.active_record.yaml_column_permitted_classes = [Symbol, Hash, Array, ActiveSupport::TimeWithZone,
                                                          ActiveSupport::TimeZone, ActiveSupport::HashWithIndifferentAccess,
                                                          ActiveModel::Attribute.const_get(:FromDatabase), Time]
  end
end
