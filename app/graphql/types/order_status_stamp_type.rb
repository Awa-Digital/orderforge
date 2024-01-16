# frozen_string_literal: true

module Types
  class OrderStatusStampType < Types::BaseObject
    field :id, ID, null: false
    field :auth_id, Integer
    field :order_id, Integer
    field :message, String
    field :action, String
    field :action_name, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
