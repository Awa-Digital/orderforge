# frozen_string_literal: true

module Mutations
  class CreateAdminUser < BaseMutation
    argument :email, String
    argument :phone, String
    argument :first_name, String
    argument :last_name, String
    argument :super_user, Boolean
    argument :password_digest, String
    argument :avatar, String
    argument :status, String

    type Types::AdminUserType

    def resolve(**attributes)
      AdminUser.create!(attributes)
    end
  end
end
