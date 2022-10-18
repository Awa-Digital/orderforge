categories = [{ 'title' => '🥩 Beef', 'description' => 'Beef inspired Burgers' },
              { 'title' => '🍔 Regular', 'description' => 'Regular Burgers' }, { 'title' => '🍗 Chicken', 'description' => 'Chicken inspired burgers' }, { 'title' => '🐟 Fish', 'description' => 'Fish inspired burgers' }, { 'title' => '🥬 Veggie', 'description' => 'Vegetables inspired burgers' }]

categories.each do |category|
  Category.create(category)
end

ingredients = [{ 'name' => 'Bell Pepper' }, { 'name' => 'Pepper' }, { 'name' => 'Lettuce' }, { 'name' => 'Bread' },
               { 'name' => 'Cheese' }, { 'name' => 'Egg' }, { 'name' => 'Garlic' }, { 'name' => 'Onions' }, { 'name' => 'Tomato' }, { 'name' => 'Beef' }, { 'name' => 'Chicken' }, { 'name' => 'Potato' }, { 'name' => 'Cucumber' }, { 'name' => 'Broccoli' }, { 'name' => 'Fries' }]

ingredients.each do |ing|
  Ingredient.create(ing)
end
products = [{ 'title' => 'Beef Cheese Burger', 'description' => nil, 'category_id' => 1, 'amount' => 0.253e4,
              'liked' => nil }, { 'title' => 'Tuna Fish Sandwich', 'description' => 'Fish bread sandwich with tuna', 'category_id' => 4,
                                  'amount' => 0.35e4, 'liked' => nil }]
products.each do |p|
  Product.create(p)
end
