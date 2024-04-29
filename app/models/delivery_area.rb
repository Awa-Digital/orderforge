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
    @day_start = Time.new(@now.year, @now.month, @now.day, 8, 0)
    @day_end = Time.new(@now.year, @now.month, @now.day, 18, 59)
    @dusk_start = Time.new(@now.year, @now.month, @now.day, 19, 0)
    @dusk_end = Time.new(@now.year, @now.month, @now.day, 23, 59)
    @night_start = Time.new(@now.year, @now.month, @now.day, 0, 0)
    @night_end = Time.new(@now.year, @now.month, @now.day, 3, 59)
    @dawn_start = Time.new(@now.year, @now.month, @now.day, 4, 0)
    @dawn_end = Time.new(@now.year, @now.month, @now.day, 7, 59)
    if Time.now.in_time_zone.between?(@day_start, @day_end)
      'day'
    elsif Time.now.in_time_zone.between?(@dusk_start, @dusk_end)
      'dusk'
    elsif Time.now.in_time_zone.between?(@night_start, @night_end)
      'night'
    elsif Time.now.in_time_zone.between?(@dawn_start, @dawn_end)
      'dawn'
    end
  end
end
