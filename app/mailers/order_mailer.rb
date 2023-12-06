class OrderMailer < ApplicationMailer
  before_action :set_receipt_email, only: %i[receipt_email coy_order_email]

  layout 'receipt_template'
  def receipt_email
    @order = Order.find_by(reference: params[:reference])
    @ad = Ad.active_ads.last
    @preheader = "#{@order.recipient_name} Your order has been confirmed and here are the details"

    mail(to: params[:receipient], subject: 'You got a new order!', delivery_method_options: @delivery_options)
  rescue Net::SMTPAuthenticationError => e
    Sentry.capture_exception(Net::SMTPAuthenticationError.new(e))
    Sentry.capture_message(e)
  end

  def coy_order_email
    @order = Order.find_by(reference: params[:reference])
    @preheader = 'A user just paid for an order'

    mail(to: 'orders@jazzysburger.com', cc: 'dispatch@jazzysburger.com', subject: "An order has been placed  - #{@order.reference}",
         delivery_method_options: @delivery_options)
  rescue Net::SMTPAuthenticationError => e
    Sentry.capture_exception(Net::SMTPAuthenticationError.new(e))
    Sentry.capture_message(e)
  end
end
