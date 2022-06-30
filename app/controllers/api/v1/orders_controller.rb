class Api::V1::OrdersController < Api::V1::BaseController
  before_action :set_product, only: %i[add update remove]
  before_action :set_cart

  def cart
    @cart_render = @cart
    @message = 'Cart Fetched!'
    render 'cart'
  end

  def add_to_cart(product_id, quantity, cart)
    @item = cart.items.find_or_create_by(product_id: product_id)
    @item.quantity = quantity.to_i
    begin
      @item.save
    rescue StandardError => e
      puts e.message
      puts 'PRODUCT DID NOT SAVE'
    end
  end

  def add_multi
    items = params[:items]
    items.each do |item|
      @product = Product.find_by(id: item[:product_id])
      add_to_cart(item[:product_id], item[:quantity], @cart) if @product.present?
    end
    @cart_render = Order.find(@cart.id)
    @message = 'Items have been added to cart'
    render 'cart'
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

  def attach_address
    @address = @mobile_user.addresses.find_by(id: params[:address_id])
    if @address.present?
      @mobile_user.cart.order_address.update(
        JSON.parse(@address.to_json)
      )
      success({ message: 'Address has been assigned successfully', data: @address })
    else
      notfound({ message: 'No address found with this id for this user' })
    end
  end

  def attach_recipient
    @mobile_user.cart.update(
      recipient_name: params[:recipient]['name'],
      recipient_phone: params[:recipient]['phone']
    )
    success({ message: 'Recipient has been updated', data: {
              recipient: {
                name: @mobile_user.cart.recipient_name,
                phone: @mobile_user.cart.recipient_phone
              }
            } })
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

  def set_cart
    @cart = @mobile_user.cart
  end
end

# def add
#   @cart = @mobile_user.cart
#   @item = add_to_cart(@product.id, params[:quantity].to_i, @cart)
#   success({ message: 'item has been added to cart', data: @item })
# end

# def update
#   @cart = @mobile_user.cart
#   @item = @cart.items.find_by(product_id: @product.id)
#   if @item.present?
#     @item.update(quantity: params[:quantity].to_i)
#     @cart.sum_total
#     success({ message: 'item has been updated on cart', data: @item })
#   else
#     notfound({ message: 'No product found with this id' })
#   end
# end
