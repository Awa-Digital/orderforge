module Order::Concerns
  module Emails

    NLABEL = "#{self.class.name}_notification"
    NTYPE = "#{self.class.name}_notification"

    def deliver_mails
      return send_guest_order_receipt_email if user_id.nil?

      send_order_receipt_email
      send_guest_order_receipt_email if user.email != recipient_email
      shout("Emails Delivered for: #{reference}")
    end

    def order_notification(title, body)
      Notification.create(
        user_id: user_id,
        title: title,
        body: body,
        analytics_label: NLABEL,
        order_reference: reference,
        notification_type: NTYPE
      )
    end

    def order_tracking_url
      "#{ENV['APP_BASE_URL']}/order-details/#{reference}"
    end

    def send_order_receipt_email
      SendgridApi::Email.new.order_receipt_email(self)
    rescue StandardError => e
      Sentry.capture_exception(e)
    end

    def send_guest_order_receipt_email
      SendgridApi::Email.new.guest_order_receipt_email(self)
    rescue StandardError => e
      Sentry.capture_exception(e)
    end

    def send_processing_email
      return unless paid == true

      SendgridApi::Email.new.order_processor_email(self)
    rescue StandardError => e
      Sentry.capture_exception(e)
    end
  end
end
