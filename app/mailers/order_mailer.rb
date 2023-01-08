class OrderMailer < ApplicationMailer
  before_action :set_receipt_email, only: [:receipt_email]

  def receipt_email
    @order = Order.find_by(reference: params[:reference])

    mail(to: 'urchman0000@gmail.com', subject: "You got a new order!", delivery_method_options: @delivery_options)
  end
end
