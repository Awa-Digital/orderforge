class Product < ApplicationRecord
  include StateManagement

  mount_uploader :image, ProductUploader

  belongs_to :category
  belongs_to :subcategory, optional: true
  has_many :product_ingredients
  has_many :ingredients, through: :product_ingredients
  has_many :favourite_items
  has_many :order_items
  has_many :ratings
  has_many :product_purchase_counters
  has_many :product_inventory_items
  has_many :inventories, through: :product_inventory_items
  has_many :franchise_product_prices

  accepts_nested_attributes_for :product_inventory_items

  validates :title,
            :description,
            :amount, presence: true

  after_create :generate_franchise_product_prices

  # NOW = Date.today.in_time_zone

  def as_json(options = {})
    options[:methods] = %i[available category subcategory ingredients review_rating review_count price]
    options[:except] = %i[created_at updated_at user_id subcategory_id category_id]
    super
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[amount description image title]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[category ingredients product_ingredients subcategory]
  end

  def generate_franchise_product_prices
    Franchise.all.each do |franchise|
      franchise_product_prices.find_or_create_by(franchise_id: franchise.id)
    end
  end

  def price(franchise_id = Franchise.first.id)
    franchise_product_prices.find_by(franchise_id:).amount || 0.0
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

  def self.hot_products(time_frame = :week)
    start_date, end_date = case time_frame
                           when :week
                             [1.week.ago.beginning_of_week, 1.week.ago.end_of_week]
                           when :month
                             [1.month.ago.beginning_of_month, 1.month.ago.end_of_month]
                           when :all_time
                             [Time.at(0), Time.current]
                           else
                             raise ArgumentError, "Invalid time frame: #{time_frame}"
                           end

    products = Product.joins(:product_purchase_counters)
                      .where(product_purchase_counters: { created_at: start_date..end_date })
                      .select('products.*, COUNT(product_purchase_counters.id) AS purchase_count')
                      .group('products.id')
                      .order('purchase_count DESC')

    # Filter products based on the available method
    products.select(&:available)
  end
end
