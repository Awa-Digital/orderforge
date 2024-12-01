# frozen_string_literal: true

module Api
  module V1
    class ProductsController < Api::V1::BaseController
      before_action :set_product, only: %i[show like unlike]
      before_action :set_products, only: %i[index grouped search]
      skip_before_action :authenticate_user, only: %i[index categories hot_deals grouped show search]
      before_action :authenticate_guest, only: %i[index hot_deals categories grouped show search]
      before_action :set_cart

      def index
        render "products"
      end

      def categories
        success({ message: 'categories fetched successfully', data: Category.all })
      end

      def grouped
        @products = if @mobile_user.present?
                      @mobile_user.products
                    else
                      Product.all.select(&:available)
                    end
        render 'grouped'
      end

      def hot_deals
        @products = Product.hot_products(:all_time).first(8)
        @message = 'hot deals fetched successfully'
        render "products"
      end

      def show
        render 'show'
      end

      def like
        @product.like(@mobile_user)
        success({ message: 'liked!', data: @mobile_user.product(@product.id) })
      end

      def favourites
        @products = @mobile_user.favourites
        @message = 'favorites fetched successfully'
        render 'products'
      end

      def unlike
        @product.unlike(@mobile_user)
        success({ message: 'disliked!', data: @mobile_user.product(@product.id) })
      end

      def search
        product_ids = @products.map(&:id)
        scoped_products = Product.where(id: product_ids)
        @products = scoped_products.ransack(params[:q]).result(distinct: true).page(params[:page]).per(params[:per_page])
        @message = "products found"
        render 'search'
      end

      private

      def set_product
        @product = Product.find_by(id: params[:id])
        if @product.present?
          if @mobile_user.present?
            @product = @mobile_user.product(@product.id)
          else
            @product
          end
        else
          notfound({ message: 'No product found with this id' })
        end
      end

      def set_products
        products = if @mobile_user.present?
                     @mobile_user.products
                   else
                     Product.all.select(&:available)
                   end

        products = filter_by_category(products) if params[:category_id].present?
        products = filter_by_price_range(products) if params[:min_price].present? || params[:max_price].present?
        products = sort_by_price(products) if params[:sort_by].present?

        @products = products
      end

      def set_cart
        @cart = if @mobile_user.present?
                  puts @mobile_user.cart.id
                  @mobile_user.cart
                else
                  @order = Order.find_by(id: params[:order_id])
                  create_or_find_order(@order)
                end
      end

      def create_or_find_order(order)
        return nil unless order.present?
        return nil unless order.status == 'initiated'

        order
      end

      def filter_by_category(products)
        products.select { |product| product.category_id == params[:category_id].to_i }
      end

      def filter_by_price_range(products)
        start_price = params[:min_price].present? ? params[:min_price].to_f : -Float::INFINITY
        end_price = params[:max_price].present? ? params[:max_price].to_f : Float::INFINITY

        products.select { |product| product.amount >= start_price && product.amount <= end_price }
      end

      def sort_by_price(products)
        sort_order = params[:sort_by].casecmp('asc').zero? ? :asc : :desc

        products.sort_by!(&:amount)
        products.reverse! if sort_order == :desc
        products
      end
    end
  end
end
