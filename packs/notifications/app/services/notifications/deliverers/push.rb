# frozen_string_literal: true

module Notifications
  module Deliverers
    class Push
      def self.call(notification:, channel:)
        delivery = notification.notification_deliveries.find_by!(channel: channel)
        user = notification.user
        return delivery.update!(status: 'failed', error_message: 'No device') unless user&.devices&.any?

        token = user.devices.last.device_token
        FirePush.new.push(token, {
          title: notification.title,
          body: notification.body,
          image_url: notification.image,
          analytics_label: notification.kind
        })
        delivery.update!(status: 'delivered', delivered_at: Time.current)
      rescue StandardError => e
        delivery.update!(status: 'failed', error_message: e.message)
      end
    end
  end
end
