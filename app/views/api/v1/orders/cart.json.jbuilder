json.status 'success'
json.message @message

json.data do
  json.order_id @cart.id
  json.order_status @cart.status
  json.order_reference @cart.reference
  json.order_total @cart.order_total
  json.products_total @cart.total
  json.vat_charge @cart.vat_charge.to_s
  json.delivery_charge @cart.delivery_charge.to_s
  json.recipient do
    json.name @cart.recipient_name
    json.phone @cart.recipient_phone
  end
  json.items do
    json.array! @items do |item|
      json.id item.id
      json.quantity item.quantity
      json.subtotal item.subtotal
      json.product do
        json.id item.product.id
        json.title item.product.title
        json.amount item.product.amount
        json.image item.product.image
      end
    end
  end
  json.delivery_address @cart.delivery_address
end
