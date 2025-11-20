FactoryBot.define do
  factory :product do
    sequence(:title) { |n| "Product #{n}" }
    description { "Test product description" }
    amount { 1500.0 }
    status { 'active' }
    category_id { 1 }

    before(:create) do |product|
      next if Category.exists?(product.category_id)

      Category.create!(id: product.category_id, title: 'Test Category', status: 'active')
    end
  end
end
