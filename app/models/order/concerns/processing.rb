# frozen_string_literal: true

module Order::Concerns
  # for processing documents
  module Processing
    # LAUNCH_DATE = DateTime.new(2022, 12, 5)

    NOW = DateTime.now.in_time_zone
    CLOSING_TIME = DateTime.new(NOW.year, NOW.month, NOW.day, 18, 59)
    NEXT_STEPS = {
      'initiated' => 'paid',
      'paid' => 'awaiting_processing',
      'awaiting_processing' => 'processing',
      'processing' => 'ready_for_packaging',
      'ready_for_packaging' => 'packaged',
      'packaged' => 'delivering',
      'delivering' => 'completed',
      'completed' => 'nil'
    }.freeze

    NEXT_ACTION = {
      'initiated' => 'verify_payment',
      'paid' => 'accept_order',
      'awaiting_processing' => 'mark_as_processing',
      'processing' => 'mark_as_ready_for_packaging',
      'ready_for_packaging' => 'mark_as_packaged',
      'packaged' => 'mark_as_out_for_delivery',
      'delivering' => 'mark_as_completed'
    }.freeze

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
      update(processing_date: calculate_processing_date)
      Order.update_priorities
    end

    def calculate_processing_date
      return DateTime.now unless order_type == 'next_day_order'

      DateTime.now + 1.day
    end

    def next_step
      NEXT_STEPS[status]
    end

    def next_action
      NEXT_ACTION[status]
    end
  end
end
