# for Backend Authorization
module Api
  module V2
    module Be
      module Business
        class AdminUsersController < Api::V2::Be::Business::BaseController
          skip_before_action :authenticate_admin, only: [:login]

          def login
            @user = AdminUser.find_by(email: admin_user_params[:email])
            return unauthorized(message: "Email or Password is invalid") unless @user

            if @user.valid_password?(admin_user_params[:password])
              @token = @user.get_token
              success({ data: { auth: { token: @token }, admin: @user } })
            else
              unauthorized(message: "Email or Password is invalid")
            end
          end

          private

          def admin_user_params
            params.require(:admin_user).permit(:email, :password, :phone, :first_name, :last_name)
          end
        end
      end
    end
  end
end
