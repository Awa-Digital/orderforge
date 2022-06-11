class Api::V1::ProductsController < Api::V1::BaseController
  before_action :set_product, only: %i[show like unlike]
  def index
    @products = @mobile_user.products
    success({ message: 'products fetched successfully', data: @products })
  end

  def show
    success({ message: 'product found', data: @product })
  end

  def like
    @product.like(@mobile_user)
    success({ message: 'liked!', data: @mobile_user.product(@product.id) })
  end

  def unlike
    @product.unlike(@mobile_user)
    success({ message: 'disliked!', data: @mobile_user.product(@product.id) })
  end

  def search
    @products = @mobile_user.products.ransack(params[:q]).result(distinct: true).page(params[:page]).per(params[:per_page])
    results = {
      products: @products,
      total_results: @products.count,
      results_per_page: @products.limit_value,
      total_pages: @products.total_pages,
      next_page: @products.next_page,
      last_page: @products.last_page?
    }
    success({ message: 'products found', data: results })
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
    if @product.present?
      @product = @mobile_user.product(@product.id)
    else
      notfound({ message: 'No product found with this id' })
    end
  end
end
