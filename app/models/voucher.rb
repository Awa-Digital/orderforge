class Voucher < ApplicationRecord
  belongs_to :influencer
  has_many :payments

  include StateManagement

  default_scope -> { where('expiration_date > ?', DateTime.current) }
  validates_uniqueness_of :discount_code

  def as_json(options = {})
    # options[:methods] = %i[delivery_charge vat_charge delivery_address discount_amount discounted_price]
    options[:except] = %i[created_at updated_at influencer_id id]
    super
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[title discount_code]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
