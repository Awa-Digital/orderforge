# frozen_string_literal: true

module Responses
  def success(data)
    render json: {
      status: 'success',
      message: data[:message] || I18n.t('success'),
      data: data[:data]
    }, status: 200
  end

  def unprocessable(data)
    render json: {
      status: 'unprocessable',
      message: data[:message] || I18n.t('unprocessed'),
      data: data[:errors] || data[:data]
    }, status: :unprocessable_entity
  end

  def unauthorized(data)
    render json: {
      status: 'unauthorized',
      message: data[:message] || I18n.t('unauthorized'),
      data: data[:data]
    }, status: :unauthorized
  end

  def conflict(data)
    render json: {
      status: 'conflicting',
      message: data[:message] || I18n.t('conflict')
    }, status: 409
  end

  def duplicate(data)
    render json: {
      status: 'conflict',
      message: data[:message] || I18n.t('conflict'),
      data: data[:data]
    }, status: 409
  end

  def notfound(data)
    render json: {
      status: 'not found',
      message: data[:message] || I18n.t('not_found', data: data[:resource]),
      data: data[:data]
    }, status: :not_found
  end

  def bad_request(data)
    render json: {
      status: 'bad request',
      message: data[:message] || I18n.t('bad_request'),
      data: data[:data]
    }, status: :bad_request
  end

  def server_error(data)
    render json: {
      status: 'Server error',
      message: data[:message] || I18n.t('server_error'),
      data: data[:data]
    }, status: 500
  end

  def payment_required(data)
    render json: {
      status: 'payment required',
      message: data[:message] || I18n.t('payment_required')
    }, status: 402
  end

  def paginate_response(data)
    success({
              message: data[:message] || I18n.t('success'),
              data: {
                data: data[:data],
                pagination: {
                  total: @data.excepI18n.t(:limit, :offset).count,
                  current_page: @data.current_page,
                  next_page: @data.next_page,
                  last_page?: @data.last_page?,
                  total_pages: @data.total_pages
                }
              }
            })
  end

  def shout(str)
    liner = '•••••••••••••••••••••••••••••••'
    puts liner
    puts str
    puts liner
  end
end
