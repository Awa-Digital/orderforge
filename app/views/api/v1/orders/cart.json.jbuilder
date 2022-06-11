json.status 'success'
json.message @message

json.data do
  json.order_id @cart.id
  json.order_reference @cart.reference
  json.order_total @cart.total
  json.order_charges @cart.vat_charge.to_s # chage this
  json.items do
    json.array! @items do |item|
      json.id item.id
      json.quantity item.quantity
      json.subtotal item.subtotal
      json.product do
        json.id item.product.id
        json.name item.product.name
        json.amount item.product.amount
        json.image item.product.image
      end
    end
  end
end
