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

# ------------------------------------------

require 'faker'

# categories = [
#   { 'title' => '🥩 Beef', 'description' => 'Beef inspired Burgers' },
#   { 'title' => '🍔 Regular', 'description' => 'Regular Burgers' },
#   { 'title' => '🍗 Chicken', 'description' => 'Chicken inspired burgers' },
#   { 'title' => '🐟 Fish', 'description' => 'Fish inspired burgers' },
#   { 'title' => '🥬 Veggie', 'description' => 'Vegetables inspired burgers' }
# ]

# # Create Categories
# categories.each do |category|
#   Category.find_or_create_by!(category)
# end

# # Create Subcategories
# 5.times do |i|
#   Subcategory.create!(
#     title: Faker::Commerce.material,
#     category_id: i + 1
#   )
# end

# # Create Products
# 10.times do |i|
#   Product.create!(
#     title: Faker::Commerce.product_name,
#     description: Faker::Lorem.sentence,
#     # image: Faker::LoremPixel.image,
#     category_id: (i % 5) + 1,
#     amount:  Faker::Number.between(from: 1000.01, to: 5000.99),
#     liked: [true, false].sample,
#     subcategory_id: (i % 5) + 1
#   )
# end

# # Create Orders
# 10.times do |i|
#   Order.create!(
#     address_id: i + 1,
#     user_id: User.first.id,
#     status: 'initiated',
#     completed: [true, false].sample,
#     paid: [true, false].sample,
#     reference: Faker::Alphanumeric.alphanumeric(number: 10),
#     recipient_name: Faker::Name.name,
#     recipient_phone: Faker::PhoneNumber.cell_phone,
#     recipient_email: Faker::Internet.email
#   )
# end

# products = Product.limit(10)
# orders = Order.all

# products.each do |product|
#   # Create Order Items
#   3.times do |i|
#     OrderItem.create!(
#       product_id: product.id,
#       quantity: Faker::Number.between(from: 1, to: 5),
#       order_id: orders[i + 1].id
#     )
#   end
# end

# # Create Ingredients
# 10.times do
#   Ingredient.find_or_create_by!(
#     name: Faker::Food.ingredient,
#     # icon: Faker::LoremPixel.image
#   )
# end

# products = Product.all

# products.each do |product|
#   # Create Product Ingredients
#   10.times do |i|
#     3.times do |j|
#       ProductIngredient.create!(
#         product_id: product.id,
#         ingredient_id: j + 1
#       )
#     end
#   end
# end

# # Create Locations
# 5.times do
#   Location.create!(
#     name: Faker::Address.city,
#     status: 'active'
#   )
# end

# locations = Location.all

# locations.each do |location|

#   # Create Regions
#   3.times do
#     Region.find_or_create_by(
#       location_id: location.id,
#       name: Faker::Address.community,
#       status: 'active'
#     )
#   end
# end

# regions = Region.all

# # Create Delivery Areas
# 10.times do |i|
#   DeliveryArea.create!(
#     name: Faker::Address.community,
#     day_rate: Faker::Number.decimal(l_digits: 2),
#     dusk_rate: Faker::Number.decimal(l_digits: 2),
#     night_rate: Faker::Number.decimal(l_digits: 2),
#     dawn_rate: Faker::Number.decimal(l_digits: 2),
#     region_id: regions[(i % 5) + 1].id,
#     status: 'active'
#   )
# end

# delivery_areas = DeliveryArea.all

# # Create Addresses
# 10.times do |i|
#   Address.create!(
#     user_id: User.first.id,
#     street: Faker::Address.street_name,
#     state: 'Lagos',
#     country: 'Nigeria',
#     house_number: Faker::Address.building_number,
#     delivery_area_id: delivery_areas[i + 1].id
#   )
# end

# # Create Notifications
# 10.times do |i|
#   Notification.create!(
#     title: Faker::Lorem.sentence,
#     body: Faker::Lorem.paragraph,
#     # image: Faker::LoremPixel.image,
#     analytics_label: Faker::Lorem.word,
#     user_id: User.first.id,
#     order_reference: i + 1,
#     notification_type: Faker::Lorem.word
#   )
# end

# # Create Notification Settings
# 10.times do |i|
#   NotificationSetting.create!(
#     user_id: User.first.id,
#     push_notifications: [true, false].sample,
#     app_updates: [true, false].sample,
#     promotions: [true, false].sample,
#     receipts: [true, false].sample,
#     newsletter: [true, false].sample
#   )
# end

# puts "Seed data created successfully!"

# ----------------------------------------------------------------
#
## Clear existing data
Staff.delete_all
StaffDepartment.delete_all
DepartmentRole.delete_all
Role.delete_all
Department.delete_all

# Create Departments
owner_department = Department.create(name: 'Franchise Owner')
admin_department = Department.create!(name: 'Administration')
sales_department = Department.create!(name: 'Sales')
marketing_department = Department.create!(name: 'Marketing')
finance_department = Department.create!(name: 'Finance')
order_management_department = Department.create!(name: 'Order Management')

# Create Roles
super_role = Role.create(name: 'SuperAdministrator')
admin_manager_role = Role.create!(name: 'AdminManager')
admin_staff_role = Role.create!(name: 'AdminStaff')
sales_manager_role = Role.create!(name: 'SalesManager')
sales_associate_role = Role.create!(name: 'SalesAssociate')
marketing_manager_role = Role.create!(name: 'MarketingManager')
marketing_staff_role = Role.create!(name: 'MarketingStaff')
finance_manager_role = Role.create!(name: 'FinanceManager')
finance_staff_role = Role.create!(name: 'FinanceStaff')
order_manager_role = Role.create!(name: 'OrderManager')
order_processor_role = Role.create!(name: 'OrderProcessor')

# Assign Roles to Departments
DepartmentRole.create!(department: admin_department, role: admin_manager_role)
DepartmentRole.create!(department: admin_department, role: admin_staff_role)
DepartmentRole.create!(department: sales_department, role: sales_manager_role)
DepartmentRole.create!(department: sales_department, role: sales_associate_role)
DepartmentRole.create!(department: marketing_department, role: marketing_manager_role)
DepartmentRole.create!(department: marketing_department, role: marketing_staff_role)
DepartmentRole.create!(department: finance_department, role: finance_manager_role)
DepartmentRole.create!(department: finance_department, role: finance_staff_role)
DepartmentRole.create!(department: order_management_department, role: order_manager_role)
DepartmentRole.create!(department: order_management_department, role: order_processor_role)
DepartmentRole.create!(department: owner_department, role: super_role)

franchises = Franchise.all

franchises.each do |franchise|
  owner = Staff.create!(first_name: 'Uchenna', last_name: "Mba", franchise:, email: "hey@uche.io", password: "Uchiha@450", password_confirmation: "Uchiha@450")

  5.times do
    Staff.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      franchise_id: franchise.id,
      email: Faker::Internet.email,
      password: "defaultStaff",
      password_confirmation: "defaultStaff"
    )
  end

  staffs = Staff.where(franchise_id: franchise.id).where.not(email: "hey@uche.io")

  StaffDepartment.create!(staff: staffs[0], department: sales_department)
  StaffDepartment.create!(staff: staffs[1], department: admin_department)
  StaffDepartment.create!(staff: staffs[2], department: marketing_department)
  StaffDepartment.create!(staff: staffs[3], department: finance_department)
  StaffDepartment.create!(staff: staffs[4], department: order_management_department)
  StaffDepartment.create!(staff: owner, department: owner_department)
  StaffDepartment.create!(staff: owner, department: admin_department)
end

puts "Seed data populated successfully."

#     recipient_name: Faker::Name.name,
#     recipient_phone: Faker::PhoneNumber.cell_phone,
#     recipient_email: Faker::Internet.email
