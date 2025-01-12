# frozen_string_literal: true

module Types
  class AdminUserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String
    field :phone, String
    field :first_name, String
    field :last_name, String
    field :super_user, Boolean
    # field :password_digest, String
    field :avatar, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :status, String
  end
end
