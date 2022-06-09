class User < ApplicationRecord
  has_many :orders
  has_many :payments
  has_one :favourite

  has_secure_password

  validates :first_name,
            :last_name,
            :password,
            :password_confirmation,
            :phone_number, presence: true

  validates :email,
            :phone_number, uniqueness: true

  validates :phone_number, length: { is: 13 }
  validates :password, length: { minimum: 8 }

  def as_json(options = {})
    # options[:methods] = %i[total]
    options[:except] = %i[created_at updated_at password_digest]
    super
  end
end
