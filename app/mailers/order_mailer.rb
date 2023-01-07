class OrderMailer < ApplicationMailer

  def receipt_email
    @order = Order.find_by(reference: params[:reference])

    mail(to: 'urchman0000@gmail.com', subject: "You got a new order!")
  end
end
