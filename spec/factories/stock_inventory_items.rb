FactoryBot.define do
  factory :stock_inventory_item do
    stock_id { 1 }
    inventory_id { 1 }
    quantity { "9.99" }
  end
end
