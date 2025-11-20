# frozen_string_literal: true

module Notifications
  class Dispatch
    def self.call(kind:, notifiable:, context:)
      new(kind: kind, notifiable: notifiable, context: context).call
    end

    def initialize(kind:, notifiable:, context:)
      @kind = kind
      @notifiable = notifiable
      @context = context
      @definition = Definitions::Registry.fetch(kind)
    end

    def call
      Array(@definition.recipients(@context)).each do |recipient|
        create_for_recipient(recipient)
      end
    end

    private

    def create_for_recipient(recipient)
      channel_payloads = @definition.channel_list.index_with do |channel|
        @definition.render(channel, @context)
      end
      display = channel_payloads['in_app'] || channel_payloads['push'] || {}

      Creator.call(
        recipient: recipient,
        notifiable: @notifiable,
        franchise: @definition.franchise_for(@context) || @notifiable.try(:franchise),
        kind: @definition.kind,
        category: @definition.category,
        title: display[:title] || 'Notification',
        body: display[:body] || '',
        channels: @definition.channel_list,
        channel_payloads: channel_payloads,
        bypass_preferences: @definition.bypass_preferences
      )
    end
  end
end
