# frozen_string_literal: true

# app/services/stripe/error.rb

module Stripe
  class Error < StandardError
    class RequestFailed < Stripe::Error
    end

    class ApiKeyMissing < Stripe::Error
    end

    class BaseUrlMissing < Stripe::Error
    end

    class ClientError < Stripe::Error
    end

    class ProviderError < Stripe::Error
    end

    class UnexpectedResponse < Stripe::Error
    end

    class InvalidRequestType < Stripe::Error
    end

    class MissingArguments < Stripe::Error
    end
  end
end
