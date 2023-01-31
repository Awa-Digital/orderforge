module Order::Concerns
  # verification of payment
  module Verify
    def verify
      paid = payment.verify
    rescue StandardError
      raise "An error occurred while verifying this payment: #{payment.reference}"
    else
      return shout('Transaction not paid') unless paid == true

      complete_payment(payment)
    end

    def complete_payment(payment)
      payment.complete if paid != true
      shout('Transaction is verified')
    end
  end
end
