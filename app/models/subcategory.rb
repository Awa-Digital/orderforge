class Subcategory < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)

  has_many :products
  belongs_to :category

  def as_json(options = {})
    # options[:methods] = %i[category]
    options[:except] = %i[created_at category_id updated_at]
    super
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[category_id created_at id title updated_at]
  end
end
