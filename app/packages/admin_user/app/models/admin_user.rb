class AdminUser < ApplicationRecord
  include AASM

  has_secure_password
  validates :email,
            :phone,
            :first_name,
            :last_name, presence: true

  aasm column: 'status' do
    state :active, initial: true
    state :disabled

    event :activate do
      transitions to: :active #, after: :send_approval_email
    end

    event :disable do
      transitions to: :disabled
    end
  end

  def get_token
    generate_token(self)
  end


end
