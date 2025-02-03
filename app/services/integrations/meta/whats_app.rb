module Integrations
  class Meta
    class WhatsApp
      BASE_URL = "#{ENV.fetch('META_BASE_URL', nil)}#{ENV.fetch('WHATSAPP_NUMBER_ID', nil)}/".freeze
    end
  end
end
