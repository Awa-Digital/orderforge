# frozen_string_literal: true

module FranchiseAnalytics
  class Summary
    def self.call(franchise:, days: 7)
      new(franchise: franchise, days: days).call
    end

    def initialize(franchise:, days:)
      @franchise = franchise
      @window = Window.for(days: days)
    end

    def call
      current_orders = paid_orders(@window.current_start..@window.current_end)
      previous_orders = paid_orders(@window.previous_start..@window.previous_end)

      {
        franchise_id: @franchise.id,
        days: @window.days,
        pending_orders: @franchise.orders.where(status: %w[initiated paid awaiting_processing]).count,
        revenue: {
          current: current_orders.sum(:total).to_f,
          previous: previous_orders.sum(:total).to_f
        },
        orders: {
          current: current_orders.count,
          previous: previous_orders.count
        },
        visits: visit_counts
      }
    end

    private

    def paid_orders(range)
      @franchise.orders.where(paid: true, created_at: range)
    end

    def visit_counts
      scope = FranchisePageVisit.where(franchise: @franchise)
      {
        current: scope.where(created_at: @window.current_start..@window.current_end).count,
        previous: scope.where(created_at: @window.previous_start..@window.previous_end).count
      }
    end
  end
end
