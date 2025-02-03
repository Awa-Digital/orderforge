module Integrations
  class FlutterWave
    BASE_URL = ENV.fetch('FLW_BASE_URL', nil)
    V2_BASE_URL = ENV.fetch('FLW_V2', nil)
  end
end
