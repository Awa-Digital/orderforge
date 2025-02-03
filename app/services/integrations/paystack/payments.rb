module Integrations
  class Paystack
    class Payments
      @req = Integrations::Requester.new(BASE_URL, ENV.fetch('PSTK_TOKEN', nil))

      def self.initialize(payment)
        url = "/transaction/initialize"

        data = {
          email: payment.user.email,
          currency: 'NGN',
          amount: payment.total_in_kobo,
          reference: payment.gateway_reference
        }
        @req.post(url, data)
      end

      def self.verify(reference)
        url = "/transaction/verify/#{reference}"
        @req.get(url, {})
      end

      def self.add_recipient(details)
        url = "/transferrecipient"
        data = {
          type: details.account_type,
          name: details.account_name,
          account_number: details.account_number,
          bank_code: details.bank_code,
          currency: details.currency
        }

        @req.post(url, data)
      end
    end
  end
end
