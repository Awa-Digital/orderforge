json.status 'success'
json.message @message || I18n.t('success')
json.data do
  json.array! @products do |product|
    json.id product.id
    json.title product.title
    json.description product.description
    json.image do
      json.url product.image.url
    end
    amount = @cart&.franchise_id ? product.price(@cart&.franchise_id) : product.price
    json.amount amount > 0.0 ? amount : product.amount
    json.liked product.liked
    json.start_time product.start_time
    json.end_time product.end_time
    json.status product.status
    json.available product.available
    json.category do
      json.id product.category.id
      json.title product.category.title
      json.description product.category.description
      json.image do
        json.url product.category.image.url
      end
      json.status product.category.status
    end
    json.subcategory do
      json.id product.subcategory.id
      json.title product.subcategory.title
    end
    json.ingredients product.ingredients
    json.review_rating product.review_rating
    json.review_count product.review_count
    json.price product.price
  end
end

# {
#   "id": 10,
#   "title": "Fanta Pet 50cl",
#   "description": "Fanta is an orange refreshing drink to enjoy with burgers and share with friends & family!",
#   "image": {
#       "url": "https://awa-apps.fra1.digitaloceanspaces.com/JJB/local/products/prod_10/file.jpg?X-Amz-Expires=600&X-Amz-Date=20240829T210605Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=DO00PLPKAUE6K7RD3KCK%2F20240829%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=a227b4a93e5fdcebffed419d5d610e77b480f90e81629fb394203240b055e12c"
#   },
#   "amount": "1499.0",
#   "liked": true,
#   "start_time": 0,
#   "end_time": 23,
#   "status": "active",
#   "available": true,
#   "category": {
#       "id": 7,
#       "title": "Drinks",
#       "description": "Beverages, Milkshakes & Water",
#       "image": {
#           "url": "https://awa-apps.fra1.digitaloceanspaces.com/JJB/local/category/ing_7/file%282%29.png?X-Amz-Expires=600&X-Amz-Date=20240829T210605Z&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=DO00PLPKAUE6K7RD3KCK%2F20240829%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=1d6c68d58ba52db38a1368f186d52b75dcc829da21e2ba0632b109e535a07550"
#       },
#       "status": "active"
#   },
#   "subcategory": {
#       "id": 4,
#       "title": "Beverage"
#   },
#   "ingredients": [],
#   "review_rating": 0,
#   "review_count": 0,
#   "price": null
# },
