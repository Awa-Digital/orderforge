# frozen_string_literal: true

# for Backend Authorization
module Api
  module V1
    module Be
      # Operations on Orders
      class OrdersController < Api::V1::Be::BaseController
        def index
          @orders = Order.all
          success({ message: 'orders fetched', data: @orders })
        end

        def filter
          @orders = Order.where(status: params[:status])
          success({ message: 'orders fetched', data: @orders })
        end

        def pending
          Order.update_priorities
          @orders = Order.where(status: 'paid').where(paid: true).order(priority: :asc)
          success({ message: 'orders fetched', data: @orders })
        end
      end
    end
  end
end
