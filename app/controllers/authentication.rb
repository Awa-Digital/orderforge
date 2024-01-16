# frozen_string_literal: true

module Authentication
  def authenticate_user
    authorization_header = request.headers[:authorization]
    if authorization_header
      token = authorization_header.split[1]
      secret_key = ENV.fetch('SECRET_KEY_BASE', nil)
      begin
        decoded_token = JWT.decode(token, secret_key)
        current_user = User.find(decoded_token[0]['user_id'])
        if !current_user
          unauthorized({ message: 'User not found' })
        elsif current_user.active
          Sentry.set_user(username: current_user.full_name, email: current_user.email, id: current_user.id)
          @mobile_user = current_user
        elsif current_user.inactive
          shout('deleted account')
          unauthorized({ message: 'User not found' })
        end
      rescue JWT::ExpiredSignature
        unauthorized({ message: 'Your session has expired' })
      rescue StandardError
        unauthorized({ message: 'Invalid token' })
      end
    else
      unauthorized({ message: 'Authorization Absent!' })
    end
  end

  def authenticate_guest
    authorization_header = request.headers[:authorization]
    if authorization_header
      authenticate_user
    else
      @mobile_user = nil
    end
  end
end
