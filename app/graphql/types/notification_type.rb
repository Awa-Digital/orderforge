# frozen_string_literal: true

module Types
  class NotificationType < Types::BaseObject
    field :id, ID, null: false
    field :title, String
    field :body, String
    field :image, String
    field :analytics_label, String
    field :user_id, Integer
    field :seen, Boolean
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :order_reference, Integer
    field :notification_type, String
  end
end
