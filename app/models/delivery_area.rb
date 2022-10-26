class DeliveryArea < ApplicationRecord

  has_many :addresses

  def as_json(options = {})
    # options[:methods] = %i[total]
    options[:except] = %i[created_at updated_at]
    super
  end
end
