# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
# rubocop:disable Metrics/AbcSize
module Order::Concerns
  # order notification maker
  module Notifications
    def send_update_notifications
      deliver_receipt_notifications if status == 'paid' && sent_receipt_notification == false
      deliver_processing_notifications if status == 'processing' && sent_processing_notification == false
      deliver_delivering_notifications if status == 'delivering' && sent_delivering_notification == false
      deliver_completed_notifications if status == 'completed' && sent_completed_notification == false
    end

    def create_order_notification(title, body, notification_label)
      Notification.create(
        user_id: user_id,
        title: title,
        body: body,
        analytics_label: notification_label,
        order_reference: reference,
        notification_type: notification_label
      )
    end

    def deliver_receipt_notifications
      shout("Sending Receipt Notifications for #{reference}") if status == 'paid' && sent_receipt_notification == false
      return send_guest_order_receipt_email if user_id.nil?

      @title = 'Payment Confirmed'
      @body = "Payment for your order ##{reference} has been confirmed!"
      @label = 'payment_confirmation_notification'
      send_order_receipt_email
      send_guest_order_receipt_email if user.phone_number.remove('+') != recipient_phone.remove('+')
      create_order_notification(@title, @body, @label)
      "Receipt Notifications Delivered for: ##{reference}"
    end

    def deliver_processing_notifications
      shout("Running Processing Notifications for #{reference}") if status == 'processing' && sent_processing_notification == false
      return send_order_processing_email(recipient_name) if user_id.nil?

      @title = 'Your order is now processing'
      @body = "Your order ##{reference} has been accepted and is now being processed, sit back and relax!"
      @label = 'order_processing_notification'
      send_order_processing_email(user.first_name)
      send_order_processing_email(recipient_name) if user.phone_number.remove('+') != recipient_phone.remove('+')
      create_order_notification(@title, @body, @label)
      "Processing Notifications Delivered for: ##{reference}"
    end

    def deliver_delivering_notifications
      shout("Running Delivering Notifications for #{reference}") if status == 'delivering' && sent_delivering_notification == false
      return send_order_delivering_email(recipient_name) if user_id.nil?

      @title = 'Your order is out for delivery'
      @body = "Your order ##{reference} has been dispatched for delivery, our rider would be in contact with you!"
      @label = 'order_delivery_notification'
      send_order_delivering_email(user.first_name)
      send_order_delivering_email(recipient_name) if user.phone_number.remove('+') != recipient_phone.remove('+')
      create_order_notification(@title, @body, @label)
      "Out for Delivery Notifications Delivered for: ##{reference}"
    end

    def deliver_completed_notifications
      shout("Running Completed Notifications for #{reference}") if status == 'completed' && sent_completed_notification == false
      return send_order_completed_email(recipient_name) if user_id.nil?

      @title = 'Your order has been delivered'
      @body = "Your order ##{reference} was accepted, processed and delivered, enjoy your meal!"
      @label = 'order_processing_notifications'
      send_order_completed_email(user.first_name)
      send_order_completed_email(recipient_name) if user.phone_number.remove('+') != recipient_phone.remove('+')
      create_order_notification(@title, @body, @label)
      "Order Completion Notifications Delivered for: ##{reference}"
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
# rubocop:enable Metrics/AbcSize
