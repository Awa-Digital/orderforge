# frozen_string_literal: true

# Platform branding — override per deployment via environment variables.
module AppBranding
  NAME = ENV.fetch('APP_NAME', 'OrderForge')
  URL = ENV.fetch('APP_URL', 'http://localhost:3000')
  API_HOST = ENV.fetch('API_HOST', 'localhost:3000')
  MEDIA_PREFIX = ENV.fetch('MEDIA_PREFIX', 'media')
  SUPPORT_EMAIL = ENV.fetch('SUPPORT_EMAIL', 'support@example.com')
  NOREPLY_EMAIL = ENV.fetch('NOREPLY_FROM', 'noreply@example.com')
  AFFILIATE_URL = ENV.fetch('AFFILIATE_URL', "#{URL}/affiliate")
  MEDIA_CDN_URL = ENV.fetch('MEDIA_CDN_URL', '')
  OPS_EMAIL = ENV.fetch('OPS_EMAIL', 'orders@example.com')
  DISPATCH_EMAIL = ENV.fetch('DISPATCH_EMAIL', 'dispatch@example.com')
  STATUS_EMAIL = ENV.fetch('STATUS_EMAIL', 'status@example.com')
  SENDGRID_FROM_EMAIL = ENV.fetch('SENDGRID_FROM_EMAIL', NOREPLY_EMAIL)
end
