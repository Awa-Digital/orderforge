# categories = [{ 'title' => '🥩 Beef', 'description' => 'Beef inspired Burgers' },
#               { 'title' => '🍔 Regular', 'description' => 'Regular Burgers' }, { 'title' => '🍗 Chicken', 'description' => 'Chicken inspired burgers' }, { 'title' => '🐟 Fish', 'description' => 'Fish inspired burgers' }, { 'title' => '🥬 Veggie', 'description' => 'Vegetables inspired burgers' }]

# categories.each do |category|
#   Category.create(category)
# end

# ingredients = [{ 'name' => 'Bell Pepper' }, { 'name' => 'Pepper' }, { 'name' => 'Lettuce' }, { 'name' => 'Bread' },
#                { 'name' => 'Cheese' }, { 'name' => 'Egg' }, { 'name' => 'Garlic' }, { 'name' => 'Onions' }, { 'name' => 'Tomato' }, { 'name' => 'Beef' }, { 'name' => 'Chicken' }, { 'name' => 'Potato' }, { 'name' => 'Cucumber' }, { 'name' => 'Broccoli' }, { 'name' => 'Fries' }]

# ingredients.each do |ing|
#   Ingredient.create(ing)
# end
# products = [{ 'title' => 'Beef Cheese Burger', 'description' => nil, 'category_id' => 1, 'amount' => 0.253e4,
#               'liked' => nil }, { 'title' => 'Tuna Fish Sandwich', 'description' => 'Fish bread sandwich with tuna', 'category_id' => 4,
#                                   'amount' => 0.35e4, 'liked' => nil }]
# products.each do |p|
#   Product.create(p)
# end

# db/seeds.rb

require 'faker'

# Create Users
# 10.times do
#   User.create!(
#     first_name: Faker::Name.first_name,
#     last_name: Faker::Name.last_name,
#     email: Faker::Internet.email,
#     phone_number: Faker::PhoneNumber.cell_phone,
#     password_digest: Faker::Internet.password,
#     slug: Faker::Internet.slug,
#     spend_score: Faker::Number.decimal(l_digits: 2),
#     status: 'active'
#   )
# end


categories = [
  { 'title' => '🥩 Beef', 'description' => 'Beef inspired Burgers' },
  { 'title' => '🍔 Regular', 'description' => 'Regular Burgers' },
  { 'title' => '🍗 Chicken', 'description' => 'Chicken inspired burgers' },
  { 'title' => '🐟 Fish', 'description' => 'Fish inspired burgers' },
  { 'title' => '🥬 Veggie', 'description' => 'Vegetables inspired burgers' }
]


# Create Categories
categories.each do |category|
  Category.find_or_create_by!(category)
end

# Create Subcategories
5.times do |i|
  Subcategory.create!(
    title: Faker::Commerce.material,
    category_id: i + 1
  )
end

# Create Products
10.times do |i|
  Product.create!(
    title: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    # image: Faker::LoremPixel.image,
    category_id: (i % 5) + 1,
    amount:  Faker::Number.between(from: 1000.01, to: 5000.99),
    liked: [true, false].sample,
    subcategory_id: (i % 5) + 1
  )
end

# Create Orders
10.times do |i|
  Order.create!(
    address_id: i + 1,
    user_id: User.first.id,
    status: 'initiated',
    completed: [true, false].sample,
    paid: [true, false].sample,
    reference: Faker::Alphanumeric.alphanumeric(number: 10),
    recipient_name: Faker::Name.name,
    recipient_phone: Faker::PhoneNumber.cell_phone,
    recipient_email: Faker::Internet.email
  )
end

products = Product.limit(10)
orders = Order.all

products.each do |product|
  # Create Order Items
  3.times do |i|
    OrderItem.create!(
      product_id: product.id,
      quantity: Faker::Number.between(from: 1, to: 5),
      order_id: orders[i + 1].id
    )
  end
end


# Create Ingredients
10.times do
  Ingredient.find_or_create_by!(
    name: Faker::Food.ingredient,
    # icon: Faker::LoremPixel.image
  )
end

products = Product.all

products.each do |product|
  # Create Product Ingredients
  10.times do |i|
    3.times do |j|
      ProductIngredient.create!(
        product_id: product.id,
        ingredient_id: j + 1
      )
    end
  end
end

# Create Locations
5.times do
  Location.create!(
    name: Faker::Address.city,
    status: 'active'
  )
end

locations = Location.all

locations.each do |location|

  # Create Regions
  3.times do
    Region.find_or_create_by(
      location_id: location.id,
      name: Faker::Address.community,
      status: 'active'
    )
  end
end


regions = Region.all

# Create Delivery Areas
10.times do |i|
  DeliveryArea.create!(
    name: Faker::Address.community,
    day_rate: Faker::Number.decimal(l_digits: 2),
    dusk_rate: Faker::Number.decimal(l_digits: 2),
    night_rate: Faker::Number.decimal(l_digits: 2),
    dawn_rate: Faker::Number.decimal(l_digits: 2),
    region_id: regions[(i % 5) + 1].id,
    status: 'active'
  )
end

delivery_areas = DeliveryArea.all

# Create Addresses
10.times do |i|
  Address.create!(
    user_id: User.first.id,
    street: Faker::Address.street_name,
    state: 'Lagos',
    country: 'Nigeria',
    house_number: Faker::Address.building_number,
    delivery_area_id: delivery_areas[i + 1].id
  )
end

# Create Notifications
10.times do |i|
  Notification.create!(
    title: Faker::Lorem.sentence,
    body: Faker::Lorem.paragraph,
    # image: Faker::LoremPixel.image,
    analytics_label: Faker::Lorem.word,
    user_id: User.first.id,
    order_reference: i + 1,
    notification_type: Faker::Lorem.word
  )
end

# Create Notification Settings
10.times do |i|
  NotificationSetting.create!(
    user_id: User.first.id,
    push_notifications: [true, false].sample,
    app_updates: [true, false].sample,
    promotions: [true, false].sample,
    receipts: [true, false].sample,
    newsletter: [true, false].sample
  )
end

puts "Seed data created successfully!"
