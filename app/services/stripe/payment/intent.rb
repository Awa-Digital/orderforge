# frozen_string_literal: true

module Stripe
  module Payment
    class Intent < OpenStruct
      PATH = 'payment_intents'

      class << self
        def create( # rubocop:disable Metrics/ParameterLists
          amount:,
          currency:,
          order_id: nil,
          email: nil,
          description: nil,
          metadata: {},
          automatic_payment_methods: {},
          customer: nil,
          setup_future_usage: nil
        )
          raise Stripe::Error::MissingArguments, 'amount and currency are required' unless amount && currency

          payload = make_payload(
            amount:,
            currency:,
            order_id:,
            email:,
            description:,
            metadata:,
            automatic_payment_methods:,
            customer:,
            setup_future_usage:
          )

          response = Stripe.connection.request(
            method: :post,
            path: PATH,
            data: payload
          )
          new(Stripe.deep_transform(response))
        end

        # For updating a payment intent
        def update( # rubocop:disable Metrics/ParameterLists
          intent_id:,
          amount: nil,
          currency: nil,
          order_id: nil,
          email: nil,
          description: nil,
          metadata: {},
          automatic_payment_methods: {},
          setup_future_usage: nil,
          payment_method: nil
        )
          raise Stripe::Error::MissingArguments, 'intent_id is required' unless intent_id

          payload = make_payload(
            amount:,
            currency:,
            order_id:,
            email:,
            description:,
            metadata:,
            automatic_payment_methods:,
            setup_future_usage:,
            payment_method:
          )
          response = Stripe.connection.request(
            method: :post,
            path: "#{PATH}/#{intent_id}",
            data: payload
          )
          new(Stripe.deep_transform(response))
        end

        def make_payload( # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity,Metrics/ParameterLists
          currency:,
          amount: nil,
          order_id: nil,
          email: nil,
          description: nil,
          metadata: {},
          automatic_payment_methods: {},
          customer: nil,
          setup_future_usage: nil,
          payment_method: nil
        )
          metadata = (metadata || {}).merge(order_id: order_id) if order_id
          flat_metadata = metadata.transform_keys { |k| "metadata[#{k}]" }
          flat_automatic_payment_methods = automatic_payment_methods.transform_keys do |k|
            "automatic_payment_methods[#{k}]"
          end

          payload = {}

          payload[:amount] = (amount * 100).to_i if amount
          payload[:currency] = currency
          payload[:customer] = customer if customer
          payload[:setup_future_usage] = setup_future_usage if setup_future_usage
          payload[:payment_method] = payment_method if payment_method
          payload = payload.merge(flat_metadata)
                           .merge(flat_automatic_payment_methods)

          payload[:description] = description if description
          payload[:receipt_email] = email if email

          payload
        end

        def retrieve(intent_id)
          raise Stripe::Error::MissingArguments, 'intent_id is required' unless intent_id

          response = Stripe.connection.request(method: :get, path: "#{PATH}/#{intent_id}")
          new(Stripe.deep_transform(response))
        rescue Stripe::Error::RequestFailed => e
          error_message = Stripe.connection.parse_error(e)
          Rails.logger.debug error_message['error']['message'] if error_message

          nil
        end
      end
    end
  end
end
