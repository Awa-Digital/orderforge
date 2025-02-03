module Integrations
  class Meta
    class WhatsApp
      class Message
        def initialize(to:, message:)
          @to = to.gsub('+', '')
          @type = message.type
          @message = message
          @req = Integrations::Requester.new(BASE_URL, META_TOKEN)
        end

        def build_message
          {
            messaging_product: 'whatsapp',
            to: @to,
            type: @type,
            **@message.message
          }
        end

        def deliver
          @req.post('messages', build_message)
        end
      end
    end
  end
end
