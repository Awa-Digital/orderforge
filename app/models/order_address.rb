class OrderAddress < ApplicationRecord
  belongs_to :order
  belongs_to :delivery_area, optional: true

  def as_json(options = {})
    # options[:methods] = %i[delivery_charge]
    options[:except] = %i[created_at updated_at]
    super
  end
end
