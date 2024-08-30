# frozen_string_literal: true

# for processing documents
module Processing
  extend ActiveSupport::Concern

  # LAUNCH_DATE = DateTime.new(2022, 12, 5)

  NOW = DateTime.current.in_time_zone
  CLOSING_TIME = DateTime.new(NOW.year, NOW.month, NOW.day, 18, 59)
  NEXT_STEPS = {
    'initiated' => 'paid',
    'paid' => 'awaiting_processing',
    'awaiting_processing' => 'processing',
    'processing' => 'awaiting_packaging',
    'awaiting_packaging' => 'packaged',
    'packaged' => 'delivering',
    'delivering' => 'completed',
    'completed' => 'nil'
  }.freeze

  NEXT_ACTION = {
    'initiated' => { text: 'Verify Payment', endpoint_path: 'verify/' },
    'paid' => { text: 'Accept Order', endpoint_path: 'mark/accept/' },
    'awaiting_processing' => { text: 'Mark as Processing', endpoint_path: 'mark/processing/' },
    'processing' => { text: 'Mark as Ready to be Packaged', endpoint_path: 'mark/awaiting_packaging/' },
    'awaiting_packaging' => { text: 'Mark as Packaged', endpoint_path: 'mark/packaged/' },
    'packaged' => { text: 'Mark as Out for Delivery', endpoint_path: 'mark/delivering/' },
    'delivering' => { text: 'Mark as Completed', endpoint_path: 'mark/completed/' }
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
    return DateTime.current unless order_type == 'next_day_order'

    DateTime.current + 1.day
  end

  def next_step
    NEXT_STEPS[status]
  end

  def next_action
    NEXT_ACTION[status]
  end
end
