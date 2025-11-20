# frozen_string_literal: true

module Notifications
  module Deliverers
    class Email
      def self.call(notification:, channel:)
        delivery = notification.notification_deliveries.find_by!(channel: channel)
        delivery.update!(status: 'delivered', delivered_at: Time.current)
      end
    end
  end
end
