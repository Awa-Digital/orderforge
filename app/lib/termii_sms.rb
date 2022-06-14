class TermiiSms
  def initialize
    @conn = Faraday.new(url: ENV['TERMII_URL']) do |f|
      f.headers['Content-Type'] = 'application/json'
    end
  end

  def send_otp(recipient, otp)
    url = '/api/sms/send'

    datas = {
      'to' => recipient,
      'from' => 'N-Alert',
      'sms' => "Your Yaaaga confirmation code is #{otp}. Valid for 10 minutes, one-time use only.",
      'type' => 'plain',
      'channel' => 'dnd',
      'api_key' => ENV['TERMII_KEY']
    }

    response = @conn.post do |req|
      req.url url
      req.body = datas.to_json
    end

    if response.status == 200 || response.status == 201
      response = JSON.parse(response.body)
    else
      raise "An error with this response code #{response.status} has occurred. Response: #{response.body}"
    end
  end

  # def otp_whatsapp(recipient, otp)
  #   url = "/api/sms/send"

  # 	datas = {
  #     "to" => recipient,
  #     "from" => "N-Alert",
  #     "sms" => "Your Yaaaga confirmation code is #{otp}. Valid for 10 minutes, one-time use only.",
  #     "type" => "plain",
  #     "channel" => "whatsapp",
  #     "api_key" => ENV["TERMII_KEY"]
  #   }

  #   response = @conn.post do |req|
  # 		req.url url
  # 		req.body = datas.to_json
  # 	end

  # 	if response.status == 200 || response.status == 201
  # 		response = JSON.parse(response.body)
  # 	else
  # 		raise "An error with this response code #{response.status} has occurred. Response: #{response.body}"
  # 	end
  # end
end
