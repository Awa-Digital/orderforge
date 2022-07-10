class Api::V1::ProductsController < Api::V1::BaseController
  before_action :set_product, only: %i[show like unlike]
  before_action :set_products, only: %i[index grouped search]
  skip_before_action :authenticate_user, only: %i[index show search]
  before_action :authenticate_guest, only: %i[index show search]

  def index
    success({ message: 'products fetched successfully', data: @products })
  end

  def grouped
    @products = if @mobile_user.present?
                  @mobile_user.products
                else
                  Product.all
                end
    render 'grouped'
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
    @products = @products.ransack(params[:q]).result(distinct: true).page(params[:page]).per(params[:per_page])
    results = {
      products: @products, total_results: @products.count, results_per_page: @products.limit_value, total_pages: @products.total_pages,
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
    @products = if @mobile_user.present?
                  @mobile_user.products
                else
                  Product.all
                end
  end
end
