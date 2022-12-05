# frozen_string_literal: true

# delivery calculations and timing
class DeliveryArea < ApplicationRecord
  has_many :addresses
  has_many :order_addresses

  NOW = Date.today
  DAY_START = Time.new(NOW.year, NOW.month, NOW.day, 8, 0)
  DAY_END = Time.new(NOW.year, NOW.month, NOW.day, 18, 59)
  DUSK_START = Time.new(NOW.year, NOW.month, NOW.day, 19, 0)
  DUSK_END = Time.new(NOW.year, NOW.month, NOW.day, 23, 59)
  NIGHT_START = Time.new(NOW.year, NOW.month, NOW.day, 0, 0)
  NIGHT_END = Time.new(NOW.year, NOW.month, NOW.day, 3, 59)
  DAWN_START = Time.new(NOW.year, NOW.month, NOW.day, 4, 0)
  DAWN_END = Time.new(NOW.year, NOW.month, NOW.day, 7, 59)

  def as_json(options = {})
    options[:methods] = %i[price]
    options[:except] = %i[created_at updated_at]
    super
  end

  def price
    # 2000
    case check_time
    when 'day'
      day_rate
    when 'dusk'
      2000
    when 'night'
      2000
    when 'dawn'
      2000
    end
  end

  def check_time
    if Time.now.between?(DAY_START, DAY_END)
      'day'
    elsif Time.now.between?(DUSK_START, DUSK_END)
      'dusk'
    elsif Time.now.between?(NIGHT_START, NIGHT_END)
      'night'
    elsif Time.now.between?(DAWN_START, DAWN_END)
      'dawn'
    end
  end
end
