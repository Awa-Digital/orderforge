class AdminUser < ApplicationRecord
  include AASM

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # has_secure_password
  validates :email,
            :phone,
            :first_name,
            :last_name, presence: true

  aasm column: 'status' do
    state :active, initial: true
    state :disabled

    event :activate do
      transitions to: :active # , after: :send_approval_email
    end

    event :disable do
      transitions to: :disabled
    end
  end

  def get_token
    generate_token(self)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      avatar
      created_at
      email
      first_name
      id
      last_name
      phone
      remember_created_at
      reset_password_sent_at
      reset_password_token
      status
      super_user
      updated_at
    ]
  end
end
