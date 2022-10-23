# User Managment
class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_user, except: %i[show update]

  def signup
    user = User.new(user_params)
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    begin
      user.save!
    rescue StandardError => e
      unprocessable({ message: e.message, data: user.errors })
    else
      assign_token_to_user(user)
    end
  end

  def assign_token_to_user(user)
    @token = generate_auth_token(user)
    success({ message: "#{user.first_name}, welcome to Jazzy's Juicy Burger!",
              data: { user: user, auth: { token: @token } } })
  end

  def login
    @user = User.find_by(email: params[:email].downcase.gsub(' ', ''))
    if !@user
      unauthorized({ message: 'invalid username, email or password' })
    else
      log_user_in(@user)
    end
  end

  def log_user_in(_user)
    if @user.authenticate(params[:password])
      assign_token_to_user(@user)
    else
      unauthorized({ message: 'invalid username, email or password' })
    end
  end

  def show
    success({ message: 'user details fetched successfully', data: @mobile_user })
  end

  def update
    @mobile_user.update(user_params)
    success({ message: 'Profile has been updated successfully', data: @mobile_user })
  end

  def request_password_reset
    @user = User.find_by(email: params[:email])
    if @user
      @user.create_password_reset_token unless @user.password_reset_token.present?
      @user.update_password_reset_token if @user.password_reset_token.present?
      success({
                message: 'if you are a registered user, you will get an email with instructions on how to reset your password'
              })
    end
  end

  def reset_password
    @token = PasswordResetToken.find_by(token: params[:token])
    if @token
      if @token.valid! && @token.user.update(password: params[:password],
                                             password_confirmation: params[:password_confirmation])
        @token.expire
        success({ message: 'Password reset complete' })
      else
        @token.expire unless @token.valid?
        unprocessable({ message: "Password's don't match" })
      end
    else
      unauthorized({ message: 'Password reset token not found or expired, request reset again' })
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation)
  end
end
