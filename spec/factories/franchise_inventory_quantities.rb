FactoryBot.define do
  factory :franchise_inventory_quantity do
    franchise_id { 1 }
    inventory_id { 1 }
    quantity { "9.99" }
  end
end
