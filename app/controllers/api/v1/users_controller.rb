# User Managment
class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_user
  def signup
    user = User.new(user_params)
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    begin
      user.save!
    rescue StandardError => e
      unprocessable({ message: e.message, data: user.errors })
    else
      success({ message: 'user successfully signed up', data: user })
    end
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
      @token = generate_auth_token(@user)
      success({ message: 'authorized!', data: { auth: { token: @token } } })
    else
      unauthorized({ message: 'invalid username, email or password' })
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
