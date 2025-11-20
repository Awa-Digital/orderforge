# frozen_string_literal: true

class FranchisePageVisit < ApplicationRecord
  belongs_to :franchise
  belongs_to :user, optional: true

  validates :visitor_uuid, presence: true
end
