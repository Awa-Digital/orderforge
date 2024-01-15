# frozen_string_literal: true

module Types
  class AuthType < Types::BaseObject
    field :id, ID, null: false
    field :email, String
    field :phone, String
    field :password_digest, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :account_type, String
  end
end
