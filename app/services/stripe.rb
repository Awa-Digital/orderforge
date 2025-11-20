# frozen_string_literal: true

# app/services/stripe.rb

# Dir.glob("#{Rails.root}/app/services/stripe/**/*", &method(:require))

module Stripe
  class << self
    attr_accessor :api_key

    def connection
      raise 'API key not set' unless api_key

      @connection ||= Stripe::Request.new('https://api.stripe.com/v1/', api_key)
    end

    def connection_v2
      raise 'API key not set' unless api_key

      # Stripe API is always at /v1/, v2 uses same endpoint but can have different headers/config
      @connection_v2 ||= Stripe::Request.new('https://api.stripe.com/v1/', api_key)
    end

    def deep_transform(obj)
      case obj
      when Hash
        obj.transform_keys(&:to_sym).transform_values { |v| deep_transform(v) }
      when Array
        obj.map { |e| deep_transform(e) }
      else
        obj
      end
    end
  end
end
