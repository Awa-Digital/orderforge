# frozen_string_literal: true

module Notifications
  module Definitions
    class OrderPaid < Base
      def kind
        :order_paid
      end

      def default_title(context)
        "Payment received — #{context[:order]&.reference}"
      end

      def default_body(context)
        'Your payment was successful and your order is being prepared.'
      end
    end
  end
end