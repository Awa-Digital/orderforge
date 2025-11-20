# frozen_string_literal: true

class WalletTransaction < ApplicationRecord
  belongs_to :wallet
  belongs_to :source, polymorphic: true, optional: true

  KINDS = %w[credit_pending debit_pending credit_available debit_available withdraw].freeze

  validates :kind, inclusion: { in: KINDS }
  validates :reference, presence: true, uniqueness: true
  validates :amount_cents, numericality: { greater_than: 0 }
end
