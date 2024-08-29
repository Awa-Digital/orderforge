# frozen_string_literal: true

module Types
  class FranchiseAddressType < Types::BaseObject
    field :id, ID, null: false
    field :franchise_id, Integer
    field :region_id, Integer
    field :location_id, Integer
    field :street, String
    field :longitude, String
    field :latitude, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
