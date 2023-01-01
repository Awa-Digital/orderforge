CarrierWave.configure do |config|
  # These permissions will make dir and files available only to the user running
  # the servers
  config.permissions = 0600
  config.directory_permissions = 0700
  config.storage = :file

  # This avoids uploaded files from saving to public/ and so
  # they will not be available for public (non-authenticated) downloading
  config.root = Rails.root
  config.asset_host = if Rails.env.development?
                        "localhost:3000"
                      elsif Rails.env.production?
                        "https://api.jazzysburger.com"
                      end

end
