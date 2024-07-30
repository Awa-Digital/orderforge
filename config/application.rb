require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JazzyBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.autoload_paths += Dir["#{config.root}/app/lib/**"]
    # Configuration for the application, engines, and railties goes here.
    #
    config.assets.initialize_on_precompile = false

    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Africa/Lagos'

    config.autoload_paths += Dir[Rails.root / 'app/packages/*/app/*']
    config.autoload_paths += Dir[Rails.root / 'app/packages/*/spec/*']

    config.middleware.use Rack::Attack

    config.middleware.use ActionDispatch::Flash

    # This also configures session_options for use below
    # Required for all session management (regardless of session_store)
    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options

    config.active_job.queue_adapter = :sidekiq
    config.api_only = true

    # config.eager_load_paths << Rails.root.join("extras")
  end
end
