class Api::V1::ProductsController < Api::V1::BaseController
  def index
    @products = Product.all
    success({ message: 'products fetched successfully', data: @products })
  end

  def show
    @product = Product.find_by(id: params[:id])
    if @product.present?
      success({ message: 'product found', data: @product })
    else
      notfound({ message: 'No product found with this id' })
    end
  end
end
