# frozen_string_literal: true

module FranchiseAnalytics
  class Window
    MAX_DAYS = 90

    attr_reader :days, :current_start, :current_end, :previous_start, :previous_end

    def self.for(days: 7, time_zone: Time.zone)
      new(days: days, time_zone: time_zone)
    end

    def initialize(days:, time_zone: Time.zone)
      @days = days.to_i.clamp(1, MAX_DAYS)
      @time_zone = time_zone
      @current_end = @time_zone.now
      @current_start = (@time_zone.today - (@days - 1)).in_time_zone(@time_zone).beginning_of_day
      prev_last = @current_start.to_date - 1.day
      @previous_end = prev_last.in_time_zone(@time_zone).end_of_day
      @previous_start = (prev_last - (@days - 1)).in_time_zone(@time_zone).beginning_of_day
    end
  end
end
