class Influencer < ApplicationRecord
  include StateManagement
  has_many :vouchers
  has_secure_password validations: false

  validates :name,
            :instagram_handle,
            :email, presence: true

  def as_json(options = {})
    # options[:methods] = %i[address]
    options[:except] = %i[password_digest]
    super
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[name instagram_handle twitter_handle email]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
