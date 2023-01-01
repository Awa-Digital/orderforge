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
        vat_charge: ActionController::Base.helpers.number_to_currency(order.vat_charge, unit: '₦'),
        delivery_charge: ActionController::Base.helpers.number_to_currency(order.delivery_charge, unit: '₦'),
        subtotal: ActionController::Base.helpers.number_to_currency(order.total, unit: '₦'),
        discount_amount: ActionController::Base.helpers.number_to_currency(order.discount_amount, unit: '₦'),
        total: ActionController::Base.helpers.number_to_currency(order.payment.total, unit: '₦')
      }
    end

    def self.guest_order_receipt_email_data(order, subject)
      {
        subject: subject,
        preheader: '⚡️ Your payment has been received and your order is being processed, sit back, relax and we would deliver in no time',
        customer_name: order.recipient_name,
        order_tracking_url: order.order_tracking_url,
        vat_charge: ActionController::Base.helpers.number_to_currency(order.vat_charge, unit: '₦'),
        delivery_charge: ActionController::Base.helpers.number_to_currency(order.delivery_charge, unit: '₦'),
        subtotal: ActionController::Base.helpers.number_to_currency(order.total, unit: '₦'),
        discount_amount: ActionController::Base.helpers.number_to_currency(order.discount_amount, unit: '₦'),
        total: ActionController::Base.helpers.number_to_currency(order.payment.total, unit: '₦')
      }
    end

    def self.processor_email_data(order, subject)
      {
        subject: subject,
        preheader: '⚡️ A customer has placed an order',
        customer_name: order.recipient_name,
        order_tracking_url: order.order_tracking_url,
        vat_charge: ActionController::Base.helpers.number_to_currency(order.vat_charge, unit: '₦'),
        delivery_charge: ActionController::Base.helpers.number_to_currency(order.delivery_charge, unit: '₦'),
        subtotal: ActionController::Base.helpers.number_to_currency(order.total, unit: '₦'),
        discount_amount: ActionController::Base.helpers.number_to_currency(order.discount_amount, unit: '₦'),
        total: ActionController::Base.helpers.number_to_currency(order.payment.total, unit: '₦'),
        items: items_array(order.order_items),
        delivery_address: delivery_address(order),
        phone_number: order.recipient_phone,
        email_address: order.recipient_email,
        recipient_name: order.recipient_name

      }
    end

    def self.items_array(items)
      arr = []
      items.each do |item|
        removables = if item.removables.present?
          "Remove: #{item.removables.includes(:ingredient).pluck('ingredients.name').join(', ')}"
        else
          ""
        end

        arr << {
          title: item.product.title,
          quantity: item.quantity,
          unit_price: ActionController::Base.helpers.number_to_currency(item.base_price, unit: '₦'),
          subtotal: ActionController::Base.helpers.number_to_currency(item.subtotal, unit: '₦'),
          removables: removables
        }
      end
      arr
    end

    def self.delivery_address(order)
      "#{order.order_address.house_number} #{order.order_address.street}, #{order.order_address.city}, #{order.order_address.state}, #{order.order_address.country}"
    end
  end
end
