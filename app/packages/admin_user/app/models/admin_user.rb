class AdminUser < ApplicationRecord
  include AASM

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  belongs_to :franchise, optional: true
  has_many :reports

  # has_secure_password
  validates :email,
            :phone,
            :first_name,
            :last_name, presence: true

  validate :must_be_super_user_or_have_franchise

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
      franchise_id
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

  def self.ransackable_associations(_auth_object = nil)
    ["franchise"]
  end

  private

  def must_be_super_user_or_have_franchise
    return unless !super_user && franchise_id.blank?

    errors.add(:base, "Admin user must either be a super user or belong to a franchise")
  end
end
