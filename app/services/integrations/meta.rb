module Integrations
  class Meta
    META_BASE_URL = ENV.fetch('META_BASE_URL', nil)
    META_TOKEN = ENV.fetch('META_TOKEN', nil)
  end
end
