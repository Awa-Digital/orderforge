# frozen_string_literal: true

# for Backend Authorization
module Api
  module V2
    module Be
      module Admin
        class UsersController < Api::V2::Be::Admin::BaseController
          before_action :set_user, except: [:new, :search]

          def search
            search_for_model(User, params[:page], params[:per_page])
          end

          def new
            @account_verification = AccountVerification.create(phone: user_params[:phone_number], email: user_params[:email])
            @user = User.new(user_params)
            @user.phone_otp = @account_verification.otp
            if @user.save
              success({ data: @user })
            else
              unprocessable({ errors: @user.errors })
            end
          end

          def update
            if @user.update(user_update_params)
              success({ data: @user })
            else
              unprocessable({ errors: @user.errors })
            end
          end

          def remove
            @user.archive!
            success({ data: @user })
          end

          private

          def user_params
            params.require(:user).permit(:first_name, :last_name, :avatar, :email, :phone_number, :phone_number, :active)
          end

          def user_update_params
            params.require(:user).permit(:first_name, :last_name, :avatar, :active)
          end

          def set_user
            @user = User.find_by(id: params[:id])
            notfound({ resource: "user" }) if @user.nil?
          end
        end
      end
    end
  end
end
