# Be sure to restart your server when you modify this file.

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  null_regex = /\Anull\z/

  allow do
    hostnames = [null_regex, 'localhost:3000', 'localhost:3001', 'app.forestadmin.com']
    hostnames += ENV['CORS_ORIGINS'].to_s.split(',').map(&:strip).reject(&:empty?)
    origins hostnames
    resource '*',
             headers: :any,
             methods: :any,
             expose: ['Content-Disposition'],
             credentials: true
  end
end
