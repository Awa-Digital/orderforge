# frozen_string_literal: true

require 'uri'

module Stripe
  class PaymentMethod < OpenStruct
    PATH = 'payment_methods'

    class << self
      # List all payment methods for a customer
      # GET /v1/payment_methods?customer=cus_xxx&type=card
      def list(customer:, type: 'card')
        raise Stripe::Error::MissingArguments, 'customer is required' unless customer

        # Build query string for GET request
        query_params = URI.encode_www_form(customer: customer, type: type)
        path_with_params = "#{PATH}?#{query_params}"

        response = Stripe.connection.request(
          method: :get,
          path: path_with_params
        )

        # Transform the response to return an array of payment methods
        data = Stripe.deep_transform(response)
        data[:data] || []
      end

      # Retrieve a specific payment method
      def retrieve(payment_method_id)
        raise Stripe::Error::MissingArguments, 'payment_method_id is required' unless payment_method_id

        response = Stripe.connection.request(
          method: :get,
          path: "#{PATH}/#{payment_method_id}"
        )
        new(Stripe.deep_transform(response))
      rescue Stripe::Error::RequestFailed => e
        error_message = Stripe.connection.parse_error(e)
        Rails.logger.debug error_message['error']['message'] if error_message

        nil
      end

      # Attach a payment method to a customer
      def attach(payment_method_id:, customer:)
        unless payment_method_id && customer
          raise Stripe::Error::MissingArguments,
                'payment_method_id and customer are required'
        end

        response = Stripe.connection.request(
          method: :post,
          path: "#{PATH}/#{payment_method_id}/attach",
          data: { customer: customer }
        )
        new(Stripe.deep_transform(response))
      end

      # Detach a payment method from a customer
      def detach(payment_method_id:)
        raise Stripe::Error::MissingArguments, 'payment_method_id is required' unless payment_method_id

        response = Stripe.connection.request(
          method: :post,
          path: "#{PATH}/#{payment_method_id}/detach"
        )
        new(Stripe.deep_transform(response))
      end

      # Alias for detach (delete)
      alias delete detach
    end
  end
end
