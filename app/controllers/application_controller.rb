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

  def authenticate_user
    authorization_header = request.headers[:authorization]
    if !authorization_header
      unauthorized({ message: 'Authorization Absent!' })
    else
      token = authorization_header.split(' ')[1]
      secret_key = ENV['SECRET_KEY_BASE'] || Rails.application.secrets.secret_key_base
      begin
        decoded_token = JWT.decode(token, secret_key)
        current_user = User.find(decoded_token[0]['user_id'])
        if !current_user
          unauthorized({ message: 'User not found' })
        else
          @mobile_user = current_user
        end
      rescue JWT::ExpiredSignature
        unauthorized({ message: 'Your session has expired' })
      rescue StandardError
        unauthorized({ message: 'Invalid token' })
      end
    end
  end

  def authenticate_guest
    authorization_header = request.headers[:authorization]
    if !authorization_header
      @mobile_user = nil
    else
      authenticate_user
    end
  end
end
