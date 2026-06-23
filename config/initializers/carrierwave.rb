CarrierWave.configure do |config|
  # These permissions will make dir and files available only to the user running
  # the servers
  config.permissions = 0o600
  config.directory_permissions = 0o700
  config.storage = :file

  # This avoids uploaded files from saving to public/ and so
  # they will not be available for public (non-authenticated) downloading
  # config.root = Rails.root
  config.asset_host = if Rails.env.development?
                        'localhost:3000'
                      elsif Rails.env.production?
                        "https://#{AppBranding::API_HOST}"
                      end
  # config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV.fetch('DO_FOG_KEY', nil),
    aws_secret_access_key: ENV.fetch('DO_FOG_SECRET', nil),
    region: ENV.fetch('DO_FOG_REGION', nil),
    endpoint: ENV.fetch('DO_FOG_ENDPOINT', nil)
  }
  config.fog_directory  = ENV.fetch('DO_FOG_NAME', nil)
  config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }
  config.fog_public = false
  # config.asset_host = 'https://ams3.digitaloceanspaces.com'
  config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }
end
