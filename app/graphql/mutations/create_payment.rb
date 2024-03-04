# frozen_string_literal: true

module Mutations
  class CreatePayment < BaseMutation
    description "create a payment for an order"
    argument :total, Float
    argument :payment_charges, Float
    argument :discount_id, Integer
    argument :order_id, Integer
    argument :user_id, Integer
    argument :reference, String
    argument :gateway, String
    argument :payment_id, String
    argument :voucher_id, Integer

    type Types::PaymentType

    def resolve(order_id, **attributes)
      Order.find(order_id).payment.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
