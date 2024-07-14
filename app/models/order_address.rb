class OrderAddress < ApplicationRecord
  belongs_to :order
  belongs_to :delivery_area, optional: true

  def as_json(options = {})
    options[:methods] = %i[city price]
    options[:except] = %i[created_at updated_at]
    super
  end

  def city
    return nil unless delivery_area.present?

    delivery_area.name
  end

  def price
    delivery_area&.price_per_time
  end
end
