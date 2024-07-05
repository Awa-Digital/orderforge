# frozen_string_literal: true

module Mutations
  class CreateOrderAddress < BaseMutation
    description "create an address for an order for a customer"

    argument :order_id, Integer
    argument :house_number, String
    argument :street, String
    argument :city, String
    argument :state, String
    argument :country, String
    argument :delivery_area_id, Integer

    type Types::OrderAddressType

    def resolve(**attributes)
      OrderAddress.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
