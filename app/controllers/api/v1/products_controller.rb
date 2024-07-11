# frozen_string_literal: true

module Api
  module V1
    class ProductsController < Api::V1::BaseController
      before_action :set_product, only: %i[show like unlike]
      before_action :set_products, only: %i[index grouped search]
      skip_before_action :authenticate_user, only: %i[index categories hot_deals grouped show search]
      before_action :authenticate_guest, only: %i[index hot_deals categories grouped show search]

      def index
        success({ message: 'products fetched successfully', data: @products })
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
        @hot_deals = Product.where(id: Product.select(&:available).pluck(:id)).order(created_at: :desc).limit(8)
        # @hot_deals = if Order.limit(5).joins(:order_items).pluck(:product_id).uniq.count > 5
        #                Product.find(Order.where(status: 'paid').limit(5).joins(:order_items).pluck(:product_id).uniq).select(&:available)
        #              else
        #                Product.where(id: Product.select(&:available).pluck(:id).sample(5))
        #              end
        success({ message: 'hot deals fetched successfully', data: @hot_deals })
      end

      def show
        success({ message: 'product found', data: @product })
      end

      def like
        @product.like(@mobile_user)
        success({ message: 'liked!', data: @mobile_user.product(@product.id) })
      end

      def favourites
        @products = @mobile_user.favourites
        success({ message: 'favorites fetched successfully', data: @products })
      end

      def unlike
        @product.unlike(@mobile_user)
        success({ message: 'disliked!', data: @mobile_user.product(@product.id) })
      end

      def search
        product_ids = @products.map(&:id)
        scoped_products = Product.where(id: product_ids)
        @products = scoped_products.ransack(params[:q]).result(distinct: true).page(params[:page]).per(params[:per_page])

        results = {
          products: @products, total_results: @products.count,
          results_per_page: @products.limit_value,
          total_pages: @products.total_pages,
          next_page: @products.next_page, last_page: @products.last_page?
        }
        success({ message: 'products found', data: results })
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
