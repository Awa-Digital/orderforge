# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate_user

  def success(data)
    render json: {
      status: 'success',
      message: data[:message],
      data: data[:data]
    }, status: 200
  end

  def unauthorized(data)
    render json: {
      status: 'unauthorized',
      message: data[:message],
      data: data[:data]
    }, status: :unauthorized
  end

  def unprocessable(data)
    render json: {
      status: 'unprocessable',
      message: data[:message],
      data: data[:data]
    }, status: 422
  end

  def duplicate(data)
    render json: {
      status: 'conflict',
      message: data[:message],
      data: data[:data]
    }, status: 409
  end

  def notfound(data)
    render json: {
      status: 'Not Found',
      message: data[:message],
      data: data[:data]
    }, status: 404
  end

  def server_error(data)
    render json: {
      status: 'Server error',
      message: data[:message],
      data: data[:data]
    }, status: 500
  end

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

  def shout(str)
    puts "############ #{str} ############"
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
