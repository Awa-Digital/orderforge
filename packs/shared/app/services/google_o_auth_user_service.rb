# frozen_string_literal: true

class GoogleOAuthUserService < OAuthUserService
  private

  def verify_token!
    if defined?(Google::Auth::IDTokens) && ENV['GOOGLE_CLIENT_ID'].present?
      payload = Google::Auth::IDTokens.verify_oidc(@id_token, aud: ENV['GOOGLE_CLIENT_ID'])
      {
        uid: payload['sub'],
        email: payload['email'],
        name: @name || payload['name'],
        picture: payload['picture']
      }
    else
      decode_jwt_payload
    end
  end

  def decode_jwt_payload
    segment = @id_token.to_s.split('.')[1]
    raise ArgumentError, 'Invalid token' if segment.blank?

    payload = JSON.parse(Base64.urlsafe_decode64(segment + '=' * ((4 - segment.length % 4) % 4)))
    {
      uid: payload['sub'],
      email: payload['email'],
      name: @name || payload['name'],
      picture: payload['picture']
    }
  end
end
