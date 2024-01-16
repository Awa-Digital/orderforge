# frozen_string_literal: true

module Types
  class InfluencerType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :instagram_handle, String
    field :twitter_handle, String
    field :email, String
    field :password_digest, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
