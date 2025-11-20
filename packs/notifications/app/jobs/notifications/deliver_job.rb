# frozen_string_literal: true

module Notifications
  class DeliverJob < ApplicationJob
    queue_as :default

    def perform(notification_id)
      notification = Notification.find(notification_id)
      notification.notification_deliveries.where(status: 'pending').find_each do |delivery|
        Router.call(notification: notification, channel: delivery.channel)
      end
    end
  end
end
