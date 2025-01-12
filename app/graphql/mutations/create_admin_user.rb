# frozen_string_literal: true

module Mutations
  class CreateAdminUser < BaseMutation
    description "Create an account that can access this graphql resource and the admin dashboard!"

    argument :email, String
    argument :phone, String
    argument :first_name, String
    argument :last_name, String
    argument :super_user, Boolean
    # argument :password_digest, String
    argument :avatar, String
    argument :status, String

    type Types::AdminUserType

    def resolve(**attributes)
      AdminUser.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
