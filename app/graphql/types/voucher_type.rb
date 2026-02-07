# frozen_string_literal: true

module Types
  class VoucherType < Types::BaseObject
    field :id, ID, null: false
    field :title, String
    field :discount_code, String
    field :influencer_id, Integer
    field :discount_rate, Float
    field :orders_count, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
