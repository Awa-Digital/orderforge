class Subcategory < ApplicationRecord
  has_many :products
  belongs_to :category

  def as_json(options = {})
    # options[:methods] = %i[category]
    options[:except] = %i[created_at category_id updated_at]
    super
  end
end
