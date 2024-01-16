# frozen_string_literal: true

module Types
  class RatingType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :product_id, Integer, null: false
    field :rating, Float
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
