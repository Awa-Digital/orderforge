module Integrations
  class Paystack
    class Accounts
      @req = Requester.new(BASE_URL, ENV.fetch('PSSK', nil))

      def self.resolve(account_number, bank_code)
        url = "/bank/resolve?account_number=#{account_number}&bank_code=#{bank_code}"

        @req.get(url, {})
      end

      def self.bank_list
        url = '/bank'
        @req.get(url, {})
      end

      def self.add_recipient(account)
        url = "/transferrecipient"
        data = {
          type: account.account_type,
          name: account.account_name,
          account_number: account.account_number,
          bank_code: account.bank_code,
          currency: account.currency
        }

        @req.post(url, data)
      end

      def self.transfer(details, transaction)
        url = "/transfer"
        data = build_transfer_payload(details, transaction)

        @req.post(url, data)
      end

      def self.build_transfer_payload(details, transaction)
        {
          source: "balance",
          amount: transaction.amount_in_kobo,
          reference: transaction.reference,
          recipient: details.recipient_code,
          reason: transaction.narration
        }
      end
    end
  end
end
