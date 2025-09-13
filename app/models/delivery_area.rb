# frozen_string_literal: true

# delivery calculations and timing
class DeliveryArea < ApplicationRecord
  include Whodunit::Stampable

  has_many :addresses
  has_many :order_addresses
  has_many :franchises, through: :region
  belongs_to :region

  include StateManagement

  TIME_PERIODS = {
    day: { start: [8, 0], end: [18, 59] },
    dusk: { start: [19, 0], end: [23, 59] },
    night: { start: [0, 0], end: [3, 59] },
    dawn: { start: [4, 0], end: [7, 59] }
  }.freeze

  def as_json(options = {})
    options[:methods] = %i[price price_per_time]
    options[:except] = %i[created_at updated_at]
    super
  end

  def self.ransackable_attributes(_auth_object = nil)
    %i[name id created_at updated_at day_rate dusk_rate night_rate dawn_rate status region_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    [:region]
  end

  def price
    price_per_time
  end

  def price_per_time
    send("#{check_time}_rate")
  end

  def check_time
    current_time = Time.current.in_time_zone
    TIME_PERIODS.each do |period, range|
      return period if within_time_range?(current_time, range[:start], range[:end])
    end
    :day
  end

  private

  def within_time_range?(current_time, start_time, end_time)
    today = current_time.to_date
    start_time = Time.new(today.year, today.month, today.day, *start_time).in_time_zone
    end_time = Time.new(today.year, today.month, today.day, *end_time).in_time_zone
    current_time.between?(start_time, end_time)
  end
end
