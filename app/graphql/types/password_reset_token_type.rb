# frozen_string_literal: true

module Types
  class PasswordResetTokenType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer
    field :token, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
