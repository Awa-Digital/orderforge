# frozen_string_literal: true

module Types
  class StaffType < Types::BaseObject
    field :id, ID, null: false
    field :franchise_id, Integer
    field :first_name, String
    field :last_name, String
    field :email, String
    field :phone, String
    field :avatar, String
    field :password_digest, String
    field :departments, [Types::DepartmentType]
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
