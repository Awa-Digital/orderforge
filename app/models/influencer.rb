class Influencer < ApplicationRecord
  include StateManagement
  has_many :vouchers
  has_many :orders
  has_many :affiliate_views

  has_secure_password validations: false

  validates :email, uniqueness: true

  validates :name,
            :instagram_handle,
            :email,
            :phone_number, presence: true

  before_create :generate_slug

  def as_json(options = {})
    options[:methods] = %i[affiliate_link]
    options[:except] = %i[password_digest]
    super
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name instagram_handle twitter_handle email]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def generate_slug
    loop do
      self.slug = SecureRandom.alphanumeric(6).downcase
      break unless Influencer.exists?(slug: slug)
    end
  end

  def affiliate_link
    "https://jazzysburger.com?ref=#{slug}"
  end
end
