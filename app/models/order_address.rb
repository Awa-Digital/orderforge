class OrderAddress < ApplicationRecord
  belongs_to :order
  belongs_to :delivery_area, optional: true

  def as_json(options = {})
    options[:methods] = %i[city]
    options[:except] = %i[created_at updated_at]
    super
  end

  def city
    return nil unless self.delivery_area.present?
    delivery_area.name
  end
end
