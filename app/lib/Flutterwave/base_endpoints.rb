module BASE_ENDPOINTS
  CHARGE_ENDPOINT = 'flwv3-pug/getpaidx/api/charge'.freeze
  TOKENISED_CHARGE_ENDPOINT = 'flwv3-pug/getpaidx/api/tokenized/charge'.freeze
  PREAUTH_CHARGE_ENDPOINT = 'flwv3-pug/getpaidx/api/tokenized/preauth_charge'.freeze
  CAPTURE_ENDPOINT = 'flwv3-pug/getpaidx/api/capture'.freeze
  REFUND_VOID_ENDPOINT = 'flwv3-pug/getpaidx/api/refundorvoid'.freeze
  CARD_VALIDATE_ENDPOINT = 'flwv3-pug/getpaidx/api/validatecharge'.freeze
  ACCOUNT_VALIDATE_ENDPOINT = 'flwv3-pug/getpaidx/api/validate'.freeze
  VERIFY_ENDPOINT = 'flwv3-pug/getpaidx/api/v2/verify'.freeze
  PAYMENT_PLANS_ENDPOINT = 'v2/gpx/paymentplans'.freeze
  SUBSCRIPTIONS_ENDPOINT = 'v2/gpx/subscriptions'.freeze
  TRANSFER_ENDPOINT = 'v2/gpx/transfers'.freeze
  SUBACCOUNT_ENDPOINT = 'v2/gpx/subaccounts'.freeze
  GET_FEE_ENDPOINT = 'v2/gpx/transfers/fee'.freeze
  GET_BALANCE_ENDPOINT = 'v2/gpx/balance'.freeze
  FETCH_ENDPOINT = 'v2/gpx/transfers'.freeze
  REFUND_ENDPOINT = 'gpx/merchant/transactions'.freeze
  BANKS_ENDPOINT = 'flwv3-pug/getpaidx/api/flwpbf-banks.js'.freeze
end
