# frozen_string_literal: true

class OAuthUserService
  def self.for(provider:, id_token:, name: nil)
    case provider.to_s
    when 'google'
      GoogleOAuthUserService.new(id_token: id_token, name: name)
    when 'apple'
      AppleOAuthUserService.new(id_token: id_token, name: name)
    else
      raise ArgumentError, "Unsupported OAuth provider: #{provider}"
    end
  end

  def initialize(id_token:, name: nil)
    @id_token = id_token
    @name = name
  end

  def call
    payload = verify_token!
    find_or_create_user(payload)
  end

  private

  def verify_token!
    raise NotImplementedError
  end

  def find_or_create_user(payload)
    identity = AuthIdentity.find_or_initialize_by(provider: provider_name, uid: payload[:uid])
    user = identity.user || User.find_by(email: payload[:email]) || build_user(payload)

    User.transaction do
      user.save!(validate: false) if user.new_record?
      user.save! if user.changed? && !user.new_record?
      identity.user = user
      identity.info = payload.stringify_keys
      identity.save!
    end

    user
  end

  def build_user(payload)
    names = split_name(payload[:name] || payload[:email])
    password = SecureRandom.base58(16)
    User.new(
      email: payload[:email],
      first_name: names[:first],
      last_name: names[:last],
      phone_number: placeholder_phone,
      password: password,
      password_confirmation: password
    )
  end

  def split_name(name)
    parts = name.to_s.split(' ', 2)
    { first: parts[0].presence || 'User', last: parts[1].presence || 'Account' }
  end

  def placeholder_phone
    "234#{SecureRandom.random_number(10**10).to_s.rjust(10, '0')}"[0, 13]
  end

  def provider_name
    self.class.name.delete_suffix('OAuthUserService').downcase
  end
end
