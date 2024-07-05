# frozen_string_literal: true

module Mutations
  class CreateOrderItem < BaseMutation
    argument :product_id, Integer
    argument :quantity, Integer
    argument :order_id, Integer

    type Types::OrderItemType

    def resolve(order_id:, **attributes)
      Order.find(order_id).order_items.create(**attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
