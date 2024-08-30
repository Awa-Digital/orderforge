json.status 'success'
json.message @message || I18n.t('success')
json.data do
  json.id @product.id
  json.title @product.title
  json.description @product.description
  json.image do
    json.url @product.image.url
  end
  amount = @cart&.franchise_id ? @product.price(@cart&.franchise_id) : @product.price
  json.amount amount > 0.0 ? amount : @product.amount
  json.liked @product.liked
  json.start_time @product.start_time
  json.end_time @product.end_time
  json.status @product.status
  json.available @product.available
  json.category do
    json.id @product.category.id
    json.title @product.category.title
    json.description @product.category.description
    json.image do
      json.url @product.category.image.url
    end
    json.status @product.category.status
  end
  json.subcategory do
    json.id @product.subcategory.id
    json.title @product.subcategory.title
  end
  json.ingredients @product.ingredients
  json.review_rating @product.review_rating
  json.review_count @product.review_count
end
