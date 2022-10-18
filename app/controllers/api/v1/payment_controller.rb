# to handle payment request
class Api::V1::PaymentController < Api::V1::BaseController
  skip_before_action :authenticate_user, only: %i[new confirm]
  before_action :authenticate_guest, only: %i[new confirm]
  before_action :set_cart

  def new
    if @cart.present?
      initialize_payment_request(@cart)
    else
      unprocessable({ message: 'No cart with pending payment' })
    end
  end

  def attach_discount
    @voucher = Voucher.find_by(discount_code: params[:discount_code])
    if @voucher.present?
      @mobile_user.cart.payment.update(voucher_id: @voucher.id)
      show_cart
    else
      notfound({ message: 'This voucher is not available' })
    end
  end

  def show_cart
    @cart_render = @mobile_user.cart
    @message = 'Discount Applied'
    render 'api/v1/orders/cart'
  end

  def initialize_payment_request(cart)
    payment = cart.payment
    if payment.present? && payment.paid == true
      unprocessable({ message: 'Cart has already been paid for' })
    elsif payment.total == 0.0
      unprocessable({ message: 'Cart is empty' })
    else
      confirm_payment_status(payment, cart)
    end
  end

  def confirm_payment_status(payment, cart)
    if !payment.present?
      payment = generate_payment(cart)
      generate_payment_data(payment)
    elsif payment.present? && !payment.paid
      generate_payment_data(payment)
    end
  end

  def generate_payment_data(payment)
    payment.initiate
  rescue StandardError
    server_error({ message: 'Something went wrong, contact support' })
  else
    @pay_obj = Payment.find(payment.id)
    render 'initpay'
  end

  def generate_payment(cart)
    if @mobile_user.present?
      cart.create_payment(user_id: @mobile_user.id, total: cart.order_total)
    else
      cart.create_payment(total: cart.order_total)
    end
  end

  # Confirm Payment
  # Verify Payme

  def confirm
    @payment = Payment.find_by(reference: params[:reference])
    if @payment.present?
      if @payment.paid == true
        success({ message: 'This cart has been paid for', data: { payment: @payment, cart: @payment.order } })
      else
        verify_payment(@payment)
      end
    else
      notfound({ message: 'No payment found with this reference' })
    end
  end

  def verify_payment(payment)
    paid = payment.verify
  rescue StandardError
    server_error({ message: 'Something went wrong, contact support' })
  else
    if paid == true
      complete_payment(payment)
    else
      render json: { status: 'error', message: 'You have not paid for this transaction' }, status: 402
    end
  end

  def complete_payment(payment)
    payment.complete
    message = 'You have successfully paid for this transaction'
    show_payment_success(payment, message)
  end

  def show_payment_success(payment, message)
    cart = payment.order
    render json: {
      status: 'success',
      message: message,
      data: {
        payment: payment,
        cart: cart
      }
    }, status: 200
  end

  private

  def set_cart
    @cart = if @mobile_user.present?
              @mobile_user.cart
            else
              @order = Order.find_by(id: params[:order_id])
              create_or_find_order(@order)
            end
  end

  def create_or_find_order(order)
    if order.present?
      if order.status == 'initiated'
        order
      else
        Order.create(status: 'initiated')
      end
    else
      Order.create(status: 'initiated')
    end
  end
end
