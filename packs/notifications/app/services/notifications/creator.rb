# frozen_string_literal: true

module Notifications
  class Creator
    def self.call(**args)
      new(**args).call
    end

    def initialize(recipient:, notifiable:, kind:, category:, title:, body:, channels:, channel_payloads:,
                   bypass_preferences:, franchise: nil)
      @recipient = recipient
      @notifiable = notifiable
      @kind = kind
      @category = category
      @title = title
      @body = body
      @channels = channels
      @channel_payloads = channel_payloads
      @bypass_preferences = bypass_preferences
      @franchise = franchise
    end

    def call
      notification = Notification.create!(
        user: @recipient,
        notifiable: @notifiable,
        franchise_id: @franchise&.id,
        kind: @kind.to_s,
        category: @category,
        title: @title,
        body: @body,
        channels: @channels,
        channel_payloads: @channel_payloads,
        bypass_preferences: @bypass_preferences,
        order_reference: @notifiable.try(:reference)
      )

      @channels.each do |channel|
        notification.notification_deliveries.create!(channel: channel, status: 'pending')
      end

      DeliverJob.perform_later(notification.id)
      notification
    end
  end
end
