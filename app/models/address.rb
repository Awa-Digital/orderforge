class Address < ApplicationRecord
  belongs_to :user
  belongs_to :delivery_area
  # has_many :orders

  validates :street,
            :state, presence: true

  def as_json(options = {})
    options[:methods] = %i[city]
    options[:except] = %i[created_at updated_at user_id delivery_area_id]
    super
  end

  def city
    delivery_area.name
  end 

end
