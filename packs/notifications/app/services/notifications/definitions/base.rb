# frozen_string_literal: true

module Notifications
  module Definitions
    class Base
      def kind
        raise NotImplementedError
      end

      def category
        'orders'
      end

      def channel_list
        %w[in_app push email]
      end

      def bypass_preferences
        false
      end

      def recipients(context)
        [context[:user]].compact
      end

      def franchise_for(_context)
        nil
      end

      def render(channel, context)
        case channel
        when 'in_app', 'push'
          {
            title: default_title(context),
            body: default_body(context)
          }
        when 'email'
          { subject: default_title(context), body: default_body(context) }
        end
      end

      private

      def default_title(context)
        "Order #{context[:order]&.reference}"
      end

      def default_body(context)
        "Your order status is #{context[:order]&.status}"
      end
    end
  end
end
