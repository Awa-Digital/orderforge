module Integrations
  class Meta
    class WhatsApp
      class MessageBuilder
        attr_accessor :message, :type

        def initialize(template_name = nil, type: 'template', language_code: 'en_GB')
          @type = type
          @message = {}
          return unless type == 'template'

          raise ArgumentError, 'template_name is required' if template_name.nil?

          @message.merge!(
            template: { name: template_name,
                        language: {
                          code: language_code
                        },
                        components: [{
                          type: 'body',
                          parameters: []
                        }] }
          )
        end

        def add_header
          @message[:template][:components].unshift({ type: 'header', parameters: [] })
        end

        def add_header_parameter(text)
          parameter = { type: 'text', text: }
          @message[:template][:components]
            .select { |i| i[:type] == 'header' }[0][:parameters] << parameter
        end

        def add_footer(text)
          @message[:template][:components] << {
            type: "footer",
            parameters: [
              {
                type: "text",
                text:
              }
            ]
          }
        end

        def add_body_parameter(parameter)
          @message[:template][:components]
            .select { |i| i[:type] == 'body' }[0][:parameters] << parameter
        end

        def add_url_button(url)
          @message[:template][:components] << {
            type: "button",
            sub_type: "url",
            index: "0",
            parameters: [
              {
                type: "text",
                text: url
              }
            ]
          }
        end

        def add_text_parameter(text)
          parameter = {
            type: 'text',
            text:
          }
          add_body_parameter(parameter)
        end

        def add_currency_parameter(fallback_value, code, amount_1000)
          parameter = {
            type: 'currency',
            currency: {
              fallback_value:,
              code:,
              amount_1000:
            }
          }
          add_body_parameter(parameter)
        end

        def add_date_time_parameter(datetime)
          formatted_date = datetime.strftime('%I%p - %dth %b., %Y').downcase

          parameter = {
            type: 'date_time',
            date_time: {
              fallback_value: formatted_date
            }
          }
          add_body_parameter(parameter)
        end
      end
    end
  end
end
