class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

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
end
