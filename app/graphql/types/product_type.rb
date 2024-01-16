# frozen_string_literal: true

module Types
  class ProductType < Types::BaseObject
    field :id, ID, null: false
    field :title, String
    field :description, String
    field :image, String
    field :category_id, Integer
    field :amount, Float
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :liked, Boolean
    field :subcategory_id, Integer
    field :start_time, Integer
    field :end_time, Integer
    field :status, String
  end
end
