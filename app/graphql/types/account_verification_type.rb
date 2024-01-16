# frozen_string_literal: true

module Types
  class AccountVerificationType < Types::BaseObject
    field :id, ID, null: false
    field :phone, String
    field :otp, String
    field :email, String
    field :email_token, String
    field :email_verified, Boolean
    field :phone_verified, Boolean
    field :user_id, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
