# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  def receipt_email
    # Set up a temporary order for the preview
    order = Order.find(55)

    OrderMailer.with(reference: order.reference).receipt_email
  end

  def coy_order_email
    # Set up a temporary order for the preview
    order = Order.find(55)

    OrderMailer.with(reference: order.reference).coy_order_email
  end
end
