require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EgslWebsiteApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.middleware.use Rack::Cors do
      allow do
        origins Rails.application.config.allowed_cors_origins
        resource '*',
                 headers: :any,
                 expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
                 methods: %i[get post put patch delete options head]
      end
    end

    config.i18n.default_locale = :ar
    config.i18n.fallbacks = [:en]
    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    # Required middleware for session management.
    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies # Required for all session management
    config.middleware.use ActionDispatch::Session::CookieStore, config.session_options

    # Disable minimagick validations since all images are generated via activestorage
    MiniMagick.configure do |config|
      config.validate_on_create = false
      config.validate_on_write = false
    end
  end
end
