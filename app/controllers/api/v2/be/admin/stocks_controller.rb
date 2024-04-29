# frozen_string_literal: true

# for Backend Authorization
module Api
  module V2
    module Be
      module Admin
        class StocksController < Api::V2::Be::Admin::BaseController
          before_action :set_stock, except: [:new]

          def new
            @stock = Stock.new(stock_params)

            if @stock.save
              success({ data: @stock })
            else
              unprocessable({ errors: @stock.errors })
            end
          end

          def update
            if @stock.update(stock_params)
              success({ data: @stock })
            else
              unprocessable({ errors: @stock.errors })
            end
          end

          def remove
            @stock.archive!
            success({ data: @stock })
          end

          private

          def stock_params
            params.require(:stock).permit(:code, :name, :description, :state, :expires)
          end

          def set_stock
            @stock = Stock.find_by(id: params[:id])
            notfound({ resource: "stock" }) if @stock.nil?
          end
        end
      end
    end
  end
end
