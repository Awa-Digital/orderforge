# frozen_string_literal: true

module FranchiseAnalytics
  class Timeseries
    def self.call(franchise:, days: 7)
      new(franchise: franchise, days: days).call
    end

    def initialize(franchise:, days:)
      @franchise = franchise
      @window = Window.for(days: days)
    end

    def call
      (@window.current_start.to_date..Time.zone.today).map do |date|
        range = date.in_time_zone.beginning_of_day..date.in_time_zone.end_of_day
        orders = @franchise.orders.where(paid: true, created_at: range)
        {
          date: date.iso8601,
          orders: orders.count,
          revenue: orders.sum(:total).to_f
        }
      end
    end
  end
end
