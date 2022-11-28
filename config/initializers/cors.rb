# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # allow do
  #   origins '*'

  #   resource '*',
  #            headers: :any,
  #            methods: %i[get post put patch delete options head]
  # end

  null_regex = Regexp.new(/\Anull\z/)

  allow do
    hostnames = [null_regex, 'localhost:3000', 'app.forestadmin.com', 'localhost:3001', 'jazzysjuicyburger.com',
                 'jazzysjuicyburger.herokuapp.com', 'jazzy-burger-web-app-5mxwi.ondigitalocean.app', 'app.jazzysjuicyburgers.com', 'jazzysburger.com', 'www.jazzysburger.com', 'app.jazzysburger.com']
    hostnames += ENV['CORS_ORIGINS'].split(',') if ENV['CORS_ORIGINS']
    origins hostnames
    resource '*',
             headers: :any,
             methods: :any,
             expose: ['Content-Disposition'],
             credentials: true
  end
end
