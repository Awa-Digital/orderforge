# frozen_string_literal: true

# for Backend Authorization
module Api
  module V1
    module Be
      # Operations on Orders
      class OrdersController < Api::V1::Be::BaseController
        before_action :set_order, except: %i[index filter pending search filtered_search]
        def index
          @all_orders = Order.all
          @orders = @all_orders.page(params[:page]).per(params[:per_page])
          paginate_orders
        end

        def filter
          @all_orders = Order.where(status: params[:status])
          @orders = @all_orders.page(params[:page]).per(params[:per_page])
          paginate_orders
        end

        def search
          @q = Order.search(reference_or_recipient_email_or_recipient_phone_or_recipient_name_cont: params[:q])
          @all_orders = @q.result(distinct: true)
          @orders = @all_orders.page(params[:page]).per(params[:per_page])
          paginate_orders
        end

        def filtered_search
          @q = Order.where(status: params[:status]).search(reference_or_recipient_email_or_recipient_phone_or_recipient_name_cont: params[:q])
          @all_orders = @q.result(distinct: true)
          @orders = @all_orders.page(params[:page]).per(params[:per_page])
          paginate_orders
        end

        def pending
          Order.update_priorities
          @orders = Order.where(status: 'paid').where(paid: true).order(priority: :asc)
          success({ message: 'orders fetched', data: @orders })
        end

        def mark_as_accepted
          @order.update(status: 'awaiting_processing')
          success({ message: 'accepted order', data: @order })
        end

        def mark_as_processing
          @order.update(status: 'processing')
          success({ message: 'marked as processing', data: @order })
        end

        def mark_as_awaiting_packaging
          @order.update(status: 'awaiting_packaging')
          success({ message: 'marked as awaiting packaging', data: @order })
        end

        def mark_as_packaged
          @order.update(status: 'packaged')
          success({ message: 'marked as packaged', data: @order })
        end

        def mark_as_delivering
          @order.update(status: 'delivering')
          success({ message: 'marked as delivering', data: @order })
        end

        def mark_as_completed
          @order.update(status: 'completed')
          success({ message: 'marked as completed', data: @order })
        end

        def download_pdf
          pdf = @order.generate_pdf_receipt
          send_data File.open(pdf).read, filename: "#{@order.reference}.pdf", type: 'application/pdf', disposition: 'attachment'
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
