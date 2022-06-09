class Api::BaseController < ApplicationController
  def generate_auth_token(user)
    secret = ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base
    # user.user_activities.create(ip: remote_ip, device_type: request_device, fingerprint: fingerprint)
    @token = JWT.encode({
                          user_id: user.id,
                          first_name: user.first_name,
                          last_name: user.last_name,
                          email: user.email,
                          phone: user.phone_number,
                          exp: (Time.now + 1.month).to_i
                        }, secret)
  end
end
