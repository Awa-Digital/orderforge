json.status 'success'
json.message 'Payment initiated successfully!'
pay = @pay_obj
json.payment do
  json.total pay.total
  json.paid pay.paid
  json.reference pay.reference
  json.gateway_reference pay.gateway_reference
  json.checkout_url pay.checkout_url
  json.gateway pay.gateway
  json.payment_id pay.payment_id
end
