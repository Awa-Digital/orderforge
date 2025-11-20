# frozen_string_literal: true

class Wallet < ApplicationRecord
  belongs_to :franchise
  has_many :wallet_transactions, dependent: :restrict_with_error

  validates :available_balance_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :pending_balance_cents, numericality: { greater_than_or_equal_to: 0 }

  def available_balance
    (available_balance_cents || 0) / 100.0
  end

  def pending_balance
    (pending_balance_cents || 0) / 100.0
  end
end
