class AdminUser < ApplicationRecord
  delegate :can?, :cannot?, to: :ability
  include AASM

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  belongs_to :department
  # belongs_to :franchise, through: :department
  has_many :reports

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
      franchise_id
      id
      last_name
      phone
      remember_created_at
      reset_password_sent_at
      reset_password_token
      status
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["franchise"]
  end

  def super_user?
    department == Department.find_by(name: "Super Admin")
  end

  def franchise
    department&.franchise
  end
end
