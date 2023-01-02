class OrderStatusStamp < ApplicationRecord
  belongs_to :auth
  belongs_to :order

  def as_json(options = {})
    options[:methods] = %i[message authorizer]
    # options[:except] = %i[created_at place_id recipient_id]
    super
  end

  def message
    if action_name == 'accepted'
      'accepted order'
    else
      "updated status of order to #{action_name}"
    end
  end

  def authorizer
    auth.email
  end
end
