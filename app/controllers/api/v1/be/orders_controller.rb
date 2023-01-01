# frozen_string_literal: true

# for Backend Authorization
module Api
  module V1
    module Be
      # Operations on Orders
      class OrdersController < Api::V1::Be::BaseController
        before_action :set_order, except: %i[index filter pending]
        def index
          @all_orders = Order.all
          @orders = @all_orders.page(params[:page]).per(params[:per_page])
          paginate_orders
        end

        # rubocop:disable Metrics/MethodLength
        def paginate_orders
          success({
            message: 'orders fetched',
            data: {
              orders: @orders,
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
        # rubocop:enable Metrics/MethodLength

        def filter
          @all_orders = Order.where(status: params[:status])
          @orders = @all_orders.page(params[:page]).per(params[:per_page])
          paginate_orders
        end

        def pending
          Order.update_priorities
          @orders = Order.where(status: 'paid').where(paid: true).order(priority: :asc)
          success({ message: 'orders fetched', data: @orders })
        end

        def mark_as_accepted
          @order.update_attribute :status, 'awaiting_processing'
          success({ message: 'accepted order', data: @order })
        end

        def mark_as_processing
          @order.update_attribute :status, 'processing'
          success({ message: 'marked as processing', data: @order })
        end

        def mark_as_awaiting_packaging
          @order.update_attribute :status, 'awaiting_packaging'
          success({ message: 'marked as awaiting packaging', data: @order })
        end

        def mark_as_packaged
          @order.update_attribute :status, 'packaged'
          success({ message: 'marked as packaged', data: @order })
        end

        def mark_as_delivering
          @order.update_attribute :status, 'delivering'
          success({ message: 'marked as delivering', data: @order })
        end

        def mark_as_completed
          @order.update_attribute :status, 'completed'
          success({ message: 'marked as completed', data: @order })
        end

        def verify
          @order.verify
          success({ message: 'verification complete', data: @order })
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
