json.status 'success'
json.message @message
@cart = @cart_render
@items = @cart.items.order(created_at: :desc)
json.data do
  json.order_id @cart.id
  json.franhise @cart.franchise
  json.order_status @cart.status
  json.order_reference @cart.reference
  json.order_total @cart.order_total
  json.products_total @cart.total
  json.discount @cart.discount_amount
  json.discounted_price @cart.discounted_price
  json.vat_charge @cart.vat_charge.to_s
  json.delivery_charge @cart.delivery_charge.to_s
  json.recipient do
    json.name @cart.recipient_name
    json.phone @cart.recipient_phone
    json.email @cart.recipient_email
  end
  json.items do
    json.array! @items do |item|
      json.id item.id
      json.quantity item.quantity
      json.subtotal item.subtotal
      json.product do
        json.id item.product.id
        json.title item.product.title
        amount = @cart&.franchise_id ? item.product.price(@cart&.franchise_id) : item.product.price
        json.amount amount > 0.0 ? amount : item.product.amount
        # json.amount item.product.amount
        json.image item.product.image
        json.ingredients do
          json.array! item.product.ingredients do |ingredient|
            json.id ingredient.id
            json.name ingredient.name
            json.icon ingredient.icon
          end
        end
      end
      json.removables do
        json.array! item.removables do |removable|
          json.id removable.id
          json.order_item_id removable.order_item_id
          json.ingredient_id removable.ingredient_id
        end
      end
    end
  end
  json.delivery_address @cart.delivery_address
  json.payment @cart.payment
end
