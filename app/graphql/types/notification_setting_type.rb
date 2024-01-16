# frozen_string_literal: true

module Types
  class NotificationSettingType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :push_notifications, Boolean
    field :app_updates, Boolean
    field :promotions, Boolean
    field :receipts, Boolean
    field :newsletter, Boolean
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
