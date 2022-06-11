class Api::V1::OrdersController < Api::V1::BaseController
  def cart
    @cart = @mobile_user.cart
    if @cart.present?
      @items = @cart.items.order(created_at: :desc)
      @message = 'Cart Fetched!'
      render 'cart'
    else
      @mobile_user.start_cart
      success({ message: 'Cart is empty', data: @mobile_user.cart })
    end
  end
end
