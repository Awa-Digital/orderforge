class Texter
  def initialize
    @conn = Faraday.new(url: ENV.fetch('TXTR', nil)) do |f|
      f.headers['Authorization'] = "Bearer #{ENV.fetch('TXTR_KEY', nil)}"
      f.headers["Content-Type"] = "application/json"
    end
  end

  def otp(recipient, otp)
    url = "/v2/app/sendsms"

    datas = {
      "message" => "<#> Yaaaga: Your one time password is #{otp}\n\nLet your friends feel love",
      "sender_name" => "Yaaaga",
      "recipients" => recipient
    }

    response = @conn.post do |req|
      req.url url
      req.body = datas.to_json
    end

    raise "An error with this response code #{response.status} has occurred. Response: #{response.body}" unless response.status == 200 || response.status == 201

    JSON.parse(response.body)
  end
end
