# frozen_string_literal: true

module Order::Concerns
  module Processing
    # LAUNCH_DATE = DateTime.new(2022, 12, 5)
    NOW = DateTime.now.in_time_zone
    CLOSING_TIME = DateTime.new(NOW.year, NOW.month, NOW.day, 18, 59)

    def processed_today
      return false unless processing_date.present?

      processing_date.to_date == Date.today.in_time_zone.to_date
    end

    def order_type
      # return 'preorder' if LAUNCH_DATE > DateTime.now

      return 'next_day_order' if NOW > CLOSING_TIME

      'order'
    end

    def set_processing_data
      update(processing_date: calculate_processing_date, priority: calculate_priority)
      Order.update_priorities
    end

    def calculate_processing_date
      return DateTime.now unless order_type == 'next_day_order'

      DateTime.now + 1.day
    end
  end
end
