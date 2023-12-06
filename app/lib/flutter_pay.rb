# Flutterwave Payment for Yaaaga App
# From Flutterwave's API Reference
class FlutterPay
  def initialize
    @flw = Flutterwave.new(
      ENV.fetch('FLW_PUB_KEY', nil),
      ENV.fetch('FLW_SEC_KEY', nil),
      ENV.fetch('FLW_ENC_KEY', nil)
    )
    @bank_transfer = BankTransfer.new(@flw)
  end

  def generate_payment_account(payload)
    response = @bank_transfer.initiate_charge(payload)
    JSON.parse response
  end

  def init_banktransfer(transaction)
    payload = transaction.banktransfer_payload
    payment_details = generate_payment_account(payload)
    puts payment_details
    transaction.update(
      access_code: payment_details['meta']['authorization']['transfer_reference'],
      gateway: 'Flutterwave'
    )
    payment_details
  end

  def verify(transaction)
    payload = @flw.verify_by_reference(transaction.gateway_reference)
    transaction.update(payment_id: payload['data']['id'])
    payload
  end
end
