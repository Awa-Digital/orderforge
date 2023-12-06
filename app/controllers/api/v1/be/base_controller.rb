# frozen_string_literal: true

module Api
  module V1
    module Be
      # operations base controller
      class BaseController < Api::V1::BaseController
        skip_before_action :authenticate_user
        before_action :authenticate_token

        def authenticate_token
          authorization_header = request.headers[:authorization]
          return unauthorized({ message: 'send request with bearer token!' }) unless authorization_header

          begin
            decode_and_validate_token(authorization_header.split[1], ENV.fetch('SECRET_KEY_BASE', nil))
          rescue JWT::ExpiredSignature
            unauthorized({ message: 'Your token has expired' })
          rescue StandardError
            unauthorized({ message: 'Invalid token' })
          end
        end

        def decode_and_validate_token(token, secret_key)
          decoded_token = JWT.decode(token, secret_key)
          current_user = Auth.find(decoded_token[0]['auth_id'])
          return unauthorized({ message: 'user not found' }) unless current_user

          Sentry.set_user(email: current_user.email, id: current_user.id)
          @admin_user = current_user
        end

        def paginate_orders
          success({
                    message: 'orders fetched',
                    data: {
                      orders: @orders.includes(:payment).order("payment.paid_at ASC"),
                      pagination: {
                        total_orders: @all_orders.count,
                        current_page: @orders.current_page,
                        next_page: @orders.next_page,
                        last_page?: @orders.last_page?,
                        total_pages: @orders.total_pages
                      }
                    }
                  })
        end
      end
    end
  end
end
