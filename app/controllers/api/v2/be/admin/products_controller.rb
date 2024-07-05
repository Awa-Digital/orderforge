# frozen_string_literal: true

# for Backend Authorization
module Api
  module V2
    module Be
      module Admin
        class ProductsController < Api::V2::Be::Admin::BaseController
          before_action :set_product, except: [:new]

          def new
            @product = Product.new(product_params)
            @product.image = make_image(product_params[:image], @product.title) if product_params[:image].present?
            if @product.save
              success({ data: @product })
            else
              unprocessable({ errors: @product.errors })
            end
          end

          def update
            if product_params[:image].present?
              @product.image = make_image(product_params[:image], @product.title)
              @product.save
            end

            if @product.update(product_params.except(:image))
              success({ data: @product })
            else
              unprocessable({ errors: @product.errors })
            end
          end

          def remove
            @product.archive!
            success({ data: @product })
          end

          private

          def product_params
            params.require(:product).permit(:title, :description, :image, :amount, :category_id, :subcategory_id, :start_time, :end_time)
          end

          def set_product
            @product = Product.find_by(id: params[:id])
            notfound({ resource: "product" }) if @product.nil?
          end
        end
      end
    end
  end
end
