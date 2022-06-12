class Api::V1::OrdersController < Api::V1::BaseController
  before_action :set_product, only: %i[add update remove]

  def cart
    @cart = @mobile_user.cart
    @items = @cart.items.order(created_at: :desc)
    @message = 'Cart Fetched!'
    render 'cart'
  end

  def add
    @cart = @mobile_user.cart
    @item = @cart.items.find_or_create_by(product_id: @product.id)
    @item.quantity = @item.quantity + params[:quantity].to_i
    begin
      @item.save
    rescue StandardError => e
      unprocessable({ message: e.message, data: @item.errors })
    else
      success({ message: 'item has been added to cart', data: @item })
    end
  end

  def update
    @cart = @mobile_user.cart
    @item = @cart.items.find_by(product_id: @product.id)
    if @item.present?
      @item.update(quantity: params[:quantity].to_i)
      success({ message: 'item has been updated on cart', data: @item })
    else
      notfound({ message: 'No product found with this id' })
    end
  end

  def remove
    @cart = @mobile_user.cart
    @item = @cart.items.find_by(product_id: @product.id)
    if @item.present?
      @item.destroy
      success({ message: 'item has been removed from cart', data: @item })
    else
      notfound({ message: 'No product found with this id' })
    end
  end

  private

  def set_product
    @product = Product.find_by(id: params[:product_id])
    if @product.present?
      @product
    else
      notfound({ message: 'No product found with this id on cart' })
    end
  end
end
