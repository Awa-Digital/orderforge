# frozen_string_literal: true

module Types
  class PaymentType < Types::BaseObject
    field :id, ID, null: false
    field :total, Float
    field :payment_charges, Float
    field :discount_id, Integer
    field :order_id, Integer
    field :paid, Boolean
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :user_id, Integer
    field :reference, String
    field :gateway_reference, String
    field :checkout_url, String
    field :gateway, String
    field :payment_id, String
    field :voucher_id, Integer
    field :paid_at, GraphQL::Types::ISO8601DateTime
  end
end
