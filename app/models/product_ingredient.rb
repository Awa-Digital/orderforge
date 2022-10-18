class ProductIngredient < ApplicationRecord
  belongs_to :product
  belongs_to :ingredient

  def as_json(options = {})
    options[:methods] = %i[ingredient]
    options[:except] = %i[id updated_at created_at product_id user_id ingredient_id]
    super
  end
end
