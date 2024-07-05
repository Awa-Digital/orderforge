# frozen_string_literal: true

module Types
  class InventoryType < Types::BaseObject
    field :id, ID, null: false
    field :code, String
    field :name, String
    field :description, String
    field :state, String
    field :expires, Boolean
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :status, String
  end
end
