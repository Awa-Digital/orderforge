class OrderMailer < ApplicationMailer
  before_action :set_receipt_email, only: [:receipt_email]

  layout 'receipt_template'
  def receipt_email
    @order = Order.find_by(reference: params[:reference])
    @ad = Ad.active_ads.last
    @preheader = "#{@order.recipient_name} Your order has been confirmed and here are the details"

    mail(to: params[:receipient], subject: "You got a new order!", delivery_method_options: @delivery_options)
  end
end
