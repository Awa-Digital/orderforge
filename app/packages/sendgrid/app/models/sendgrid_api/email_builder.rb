# frozen_string_literal: true

module SendgridApi
  # Sending Emails
  class EmailBuilder
    def self.verification_email_data(user)
      {
        first_name: user.first_name,
        verification_url: user.verification_url,
        preheader: 'Please verify your email address to get access to order receipts, offers and exclusive burger deals.'
      }
    end

    def self.order_receipt_email_data(order, subject)
      {
        subject: subject,
        preheader: '⚡️ Your payment has been received and your order is being processed, sit back, relax and we would deliver in no time',
        customer_name: order.user.first_name,
        order_tracking_url: order.order_tracking_url,
        vat_charge: ActionController::Base.helpers.number_to_currency(order.vat_charge, unit: "₦"),
        delivery_charge: ActionController::Base.helpers.number_to_currency(order.delivery_charge, unit: "₦"),
        subtotal: ActionController::Base.helpers.number_to_currency(order.total, unit: "₦"),
        discount_amount: ActionController::Base.helpers.number_to_currency(order.discount_amount, unit: "₦"),
        total: ActionController::Base.helpers.number_to_currency(order.payment.total, unit: "₦")
      }
    end
  end
end
