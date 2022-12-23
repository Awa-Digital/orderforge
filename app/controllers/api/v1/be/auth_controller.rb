# frozen_string_literal: true

# for Backend Authorization
module Api
  module V1
    module Be
      # Authenticating operations
      class AuthController < Api::V1::Be::BaseController
        skip_before_action :authenticate_token, only: [:login]

        def login
          @user = Auth.find_by(email: params[:email])
          return unauthorized({ message: 'account does not exist' }) unless @user
          return unauthorized({ message: 'incorrect account/password' }) unless @user.authenticate(params[:password])

          assign_auth_token(@user)
        end

        def assign_auth_token(user)
          @token = generate_auth_token(user)
          success({ message: 'Authenticated',
                    data: { auth: { token: @token, available_statuses: user.available_statuses, account_type: user.account_type } } })
        end

        def generate_auth_token(user)
          secret = ENV['SECRET_KEY_BASE']
          @token = JWT.encode({
                                auth_id: user.id,
                                email: user.email,
                                phone: user.phone,
                                exp: (Time.now + 1.month).to_i
                              }, secret)
        end
      end
    end
  end
end
