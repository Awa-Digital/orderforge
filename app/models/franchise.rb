class Franchise < ApplicationRecord
  include StateManagement
  has_many :franchise_product_prices
  has_one :franchise_address

  validates :title, uniqueness: true

  accepts_nested_attributes_for :franchise_address

  def as_json(options = {})
    options[:methods] = %i[address]
    # options[:except] = %i[created_at updated_at]
    super
  end

  def address
    franchise_address
  end
end
