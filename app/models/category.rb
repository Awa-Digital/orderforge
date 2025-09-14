class Category < ApplicationRecord
  include StateManagement
  include Whodunit::Stampable if defined?(Rails::Server)

  mount_uploader :image, CatUploader

  has_many :products
  has_many :subcategories
  validates :title, uniqueness: true

  default_scope { where(status: "active") }

  def as_json(options = {})
    # options[:methods] = %i[category]
    options[:except] = %i[created_at updated_at]
    super
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      created_at
      description
      id
      image
      status
      title
      updated_at
    ]
  end
end
