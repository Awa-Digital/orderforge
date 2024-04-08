FactoryBot.define do
  factory :product_inventory_item do
    product_id { 1 }
    inventory_id { 1 }
    quantity { "9.99" }
  end
end
