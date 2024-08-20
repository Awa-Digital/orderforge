# frozen_string_literal: true

module Types
  class ProductInventoryItemType < Types::BaseObject
    field :id, ID, null: false
    field :product_id, Integer
    field :inventory_id, Integer
    field :quantity, Float
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
