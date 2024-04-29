# frozen_string_literal: true

# for Backend Authorization
module Api
  module V2
    module Be
      module Admin
        class OrdersController < Api::V2::Be::Admin::BaseController
          before_action :set_order, except: [:new]

          def new
            @order = Order.new(order_params)
            if @order.save
              success({ data: @order })
            else
              unprocessable({ errors: @order.errors })
            end
          end

          def update
            if @order.update(order_update_params)
              success({ data: @order })
            else
              unprocessable({ errors: @order.errors })
            end
          end

          def remove
            @order.archive!
            success({ data: @order })
          end

          private

          def order_params
            params.require(:order).permit(
              :user_id, :recipient_name, :recipient_email, :recipient_phone, :address_id,
              order_items_attributes: [:product_id, :quantity]
            )
          end

          def order_update_params
            params.require(:order).permit(:status, :address_id, :paid, :recipient_name, :recipient_email, :recipient_phone)
          end

          def set_order
            @order = Order.find_by(id: params[:id])
            notfound({ resource: "order" }) if @order.nil?
          end
        end
      end
    end
  end
end
