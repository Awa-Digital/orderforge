# frozen_string_literal: true

# for Backend Authorization
module Api
  module V2
    module Be
      module Franchise
        class AuthController < Api::V2::Be::Franchise::BaseController
          # skip_before_action :authenticate_admin, only: [:login]

          # def login
          #   @user = AdminUser.find_by(email: admin_user_params[:email])
          #   return unauthorized({ message: 'account does not exist' }) unless @user
          #   return unauthorized({ message: 'incorrect account/password' }) unless @user.authenticate(admin_user_params[:password])

          #   assign_auth_token(@user)
          # end

          # def assign_auth_token(user)
          #   @token = generate_auth_token(user)
          #   success({ message: 'Authenticated',
          #             data: { auth: { token: @token } } })
          # end

          # def generate_auth_token(user)
          #   secret = ENV.fetch('SECRET_KEY_BASE', nil)
          #   @token = JWT.encode({
          #                         id: user.id,
          #                         email: user.email,
          #                         phone: user.phone,
          #                         exp: (Time.now + 1.month).to_i
          #                       }, secret)
          # end

          # private

          # def admin_user_params
          #   params.require(:admin_user).permit(:email, :password)
          # end
        end
      end
    end
  end
end
