class Card
  def initialize(flw)
    @flw = flw
    @type = 'card'
  end

  def initiate_charge(payload)
    url = "charges?type=#{@type}"
    data = {
      client: encrypt(payload)
    }
    response = @flw.conn.post do |req|
      req.url url
      req.body = data.to_json
    end
    puts response.body
  end

  def encrypt(payload)
    cipher = OpenSSL::Cipher.new 'des-ede3'
    cipher.encrypt # Call this before setting key
    cipher.key = @flw.encryption_key
    text = payload.to_json
    cipher_text = cipher.update text
    cipher_text << cipher.final
    Base64.encode64 cipher_text
  end
end
