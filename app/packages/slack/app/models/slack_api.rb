class SlackApi
  @client = Slack::Web::Client.new

  def self.send_order_message(order)
    message = SlackApi::Messages.order_message(order)
    @client.chat_postMessage(channel: '#jb-orders', blocks: message, as_user: true)
  end
end
