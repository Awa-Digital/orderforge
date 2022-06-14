class Texter
  def initialize
    @conn = Faraday.new(url: ENV['TXTR']) do |f|
    	f.headers['Authorization'] = 'Bearer '+ENV["TXTR_KEY"]
    	f.headers["Content-Type"] = "application/json"
   	end
  end

  def otp(recipient, otp)
    url = "/v2/app/sendsms"

		datas = {
				"message" => "<#> Yaaaga: Your one time password is "+otp+"\n\nLet your friends feel love",
        "sender_name" => "Yaaaga",
        "recipients" => recipient
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
end
