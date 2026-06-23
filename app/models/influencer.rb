class Influencer < ApplicationRecord
  include StateManagement
  include Whodunit::Stampable if defined?(Rails::Server)
  extend FriendlyId

  friendly_id :name, use: :slugged

  mount_uploader :verification_document, VerificationUploader
  mount_uploader :business_storefront_image, AffiliateStoreFrontUploader

  has_many :vouchers
  has_many :orders
  has_many :affiliate_views
  has_one :bank_detail, as: :bankable, dependent: :destroy
  has_many :transactions, as: :transactionable

  has_secure_password validations: false

  validates :email, uniqueness: true
  validates :slug, presence: true

  validates :name,
            :instagram_handle,
            :email,
            :phone_number, presence: true

  validates :verification_document, presence: true, allow_blank: true
  validates :verification_type, presence: true, allow_blank: true

  after_create :generate_bank_detail

  scope :verified, -> { where(verified: true) }
  scope :pending, -> { where(verified: false).where.not(verification_video_url: nil) }

  def as_json(options = {})
    options[:methods] = %i[affiliate_link bank_detail generated_orders]
    options[:except] = %i[password_digest]
    super
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name slug instagram_handle twitter_handle email]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def generate_bank_detail
    create_bank_detail
  end

  def generated_orders
    orders
      .where(paid: true)
      .count
  end

  def add_bank(bank, account)
    data = {
      bank_code: bank["code"],
      bank_name: bank["name"],
      currency: bank["currency"],
      country: bank["country"],
      account_number: account["account_number"],
      account_name: account["account_name"]
    }

    raise "Could not save bank details" unless bank_detail.update(data)

    bank_detail.register_recipient
  end

  def credit_wallet(order)
    return if order.paid_influencer == true

    rate = (commission_rate.presence || 20) / 100.0
    amount = order.total * rate
    Rails.logger.info("Credit wallet for influencer #{id} with amount #{amount}")
    update(balance: balance + amount)
    transactions.create(
      transaction_type: "credit",
      amount: amount,
      reference: "#{order.reference}-influencer-credit",
      narration: "Commission for Payment on Order ##{order.id}"
    )
  end

  def withdraw(amount)
    raise "Insufficient fund" unless balance >= amount

    transaction = transactions.create(
      transaction_type: "debit",
      amount: amount,
      reference: "influencer-#{id}-debit-#{DateTime.now}".gsub(":", "-").gsub("+", "-"),
      narration: "Withdrawal from Earned Commissions"
    )

    Integrations::Paystack::Accounts.transfer(bank_detail, transaction)
  rescue StandardError => e
    puts e
  else
    update(balance: balance - amount)
  end

  private

  def affiliate_link
    "#{AppBranding::URL}?ref=#{slug}"
  end
end
