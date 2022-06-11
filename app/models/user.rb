class User < ApplicationRecord
  has_many :orders
  has_many :payments
  has_one :favourite
  has_one :notification_setting
  has_many :addresses

  has_secure_password

  validates :first_name,
            :last_name,
            :password,
            :password_confirmation,
            :phone_number, presence: true

  validates :email,
            :phone_number, uniqueness: true

  validates :phone_number, length: { is: 13 }
  validates :password, length: { minimum: 8 }

  after_create :generate_attributes

  # scope :favourites, -> (user) { where(products.liked:  true)}

  def as_json(options = {})
    # options[:methods] = %i[total]
    options[:except] = %i[created_at updated_at password_digest]
    super
  end

  def generate_attributes
    create_favourite
    create_notification_setting
  end

  def products
    prods = Product.all
    prods.each do |p|
      p.liked = p.liked?(self)
    end
    prods
  end

  def favourites
    products.select { |p| p.liked == true }
  end

  def product(id)
    p = Product.find(id)
    p.liked = p.liked?(self)
    p
  end

  def cart
    orders.find_by(status: 'initiated')
  end

  def start_cart
   orders.find_or_create_by!(status: 'initiated')
  end
end
