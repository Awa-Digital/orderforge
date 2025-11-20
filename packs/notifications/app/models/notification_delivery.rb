# frozen_string_literal: true

class NotificationDelivery < ApplicationRecord
  belongs_to :notification

  STATUSES = %w[pending delivered failed].freeze

  validates :channel, presence: true
  validates :status, inclusion: { in: STATUSES }
end
