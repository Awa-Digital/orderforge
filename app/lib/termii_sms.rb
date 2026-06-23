class TermiiSms
  def initialize
    @conn = Faraday.new(url: ENV.fetch('TERMII_URL', nil)) do |f|
      f.headers['Content-Type'] = 'application/json'
    end
  end

  def send_otp(recipient, otp)
    datas = {
      'to' => recipient,
      'from' => 'N-Alert',
      'sms' => "Your #{AppBranding::NAME} confirmation code is #{otp}. Valid for 10 minutes, one-time use only.",
      'type' => 'plain',
      'channel' => 'dnd',
      'api_key' => ENV.fetch('TERMII_KEY', nil)
    }

    send_msg(datas)
  end

  def send_marketing_sms(recipient, text)
    datas = {
      'to' => recipient,
      'from' => 'N-Alert',
      'sms' => text,
      'type' => 'plain',
      'channel' => 'dnd',
      'api_key' => ENV.fetch('TERMII_KEY', nil)
    }

    send_msg(datas)
  end

  def send_msg(data)
    url = '/api/sms/send'

    response = @conn.post do |req|
      req.url url
      req.body = data.to_json
    end

    raise "An error with this response code #{response.status} has occurred. Response: #{response.body}" unless response.status == 200 || response.status == 201

    JSON.parse(response.body)
  end
end
