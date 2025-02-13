class Influencer < ApplicationRecord
  include StateManagement
  has_many :vouchers
  has_many :orders
  has_many :affiliate_views
  has_one :bank_detail, as: :bankable, dependent: :destroy
  has_many :transactions, as: :transactionable

  has_secure_password validations: false

  validates :email, uniqueness: true

  validates :name,
            :instagram_handle,
            :email,
            :phone_number, presence: true

  before_create :generate_slug
  after_create :generate_bank_detail

  def as_json(options = {})
    options[:methods] = %i[affiliate_link bank_detail generated_orders]
    options[:except] = %i[password_digest]
    super
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name instagram_handle twitter_handle email]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def generate_bank_detail
    create_bank_detail
  end

  def generated_orders
    orders.count
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
    amount = order.total * 0.2
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

  def generate_slug
    loop do
      self.slug = SecureRandom.alphanumeric(6).downcase
      break unless Influencer.exists?(slug: slug)
    end
  end

  def affiliate_link
    "https://jazzysburger.com?ref=#{slug}"
  end
end
