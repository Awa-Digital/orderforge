json.status 'success'
json.message 'Grouped products fetched successfully'
json.data do
  json.array! Category.all do |category|
    json.title category.title
    json.image category.image
    json.subcategories do
      json.array! category.subcategories do |subcategory|
        json.title subcategory.title
        json.products do
          json.array! subcategory.products do |product|
            json.id product.id
            json.title product.title
            json.amount product.amount
            json.description product.description
            json.image product.image
            json.ingredients product.ingredients
          end
        end
      end
    end
  end
end
