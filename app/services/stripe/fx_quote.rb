# frozen_string_literal: true

# app/services/stripe/fx_quotes.rb

require 'ostruct'

module Stripe
  class FxQuote < ::OpenStruct
    class << self
      def create(to_currency:, from_currencies:, lock_duration: 'none')
        payload = {
          to_currency:,
          'from_currencies[]': from_currencies,
          lock_duration:
        }

        response = Stripe.connection.request(method: :post, path: 'fx_quotes', data: payload)
        new(Stripe.deep_transform(response))
      end

      def retrieve(id)
        response = connection.request(method: :get, path: "fx_quotes/#{id}")
        new(Stripe.deep_transform(response))
      end

      def list(ending_before: nil, limit: 10, starting_after: nil)
        params = {}
        params[:ending_before] = ending_before if ending_before
        params[:limit] = limit if limit
        params[:starting_after] = starting_after if starting_after

        response = Stripe.connection.request(method: :get, path: 'fx_quotes', data: params)
        new(Stripe.deep_transform(response))
      end
    end
  end
end
