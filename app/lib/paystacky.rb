class Paystacky
  def initialize
    @paystackObj = Paystack.new(ENV['PSPK'], ENV['PSSK'])
  end

  def init(trans, email)
    transactions = PaystackTransactions.new(@paystackObj)
    result = transactions.initializeTransaction(
      reference: trans.gateway_reference,
      amount: trans.in_kobo.round(0).to_s,
      email: email
    )
    trans.update(
      access_code: result['data']['access_code'],
      checkout_url: result['data']['authorization_url'],
      gateway: 'Paystack'
    )
  end

  def verify(trans)
    transactions = PaystackTransactions.new(@paystackObj)
    result = transactions.verify(trans.gateway_reference)
    trans.update(payment_id: result['data']['id'])
    result
  end
end
