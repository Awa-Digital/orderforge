# pay with paystack
class Paystacky
  def initialize
    @paystack_obj = Paystack.new(ENV['PSPK'], ENV['PSSK'])
  end

  def init(trans)
    transactions = PaystackTransactions.new(@paystack_obj)
    puts trans.reference
    puts trans.in_kobo.round(0).to_s
    puts trans.order.recipient_email
    begin
      result = transactions.initializeTransaction(
        reference: trans.reference,
        amount: trans.in_kobo.round(0).to_s,
        email: trans.order.recipient_email
      )
    rescue StandardError => e
      Sentry.capture_exception(e)
    else
      trans.update(gateway_reference: result['data']['access_code'], checkout_url: result['data']['authorization_url'],
                 gateway: 'Paystack')
    end
  end

  def verify(trans)
    transactions = PaystackTransactions.new(@paystack_obj)
    result = transactions.verify(trans.reference)
    trans.update(payment_id: result['data']['id'], paid_at: result['data']['paid_at'])
    result
  end
end

# JAZ1669683599.T1669723740
