# frozen_string_literal: true

module FranchiseAuthentication
  def authenticate
    authorization_header = request.headers[:authorization]
    return unauthorized({ message: I18n.t('missing_header') }) unless authorization_header

    begin
      decode_and_authenticate(authorization_header.split[1], ENV.fetch('SECRET_KEY_BASE', nil))
    rescue JWT::ExpiredSignature
      unauthorized({ message: I18n.t('expired_session') })
    rescue StandardError
      unauthorized({ message: I18n.t('invalid', data: 'token') })
    end
  end

  def decode_and_authenticate(token, secret)
    decoded_token = JWT.decode(token, secret)
    authenticate_token(decoded_token)
  end

  def authenticate_token(token)
    user = AdminUser.find_by(id: token[0]['id'].to_i)
    return unauthorized({ message: I18n.t('not_found', data: "Admin") }) unless user
    return unauthorized({ message: I18n.t('not_found', data: "Admin") }) unless user.active?

    @admin = @current_user = user
  end
end
