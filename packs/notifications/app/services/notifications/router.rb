# frozen_string_literal: true

module Notifications
  class Router
    CHANNELS = {
      'in_app' => Deliverers::InApp,
      'push' => Deliverers::Push,
      'email' => Deliverers::Email
    }.freeze

    def self.call(notification:, channel:)
      deliverer = CHANNELS[channel]
      return unless deliverer

      deliverer.call(notification: notification, channel: channel)
    end
  end
end
