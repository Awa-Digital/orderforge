# frozen_string_literal: true

module Types
  class DeliveryAreaType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :day_rate, Float
    field :dusk_rate, Float
    field :night_rate, Float
    field :dawn_rate, Float
    field :region_id, Integer
  end
end
