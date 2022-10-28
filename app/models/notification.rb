class Notification < ApplicationRecord

  belongs_to :user

  after_create :run_deliveries

  def see
    update(seen: true)
  end

  def run_deliveries
    deliver_sms
    deliver_email
    deliver_push
  end

  def deliver_sms
    # deliver sms if sms notifications are enabled
  end

  def deliver_email
    # deliver email if email notifications are enabled
  end

  def deliver_push
    if user.notification_setting.push == true

      begin
        token = user.user_devices.last.registration_token
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

  def title
    case notification_type
    when 'gift'
      "Hurray! #{user.first_name}"
    when 'following'
      'Yaaaga!'
    when 'redeemed_recipient'
      "Hurray! #{user.first_name}"
    when 'redeemed_sender'
      'Hey, Chief!'
    else
      'Yaaaga! Notification'
    end
  end

  def analytics_label
    case notification_type
    when 'gift'
      'yaaaga_gifts'
    when 'following'
      'yaaaga_followings'
    when 'redeemed_recipient'
      'yaaaga_transactions'
    when 'redeemed_sender'
      'yaaaga_transactions'
    else
      'yaaaga_notificatons'
    end
  end

  def body
    case notification_type
    when 'gift'
      "🔔 @#{sender.username} just sent you #{ActionController::Base.helpers.pluralize(
        order.product_items.sum(:quantity), 'bottle'
      )} from #{order.place.name}! Open the app to redeem it before it expires"
    when 'following'
      "⚡#{follower.full_name}(@#{follower.username}) just followed you on Yaaaga! Open the app to view their profile and follow them back"
    when 'redeemed_recipient'
      "⚡You have successfully redeemed your gift from @#{sender.username} at #{order.place.name}"
    when 'redeemed_sender'
      "⚡@#{order.recipient.user.username} just redeemed your gift of #{ActionController::Base.helpers.pluralize(
        order.product_items.sum(:quantity), 'bottle'
      )} from #{order.place.name}"
    else
      "📣You have a new notification #{user.first_name}, open the app to find out what's new"
    end
  end

  def order
    Order.find_by(reference: order_reference)
  end

  def sender
    User.find_by(id: sender_id)
  end

  def follower
    User.find_by(id: follower_id)
  end

  def image
    case notification_type
    when 'gift'
      order.place.logo_url
    when 'following'
      follower.avatar_url
    else
      'https://res.cloudinary.com/awadigital/image/upload/v1647464460/yaaaga/Yaaaga-Default.jpg'
    end
  end
end
