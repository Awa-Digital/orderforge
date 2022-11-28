# pay with paystack
class Paystacky
  def initialize
    @paystack_obj = Paystack.new(ENV['PSPK'], ENV['PSSK'])
  end

  def init(trans)
    transactions = PaystackTransactions.new(@paystack_obj)
    puts transactions
    result = transactions.initializeTransaction(
      reference: trans.reference,
      amount: trans.in_kobo.round(0).to_s,
      email: trans.order.recipient_email
    )
    puts result
    trans.update(gateway_reference: result['data']['access_code'], checkout_url: result['data']['authorization_url'],
                 gateway: 'Paystack')
  end

  def verify(trans)
    transactions = PaystackTransactions.new(@paystack_obj)
    result = transactions.verify(trans.reference)
    trans.update(payment_id: result['data']['id'])
    result
  end
end
