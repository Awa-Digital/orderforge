class Address < ApplicationRecord
  belongs_to :user
  # has_many :orders

  validates :street,
            :city,
            :state, presence: true

  def as_json(options = {})
    # options[:methods] = %i[total]
    options[:except] = %i[created_at updated_at user_id]
    super
  end
end
