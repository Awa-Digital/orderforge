# frozen_string_literal: true

# user model
class User < ApplicationRecord
  include StateManagement
  mount_uploader :avatar, AvatarUploader

  extend FriendlyId
  friendly_id :first_name, use: :slugged

  has_many :orders, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_one :favourite, dependent: :destroy
  has_one :notification_setting, dependent: :destroy
  has_many :notifications
  has_many :addresses, dependent: :destroy
  has_many :devices, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_one :password_reset_token, dependent: :destroy

  has_secure_password validations: false
  validate :setting_password

  validate :otp_validation, on: :create

  validates :first_name,
            :last_name,
            :phone_number, presence: true

  validates :email,
            :phone_number, uniqueness: true

  validates :phone_number, length: { is: 13 }
  validates :password, length: { minimum: 8 }, allow_blank: true

  after_create :generate_attributes, :update_account_verification
  before_destroy :remove_account_verification

  # scope :favourites, -> (user) { where(products.liked:  true)}

  def as_json(options = {})
    # options[:methods] = %i[total]
    options[:except] = %i[created_at updated_at password_digest phone_otp]
    super
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[first_name last_name email phone_number]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def generate_attributes
    create_favourite unless favourite.present?
    create_notification_setting unless notification_setting.present?
    deliver_email
  end

  def setting_password
    return if password_digest.blank?

    errors[:password_confirmation] << "doesn't match password" unless @password_confirmation == password
  end

  def update_account_verification
    account = AccountVerification.find_by(phone: phone_number)
    return unless account

    account.update(phone_verified: true, user_id: id)
    account.process_email_verification
  end

  def remove_account_verification
    @account = AccountVerification.find_by(user_id: id)
    @account&.destroy
  end

  def products
    prods = Product.all.select(&:available)
    liked_product_ids = favourite.favourite_items.where(product_id: prods.map(&:id)).pluck(:product_id)

    prods.each do |p|
      p.liked = liked_product_ids.include?(p.id)
    end

    prods
  end

  def favourites
    products.select { |p| p.liked == true }
  end

  def product(id)
    p = Product.find(id)
    p.liked = p.liked?(self)
    p
  end

  def cart
    @cart = orders.find_by(status: 'initiated')
    if @cart.present?
      @cart
    else
      start_cart
    end
  end

  def start_cart
    last_order = orders.find_by(paid: true).last
    recent_franchise_id = last_order&.franchise_id ? last_order.franchise_id : Franchise.first.id

    orders.find_or_create_by!(status: 'initiated', franchise_id: recent_franchise_id)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def update_password_reset_token
    password_reset_token.update_token
  end

  def deliver_email
    # make this asynchronous with retries
    deliver_verification_email
    puts '------ Verification Email Sent --------'
  rescue StandardError
    puts "Couldn't send verification email"
  end

  def inactive
    active == false
  end

  def verification_url
    "#{ENV.fetch('APP_BASE_URL', nil)}/user/verify/#{AccountVerification.find_by(email:).email_token}"
  end

  def deliver_verification_email
    UserMailer.with(id:).welcome.deliver
  end

  def deliver_reset_password_email
    UserMailer.with(id:).reset.deliver
  end

  def reset_url
    "#{ENV.fetch('APP_BASE_URL', nil)}/reset-password/#{password_reset_token.token}"
  end

  def total_spends
    return 0 if orders.where(paid: true).count.zero?

    # puts "Total Spends for #{id}: #{orders.where(paid: true).sum(&:order_total)}"
    orders.where(paid: true).sum(&:order_total)
  end

  def update_spend_score
    update_attribute :spend_score, orders.where(paid: true).sum(&:order_total)
  end

  private

  def otp_validation
    account = AccountVerification.find_by(phone: phone_number)
    errors.add :otp, 'is invalid. Resend new OTP or try again' unless account.present?

    return unless account

    errors.add :phone_number, 'is not valid' unless account.valid_phone?
    errors.add :otp, 'is invalid. Resend new OTP or try again' if account.otp != phone_otp
  end
end
