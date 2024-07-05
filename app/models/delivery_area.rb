# frozen_string_literal: true

# delivery calculations and timing
class DeliveryArea < ApplicationRecord
  has_many :addresses
  has_many :order_addresses
  belongs_to :region

  include StateManagement

  def as_json(options = {})
    options[:methods] = %i[price price_per_time]
    options[:except] = %i[created_at updated_at]
    super
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end

  def self.ransackable_associations(_auth_object = nil)
    [:region]
  end

  def price
    day_rate
  end

  def price_per_time
    case check_time
    when 'day'
      day_rate || 2000
    when 'dusk'
      dusk_rate || 2000
    when 'night'
      night_rate || 2000
    when 'dawn'
      dawn_rate || 2000
    end
  end

  def check_time
    @now = Date.today.in_time_zone

    if day?(@now)
      'day'
    elsif dusk?(@now)
      'dusk'
    elsif night?(@now)
      'night'
    elsif dawn?(@now)
      'dawn'
    end
  end

  def day?(now)
    day_start = Time.new(now.year, now.month, now.day, 8, 0)
    day_end = Time.new(now.year, now.month, now.day, 18, 59)
    return true if Time.now.in_time_zone.between?(day_start, day_end)

    false
  end

  def dusk?(now)
    dusk_start = Time.new(now.year, now.month, now.day, 19, 0)
    dusk_end = Time.new(now.year, now.month, now.day, 23, 59)
    return true if Time.now.in_time_zone.between?(dusk_start, dusk_end)

    false
  end

  def night?(now)
    night_start = Time.new(now.year, now.month, now.day, 0, 0)
    night_end = Time.new(now.year, now.month, now.day, 3, 59)
    return true if Time.now.in_time_zone.between?(night_start, night_end)

    false
  end

  def dawn?(now)
    dawn_start = Time.new(now.year, now.month, now.day, 4, 0)
    dawn_end = Time.new(now.year, now.month, now.day, 7, 59)
    return true if Time.now.in_time_zone.between?(dawn_start, dawn_end)

    false
  end
end
