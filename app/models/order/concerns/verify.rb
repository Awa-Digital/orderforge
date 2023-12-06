module Order::Concerns
  # verification of payment
  module Verify
    def verify
      return shout('Transaction is verified') if paid == true
      
      payment_status = payment.verify
    rescue StandardError
      raise "An error occurred while verifying this payment: #{payment.reference}"
    else
      return shout('Transaction not paid') unless payment_status == true

      complete_payment(payment)
    end

    def complete_payment(payment)
      payment.complete if paid != true
      shout('Transaction is verified')
    end
  end
end
