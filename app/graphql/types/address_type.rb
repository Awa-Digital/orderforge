# frozen_string_literal: true

module Types
  class AddressType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :street, String
    field :state, String
    field :country, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :house_number, String
    field :delivery_area_id, Integer
  end
end
