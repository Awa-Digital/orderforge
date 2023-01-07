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
                        'https://api.jazzysburger.com'
                      end
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['DO_FOG_KEY'],
    aws_secret_access_key: ENV['DO_FOG_SECRET'],
    region: ENV['DO_FOG_REGION'],
    endpoint: ENV['DO_FOG_ENDPOINT']
  }
  config.fog_directory  = ENV['DO_FOG_NAME']
  config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }
  config.fog_public = false
  # config.asset_host = 'https://ams3.digitaloceanspaces.com'
  config.fog_attributes = { 'Cache-Control' => 'max-age=315576000' }
end
