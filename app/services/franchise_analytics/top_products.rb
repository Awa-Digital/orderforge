# frozen_string_literal: true

module FranchiseAnalytics
  class TopProducts
    def self.call(franchise:, days: 7, limit: 10)
      new(franchise: franchise, days: days, limit: limit).call
    end

    def initialize(franchise:, days:, limit:)
      @franchise = franchise
      @days = days
      @limit = limit
    end

    def call
      range = Window.for(days: @days).current_start..Time.zone.now
      OrderItem.joins(:order, :product)
               .where(orders: { franchise_id: @franchise.id, paid: true, created_at: range })
               .group('products.id', 'products.title')
               .order(Arel.sql('SUM(order_items.quantity) DESC'))
               .limit(@limit)
               .pluck('products.title', Arel.sql('SUM(order_items.quantity)'))
               .map { |title, qty| { product: title, quantity: qty.to_i } }
    end
  end
end
