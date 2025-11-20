require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OrderForge
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.autoload_paths += Dir["#{config.root}/app/lib/**"]
    # Configuration for the application, engines, and railties goes here.
    #
    # config.assets.initialize_on_precompile = false

    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Africa/Lagos'

    config.autoload_paths << Rails.root.join('app/services')
    config.autoload_paths += Dir[Rails.root / 'app/packages/*/app/*']
    config.autoload_paths += Dir[Rails.root / 'app/packages/*/spec/*']
    config.eager_load_paths << Rails.root.join('app', 'errors')

    packs_path = Rails.root.join('packs')
    Dir.glob(packs_path.join('*')).each do |pack_dir|
      next unless File.directory?(pack_dir)

      app_path = File.join(pack_dir, 'app')
      next unless File.directory?(app_path)

      Dir.glob(File.join(app_path, '*')).each do |component_path|
        next unless File.directory?(component_path)

        config.autoload_paths << component_path
        config.eager_load_paths << component_path

        concerns_path = File.join(component_path, 'concerns')
        Rails.autoloaders.main.collapse(concerns_path) if File.directory?(concerns_path)
      end
    end

    config.middleware.use Rack::Attack

    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::MethodOverride

    # This also configures session_options for use below
    # Required for all session management (regardless of session_store)
    config.middleware.use ActionDispatch::Cookies
    config.session_store :cookie_store, key: '_order_forge_session'
    config.middleware.use config.session_store, config.session_options

    config.active_job.queue_adapter = :sidekiq
    config.api_only = true

    Rack::Attack.enabled = false

    # config.eager_load_paths << Rails.root.join("extras")
  end
end
