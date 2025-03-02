class Address < ApplicationRecord
  belongs_to :user
  belongs_to :delivery_area
  # has_many :orders

  validates :street,
            :state, presence: true

  def as_json(options = {})
    options[:methods] = %i[city as_string]
    options[:except] = %i[created_at updated_at user_id delivery_area_id]
    super
  end

  def city
    delivery_area.name
  end

  def as_string
    "#{house_number} #{street}, #{city}, #{state}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[country created_at delivery_area_id house_number id state street updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[delivery_area user]
  end
end
