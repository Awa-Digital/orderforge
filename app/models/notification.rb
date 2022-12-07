class Notification < ApplicationRecord
  belongs_to :user

  after_create :run_deliveries

  def see
    update(seen: true)
  end

  def run_deliveries
    # deliver_sms
    deliver_push
    deliver_email
  end

  def deliver_sms
    # deliver sms if sms notifications are enabled
  end

  def deliver_email
    # deliver email if email notifications are enabled
  end

  def deliver_push
    if user.notification_setting.push_notifications == true
      begin
        token = user.devices.last.device_token
        FirePush.new.push(token, construct)
      rescue StandardError
        puts '########### NOTIFICATION DELIVERY FAILING ###########'
      end

    else
      puts "push notifications turned off for #{user.full_name}"
    end
  end

  def construct
    {
      title: title,
      body: body,
      image_url: image,
      analytics_label: analytics_label
    }
  end

  def order
    Order.find_by(reference: order_reference)
  end

  def image
    'https://res.cloudinary.com/awadigital/image/upload/v1647464460/yaaaga/Yaaaga-Default.jpg'
  end
end
