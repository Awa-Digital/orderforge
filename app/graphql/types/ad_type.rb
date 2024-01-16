# frozen_string_literal: true

module Types
  class AdType < Types::BaseObject
    field :id, ID, null: false
    field :image, String
    field :title, String
    field :expiration_date, GraphQL::Types::ISO8601Date
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :product_id, Integer
    field :url, String
  end
end
