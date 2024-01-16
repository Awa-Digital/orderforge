# frozen_string_literal: true

module Types
  class RemovableType < Types::BaseObject
    field :id, ID, null: false
    field :order_item_id, Integer, null: false
    field :ingredient_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
