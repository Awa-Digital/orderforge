# frozen_string_literal: true

# for Backend Authorization
module Api
  module V1
    module Be
      # Operations on Orders
      class OrdersController < Api::V1::Be::BaseController
        before_action :set_order, only: %i[mark_as_processing mark_as_completed mark_as_delivering]
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

        def mark_as_processing
          @order.update_attribute :status, 'processing'
          success({ message: 'marked as processing', data: @order })
        end

        def mark_as_delivering
          @order.update_attribute :status, 'delivering'
          success({ message: 'marked as delivering', data: @order })
        end

        def mark_as_completed
          @order.update_attribute :status, 'completed'
          success({ message: 'marked as completed', data: @order })
        end

        private

        def set_order
          @order = Order.find_by(id: params[:order_id])
          return notfound({ message: 'order not found' }) unless @order
        end
      end
    end
  end
end
