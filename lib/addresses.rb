orders = Order.where(franchise_id: nil, paid: true).left_joins(:order_address).where.not(order_addresses: { id: nil })

orders.first.order_address

FRANCHISE_MAP = [
  { name: "Abuja", id: 2 },
  { name: "Benin", id: 3 },
  { name: "Lagos", id: 1 },
  { name: "Port Harcourt", id: 5 }
]

orders.find_each do |order|
  franchise = FRANCHISE_MAP.find { |f| f[:name] == order.order_address.state }
  next unless franchise

  order.update(franchise_id: franchise[:id])
end
