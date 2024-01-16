# frozen_string_literal: true

module Types
  class FavouriteItemType < Types::BaseObject
    field :id, ID, null: false
    field :favourite_id, Integer
    field :product_id, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :product, Types::ProductType
  end
end
