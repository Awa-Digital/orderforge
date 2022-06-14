class FirePush
  def initialize
    @fcm = FCM.new(
      ENV['FIREBASE_API_TOKEN'],
      ENV['FIREBASE_CREDENTIALS'],
      ENV['FIREBASE_PROJECT_ID']
    )
  end

  def push(token, notify)
    message = {
      token: token,
      name: notify[:name],
      notification: notification(notify),
      android: android_config(notify),
      apns: apns_config(notify),
      fcm_options: fcm_options(notify)
    }

    send = @fcm.send_v1(message)
    send[:response]
  end

  def notification(notify)
    {
      title: notify[:title],
      body: notify[:body],
      image: notify[:image_url]
    }
  end

  def apns_config(notify)
    {
      payload: {
        aps: {
          badge: 0,
          "mutable-content": 1
        }
      },
      fcm_options: { image: notify[:image_url] }
    }
  end

  def android_config(notify)
    {
      notification: {
        image: notify[:image_url]
      }
    }
  end

  def fcm_options(notify)
    {
      analytics_label: notify[:analytics_label]
    }
  end
end
