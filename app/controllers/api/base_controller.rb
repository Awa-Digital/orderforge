# frozen_string_literal: true

module Api
  # API base controller
  class BaseController < ApplicationController
    def generate_auth_token(user)
      secret = ENV.fetch('SECRET_KEY_BASE', nil)
      # user.user_activities.create(ip: remote_ip, device_type: request_device, fingerprint: fingerprint)
      @token = JWT.encode({
                            user_id: user.id,
                            first_name: user.first_name,
                            last_name: user.last_name,
                            email: user.email,
                            phone: user.phone_number,
                            avatar: user.avatar,
                            exp: (Time.current + 1.month).to_i
                          }, secret)
    end

    def generate_influencer_token(user)
      secret = ENV.fetch('SECRET_KEY_BASE', nil)
      # user.user_activities.create(ip: remote_ip, device_type: request_device, fingerprint: fingerprint)
      @token = JWT.encode({
                            id: user.id,
                            name: user.name,
                            email: user.email,
                            phone: user.phone_number,
                            exp: (Time.current + 1.month).to_i
                          }, secret)
    end

    def make_image(imagex, file_name = "uploaded-file")
      image_data = imagex.sub(/.*?,/, '')
      decoded_bytes = Base64.decode64(image_data) # Decode Base64

      # Get file format using RMagick
      img = Magick::Image.from_blob(decoded_bytes).first
      extension = img.format.downcase # Ensure lowercase file extension

      # Save file with detected extension
      new_file = File.open("#{file_name}.#{extension}", 'wb')
      new_file.write(decoded_bytes)

      new_file
    end
  end
end
