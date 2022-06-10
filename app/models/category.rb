class Category < ApplicationRecord
  has_many :products

  def as_json(options = {})
    # options[:methods] = %i[category]
    options[:except] = %i[created_at updated_at]
    super
  end
end
