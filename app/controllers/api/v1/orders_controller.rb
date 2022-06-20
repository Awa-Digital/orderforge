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
    @item = add_to_cart(@product.id, params[:quantity].to_i, @cart)
    success({ message: 'item has been added to cart', data: @item })
  end

  def add_to_cart(product_id, quantity, cart)
    @item = cart.items.find_or_create_by(product_id: product_id)
    @item.quantity = quantity.to_i
    begin
      @item.save
    rescue StandardError => e
      unprocessable({ message: e.message, data: @item.errors })
    else
      @item
    end
  end

  def add_multi
    @cart = @mobile_user.cart
    items = params[:items]
    items.each do |item|
      @product = Product.find_by(id: item[:product_id])
      add_to_cart(item[:product_id], item[:quantity], @cart) if @product.present?
    end
    @items = @cart.items.order(created_at: :desc)
    @message = 'Items have been added to cart'
    render 'cart'
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
