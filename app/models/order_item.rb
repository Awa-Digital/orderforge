class OrderItem < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :order
  belongs_to :product
  has_many :removables, dependent: :destroy

  before_save :calculate_subtotal
  after_save :update_parents

  def as_json(options = {})
    options[:methods] = %i[subtotal base_price product removables]
    options[:except] = %i[created_at updated_at order_id]
    super
  end

  def calculate_subtotal
    amount = order&.franchise_id ? product.price(order&.franchise_id) : product.price
    self.subtotal = (quantity * (amount > 0.0 ? amount : product.amount))
  end

  def update_parents
    order.update_totals if order.present?
  end

  def base_price
    product.amount
  end
end
