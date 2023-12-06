# frozen_string_literal: true

module Order::Concerns
  # email sender for all order notifications
  module Emails
    def order_tracking_url
      "#{ENV.fetch('APP_BASE_URL', nil)}/order-details/#{reference}"
    end

    def send_order_receipt_email
      return if sent_receipt_notification == true

      OrderMailer.with(reference:, receipient: user.email).receipt_email.deliver
      # SendgridApi::Email.new.order_receipt_email(self)
      update!(sent_receipt_notification: true)
    rescue StandardError => e
      puts "Order Receipt Email Delivery for #{user.email} failed!!"
      Sentry.capture_exception(e)
    end

    def send_guest_order_receipt_email
      return if sent_guest_receipt_notification == true

      OrderMailer.with(reference:, receipient: recipient_email).receipt_email.deliver
      # SendgridApi::Email.new.guest_order_receipt_email(self)
      update!(sent_guest_receipt_notification: true)
    rescue StandardError => e
      Sentry.capture_exception(e)
    end

    def send_processing_email
      return unless paid == true

      shout("sending emails to orders@jazzysburger.com for ORDER: #{id}")
      begin
        OrderMailer.with(reference:).coy_order_email.deliver
      rescue Net::SMTPAuthenticationError => e
        Sentry.capture_exception(Net::SMTPAuthenticationError.new("Email Deliver Error"))
        Sentry.capture_message(e)
      end
    rescue StandardError => e
      Sentry.capture_exception(e)
    end

    def send_order_processing_email(name)
      return if sent_processing_notification == true
      return unless status == 'processing'

      @body = "#{name}! Your order ##{reference} is being processed, sit back, relax while we make you the best burger ever!"
      SendgridApi::Email.new.status_processing_email(self, @body)
      update_attribute :sent_processing_notification, true
    rescue StandardError => e
      Sentry.capture_exception(e)
    end

    def send_order_delivering_email(name)
      return if sent_delivering_notification == true
      return unless status == 'delivering'

      @body = "#{name}! Your order ##{reference} has been dispatched for delivery, a rider would contact you(the recipient) shortly!"
      SendgridApi::Email.new.status_processing_email(self, @body)
      update_attribute :sent_delivering_notification, true
    rescue StandardError => e
      Sentry.capture_exception(e)
    end

    def send_order_completed_email(name)
      return if sent_completed_notification == true
      return unless status == 'completed'

      @body = "#{name}! Your order ##{reference} has been delivered, enjoy the best burger in ever!"
      SendgridApi::Email.new.status_processing_email(self, @body)
      update_attribute :sent_completed_notification, true
    rescue StandardError => e
      Sentry.capture_exception(e)
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
