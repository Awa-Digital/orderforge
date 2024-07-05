# rubocop:disable Metrics/MethodLength

class SlackApi
  module Messages
    def self.order_message(order)
      blocks = [
        {
          type: 'header',
          text: {
            type: 'plain_text',
            text: '🎉 New Order Alert!',
            emoji: true
          }
        },
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: 'Payment for an order has been confirmed and should be processed and delivered.'
          }
        },
        {
          type: 'divider'
        },
        {
          type: 'section',
          fields: [
            {
              type: 'mrkdwn',
              text: "Order Reference: <#{order.order_tracking_url}|#{order.reference}>"
            }
          ]
        },
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "Recipient: *#{order.recipient_name}*"
          }
        },
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "Contact: <tel:#{order.recipient_phone}|#{order.recipient_phone}> | <mailto:#{order.recipient_email}|#{order.recipient_email}>"
          }
        },
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "Delivery Address: <https://www.google.com/maps/place/#{CGI.escape(full_address(order.order_address))}|#{full_address(order.order_address)}>"
          }
        },
        {
          type: 'divider'
        },
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: ':shopping_trolley: | * ORDERED ITEMS:* | :shopping_trolley:'
          }
        }
      ]

      order.order_items.each do |item|
        blocks << {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "*#{item.product.title}*\n• #{item.quantity}x at `₦#{number_to_currency(item.product.amount,
                                                                                          unit: '₦')}` each\n• Subtotal: *₦#{number_to_currency(
                                                                                            item.subtotal, unit: '₦'
                                                                                          )}*"
          }
        }

        blocks << {
          type: 'divider'
        }
      end

      blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: ':money_with_wings: | * ORDER SUMMARY:* | :money_with_wings:'
        }
      }

      blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "• Subtotal: ₦#{number_to_currency(order.total,
                                                   unit: '₦')}\n• Delivery Fees: ₦#{number_to_currency(order.delivery_charge,
                                                                                                       unit: '₦')}\n• Discount: -₦#{number_to_currency(order.discount_amount,
                                                                                                                                                       unit: '₦')}\n• *Total Paid: ₦#{number_to_currency(
                                                                                                                                                         order.payment.total, unit: '₦'
                                                                                                                                                       )}*"
        }
      }

      blocks << {
        type: 'actions',
        elements: [
          {
            type: 'button',
            text: {
              type: 'plain_text',
              text: 'Track This Order',
              emoji: true
            },
            value: 'track_order_' + order.id.to_s,
            action_id: 'track_order',
            url: order.order_tracking_url
          }
        ]
      }

      blocks << {
        type: 'divider'
      }

      blocks
    end

    def self.number_to_currency(amount, unit)
      ActiveSupport::NumberHelper.number_to_currency(amount, unit:, separator: '.', delimiter: ',', precision: 2)
    end

    def self.full_address(address)
      "#{address.house_number} #{address.street}, #{address.city}, #{address.state}, #{address.country}"
    end
  end
end

# rubocop:enable Metrics/MethodLength, Metrics/ModuleLength
