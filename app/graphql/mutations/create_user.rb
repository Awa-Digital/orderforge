# frozen_string_literal: true

module Mutations
  class CreateUser < BaseMutation
    description "Register a new user"
    argument :first_name, String
    argument :last_name, String
    argument :email, String
    argument :phone_number, String
    argument :password, String
    argument :password_confirmation, String
    argument :avatar, String

    type Types::UserType

    def resolve(**attributes)
      User.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
