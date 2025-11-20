FactoryBot.define do
  factory :order_item do
    quantity { 1 }
    subtotal { 1500.0 }
    association :order
    association :product
  end
end
