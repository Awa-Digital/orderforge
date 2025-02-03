# User Managment
class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_user, except: %i[show update disable update_avatar]

  def signup
    @user = User.new(user_params)
    @user.email = user_params[:email].downcase.gsub(' ', '')
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    begin
      @user.save!
    rescue StandardError
      unprocessable({ message: "Something went wrong while creating account", data: @user.errors })
    else
      assign_token_to_user(@user)
    end
  end

  def verify_account
    account = AccountVerification.find_or_initialize_by(email: params[:email], phone: params[:phone_number])
    if account.valid_account?
      if account.save
        account.deliver_otp
        success({ message: "OTP has been sent to the phone number '+#{params[:phone_number]}'" })
      else
        unprocessable({ message: 'phone number or email has already been taken', data: account.errors })
      end
    else
      compose_verification_taken_error(account)
    end
  end

  def verify_email
    account = AccountVerification.find_by(email_token: params[:token])
    return unless account.user.present? && account.user.email == account.email

    if account.email_verified
      success({ message: 'Your email has already been verified' })
    else
      account.update_attribute :email_verified, true
      success({ message: 'Your email has been verified' })
    end
  end

  def compose_verification_taken_error(account)
    email_issue = 'Email' unless account.valid_email?
    phone_issue = 'Phone' unless account.valid_phone?
    error = [email_issue, phone_issue].compact.join(', ')
    duplicate({ message: "#{error} is already taken" })
  end

  def assign_token_to_user(user)
    @token = generate_auth_token(user)
    success({ message: "#{user.first_name}, welcome to Jazzy's Juicy Burger!",
              data: { user:, auth: { token: @token } } })
  end

  def login
    @user = User.find_by(email: params[:email].downcase.gsub(' ', ''))
    if @user
      log_user_in(@user)
    else
      unauthorized({ message: 'invalid username, email or password' })
    end
  end

  def log_user_in(user)
    if user.authenticate(params[:password])
      if user.inactive
        shout('Deleted Account')
        unauthorized({ message: 'invalid username, email or password' })
      else
        assign_token_to_user(user)
      end
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

  def update_avatar
    shout('updating avatar')
    if @mobile_user.update_attribute :avatar, make_image(params[:avatar])
      success({ message: 'Avatar updated successfully', data: @mobile_user })
    else
      unprocessable({ message: 'Avatar did not update' })
    end
  end

  def request_password_reset
    @user = User.find_by(email: params[:email].downcase.gsub(' ', ''))
    return notfound({ message: "No user with this email found" }) unless @user

    @user.create_password_reset_token unless @user.password_reset_token.present?
    @user.update_password_reset_token if @user.password_reset_token.present?
    @user.deliver_reset_password_email

    success({
              message: 'if you are a registered user, you will get an email with instructions on how to reset your password'
            })
  end

  def reset_password
    @token = PasswordResetToken.find_by(token: params[:token])
    if @token&.valid!
      if @token.user.update(password: params[:password],
                            password_confirmation: params[:password_confirmation])
        @token.expire
        success({ message: 'Password reset complete' })
      else
        @token.expire unless @token.valid?
        unprocessable({ message: "Password's don't match" })
      end
    else
      unauthorized({ message: 'Password reset token expired or invalid, request new password reset instructions.' })
    end
  end

  def disable
    @mobile_user.update_attribute :active, false
    success({ message: 'Account had been disabled' })
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation,
                                 :phone_otp, :avatar)
  end
end
# rubocop:enable Metrics/ClassLength
