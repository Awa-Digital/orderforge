# Flutterwave Payment for Yaaaga App
# From Flutterwave's API Reference
class FlutterPay
  def initialize
    @flw = Flutterwave.new(
      ENV['FLW_PUB_KEY'],
      ENV['FLW_SEC_KEY'],
      ENV['FLW_ENC_KEY']
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
