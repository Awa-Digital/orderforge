class Product < ApplicationRecord
  mount_uploader :image, ProductUploader

  belongs_to :category
  belongs_to :subcategory, optional: true
  has_many :product_ingredients
  has_many :ingredients, through: :product_ingredients
  has_many :favourite_items
  has_many :order_items
  has_many :ratings

  validates :title,
            :description,
            :category_id,
            :amount, presence: true

  # NOW = Date.today.in_time_zone
  default_scope { where(status: "active") }

  def as_json(options = {})
    options[:methods] = %i[available category subcategory ingredients review_rating review_count]
    options[:except] = %i[created_at updated_at user_id subcategory_id category_id]
    super
  end

  def available
    @now = Date.today.in_time_zone
    @start_time = Time.new(@now.year, @now.month, @now.day, start_time, 0)
    @end_time = Time.new(@now.year, @now.month, @now.day, end_time, 59)
    Time.now.in_time_zone.between?(@start_time, @end_time)
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
    if review_count.positive?
      (ratings.sum(:rating) / ratings.count)
    else
      0
    end
  end

  def review_count
    ratings.count
  end
end
