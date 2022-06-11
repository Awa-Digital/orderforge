class Product < ApplicationRecord
  mount_uploader :image, ProductUploader

  belongs_to :category
  has_many :product_ingredients
  has_many :ingredients, through: :product_ingredients
  has_many :favourite_items

  validates :title,
            :description,
            :category_id,
            :amount, presence: true

  def as_json(options = {})
    options[:methods] = %i[category]
    options[:except] = %i[created_at updated_at user_id]
    super
  end

  def like(user)
    user.favourite.favourite_items.find_or_create_by(
      product_id: id
    )
  end

  def unlike(user)
    user.favourite.favourite_items.find_by(product_id: id).destroy
  end

  def liked?(user)
    user.favourite.favourite_items.find_by(product_id: id).present?
  end
end
