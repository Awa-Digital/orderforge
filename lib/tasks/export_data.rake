namespace :export do
  desc 'Export Datas'
  task export_to_seeds: :environment do
    Category.all.each do |category|
      excluded_keys = %w[created_at updated_at id]
      serialized = category
                   .serializable_hash
                   .delete_if { |key, _value| excluded_keys.include?(key) }
      puts "Category.create(#{serialized})"
    end

    Ingredient.all.each do |ing|
      excluded_keys = %w[created_at updated_at id]
      serialized = ing
                   .serializable_hash
                   .delete_if { |key, _value| excluded_keys.include?(key) }
      puts "Ingredient.create(#{serialized})"
    end

    Product.all.each do |pro|
      excluded_keys = %w[created_at updated_at id]
      serialized = pro
                   .serializable_hash
                   .delete_if { |key, _value| excluded_keys.include?(key) }
      puts "Product.create(#{serialized})"
    end
  end
end
