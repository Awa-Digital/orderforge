# frozen_string_literal: true

module Types
  class OrderAddressType < Types::BaseObject
    field :id, ID, null: false
    field :order_id, Integer, null: false
    field :house_number, String
    field :street, String
    field :city, String
    field :state, String
    field :country, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :delivery_area_id, Integer
  end
end
