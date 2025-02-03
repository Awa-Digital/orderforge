module Integrations
  class Paystack
    module Initializer
      def initialize
        @conn = Faraday.new(url: ENV.fetch('PSTK_URL', nil)) do |f|
          f.headers['Content-Type'] = 'application/json'
          f.headers['Authorization'] = "Bearer #{ENV.fetch('PSTK_TOKEN', nil)}"
        end
      end

      def self.method_missing(method, *, &)
        instance = new
        instance.send(method, *, &)
      end

      def self.respond_to_missing?(_method, _include_private = false)
        true
      end
    end
  end
end
