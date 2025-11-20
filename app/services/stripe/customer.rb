# frozen_string_literal: true

module Stripe
  class Customer < OpenStruct
    include Resource

    PATH = 'customers'

    class << self
      def update(customer_id:, **params)
        super(resource_id: customer_id, **params)
      end

      def make_payload( # rubocop:disable Metrics/ParameterLists
        email: nil,
        name: nil,
        phone: nil,
        description: nil,
        metadata: {},
        address: {},
        shipping: {}
      )
        payload = {}
        payload[:email] = email if email
        payload[:name] = name if name
        payload[:phone] = phone if phone
        payload[:description] = description if description

        flat_metadata = metadata.transform_keys { |k| "metadata[#{k}]" } if metadata&.any?
        payload = payload.merge(flat_metadata) if flat_metadata

        address&.each { |key, value| payload["address[#{key}]"] = value if value }
        shipping&.each { |key, value| payload["shipping[#{key}]"] = value if value }

        payload
      end
    end
  end
end

# Usage examples:
# Stripe::Customer.create(email: 'user@example.com', name: 'John Doe')
# Stripe::Customer.update(customer_id: 'cus_123', email: 'newemail@example.com')
# Stripe::Customer.retrieve('cus_123')
# Stripe::Customer.delete('cus_123')
