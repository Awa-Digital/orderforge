class AdminUser < ApplicationRecord
  has_secure_password
  validates :email,
           :phone,
           :first_name,
           :last_name, presence: true

  def get_token
    generate_token(self)
  end
end
