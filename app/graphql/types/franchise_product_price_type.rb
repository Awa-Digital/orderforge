# frozen_string_literal: true

module Types
  class FranchiseProductPriceType < Types::BaseObject
    field :id, ID, null: false
    field :franchise_id, Integer
    field :product_id, Integer
    field :amount, Float
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
