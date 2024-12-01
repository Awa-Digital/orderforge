json.status 'success'
json.message 'Grouped products fetched successfully'
json.data do
  json.array! Category.all.order(title: :asc) do |category|
    json.title category.title
    json.image category.image
    json.subcategories do
      subcats = category.subcategories.order(title: :desc).select{ |x| x.products.positive? }
      json.array! subcats do |subcategory|
        json.title subcategory.title
        json.products do
          json.array! subcategory.products.select(&:available) do |product|
            json.id product.id
            json.title product.title
            amount = @cart&.franchise_id ? product.price(@cart&.franchise_id) : product.price
            json.amount amount > 0.0 ? amount : product.amount
            # json.amount product.amount
            json.description product.description
            json.image product.image
            json.ingredients product.ingredients
          end
        end
      end
    end
  end
end
