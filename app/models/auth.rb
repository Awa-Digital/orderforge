# frozen_string_literal: true

# auth controller
class Auth < ApplicationRecord
  has_secure_password

  validates :email, :account_type, presence: true
  validates :email, uniqueness: true
  validates :account_type,
            inclusion: { in: %w[super accepter processor packager dispatcher],
                         message: "'%<value>s' is not a valid account_type" }

  VISIBLE_ACTIONS = {
    'super' => %w[initiated paid awaiting_processing processing awaiting_packaging packaged delivering completed],
    'accepter' => %w[paid awaiting_processing],
    'processor' => %w[awaiting_processing processing awaiting_packaging],
    'packager' => %w[awaiting_packaging packaged],
    'dispatcher' => %w[packaged delivering]
  }.freeze

  def available_statuses
    VISIBLE_ACTIONS[account_type]
  end
end
