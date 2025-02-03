module Integrations
  class FlutterWave
    class Payments
      @req = Integrations::Requester.new(BASE_URL, ENV.fetch('FLW_TOKEN', nil))

      def self.initialize(data)
        url = "payments"
        data = build_payload(data)

        @req.post(url, data)
      end

      def self.build_payload(data)
        {
          tx_ref: data.reference,
          amount: data.total,
          currency: data.currency,
          redirect_url: "#{ENV.fetch('APP_BASE_URL', nil)}/payment/complete",
          customer: {
            email: data.payable.recipient.email,
            phonenumber: data.payable.recipient.phone,
            name: data.payable.recipient.full_name
          },
          customizations: {
            title: data.payable.business.legal_name,
            logo: data.payable.business.logo.url
          }
        }
      end

      def self.send_funds(account, amount, narration, reference)
        url = "transfers"
        data = build_transfer_payload(account, amount, narration, reference)

        @req.post(url, data)
      end

      def self.build_transfer_payload(account, amount, narration, reference)
        {
          account_bank: account.bank_code,
          account_number: account.account_number,
          amount:,
          currency: account.currency,
          narration:,
          reference:
        }
      end

      def self.verify(reference)
        url = "transactions/verify_by_reference?tx_ref=#{reference}"

        conn = Faraday.new(url: BASE_URL) do |faraday|
          faraday.request :url_encoded
          faraday.adapter Faraday.default_adapter
          faraday.headers['Content-Type'] = 'application/json'
          faraday.headers['Authorization'] = "Bearer #{ENV.fetch('FLW_TOKEN', nil)}"
        end

        response = conn.get do |req|
          req.url url
          req.params['tx_ref'] = reference
        end

        raise ApiRequestFailedError, response.body unless response.status == 200 || response.status == 201

        JSON.parse(response.body)
      end

      # def self.verify_with_plugin(ref)
      #   @flw = Flutterwave.new
      #   transactions = Transactions.new(@flw)
      #   response = transactions.verify_transaction(ref)
      # rescue FlutterwaveServerError
      #   puts 'Server Error'
      #   false
      # else
      #   # payment = Payment.find_by(flw_ref: response['data']['tx_ref'])
      #   # return false unless payment
      #
      #   # unless ('successful' === response['data']['status']) && (correctly_charged_amount(response, payment))
      #   #   return false
      #   # end
      #
      #   # payment.update(gateway_payment_id: response['data']['id'])
      #   response
      # end
    end
  end
end

# https://api.flutterwave.com/v3/transactions/verify_by_reference?tx_ref=DevRef002156")
