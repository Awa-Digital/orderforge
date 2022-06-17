class Product < ApplicationRecord
  mount_uploader :image, ProductUploader

  belongs_to :category
  has_many :product_ingredients
  has_many :ingredients, through: :product_ingredients
  has_many :favourite_items
  has_many :order_items
  has_many :ratings

  validates :title,
            :description,
            :category_id,
            :amount, presence: true

  def as_json(options = {})
    options[:methods] = %i[category ingredients review_rating review_count]
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

  def review_rating
    if review_count > 0
      (ratings.sum(:rating) / ratings.count)
    else
      0
    end
  end

  def review_count
    ratings.count
  end
end
