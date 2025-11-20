# frozen_string_literal: true

class AppleOAuthUserService < OAuthUserService
  private

  def verify_token!
    decode_jwt_payload
  end

  def decode_jwt_payload
    segment = @id_token.to_s.split('.')[1]
    raise ArgumentError, 'Invalid token' if segment.blank?

    payload = JSON.parse(Base64.urlsafe_decode64(segment + '=' * ((4 - segment.length % 4) % 4)))
    {
      uid: payload['sub'],
      email: payload['email'] || "#{payload['sub']}@privaterelay.appleid.com",
      name: @name || 'Apple User'
    }
  end
end
