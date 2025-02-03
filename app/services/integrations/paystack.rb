module Integrations
  class Paystack
    BASE_URL = ENV.fetch('PSTK_URL', nil)
  end
end
