# frozen_string_literal: true

module Types
  class NestedOrderItemType < Types::BaseInputObject
    description 'Input for a nested order items'

    argument :product_id, Integer, required: true
    argument :quantity, Integer, required: true
  end
end

module Mutations
  class CreateOrder < BaseMutation
    description "create an order for a customer"

    argument :address_id, Integer, required: true
    argument :user_id, Integer, required: true
    argument :recipient_name, String, required: true
    argument :recipient_phone, String, required: true
    argument :recipient_email, String, required: true
    argument :order_items_attributes, [Types::NestedOrderItemType, { null: true }], required: false

    type Types::OrderType

    def resolve(attributes)
      if attributes[:order_items_attributes]
        # Transform NestedOrderItemTypes to attribute hashes
        attributes[:order_items_attributes] = attributes[:order_items_attributes].map(&:to_h)
      end
      attributes[:status] = "initiated"

      Order.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
