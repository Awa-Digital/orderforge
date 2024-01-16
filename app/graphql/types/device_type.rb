# frozen_string_literal: true

module Types
  class DeviceType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer
    field :build_number, String
    field :device_token, String
    field :device_name, String
    field :serial_number, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
