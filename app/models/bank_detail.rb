class BankDetail < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :bankable, polymorphic: true

  after_create :save_to_paystack

  def save_to_paystack
    register_recipient if account_number.present?
  end

  def register_recipient
    data = Integrations::Paystack::Accounts.add_recipient(self)
    update(recipient_code: data["data"]["recipient_code"])
  end
end
