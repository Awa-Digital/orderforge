json.status 'success'
json.message @message
json.transactions do
  json.array! @transactions do |transaction|
    json.order_id transaction.id
    json.order_status transaction.status
    json.order_reference transaction.reference
    json.order_total transaction.order_total
    json.products_total transaction.total
    json.discount transaction.discount_amount
    json.discounted_price transaction.discounted_price
    json.vat_charge transaction.vat_charge.to_s
    json.delivery_charge transaction.delivery_charge.to_s
    json.recipient do
      json.name transaction.recipient_name
      json.phone transaction.recipient_phone
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
    json.delivery_address transaction.delivery_address
    json.payment transaction.payment
  end
end
