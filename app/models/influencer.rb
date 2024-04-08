class Influencer < ApplicationRecord
  include StateManagement
  has_many :vouchers
  has_secure_password validations: false

  validates :name,
            :instagram_handle,
            :email, presence: true

  def as_json(options = {})
    # options[:methods] = %i[address]
    options[:except] = %i[password_digest]
    super
  end
end
