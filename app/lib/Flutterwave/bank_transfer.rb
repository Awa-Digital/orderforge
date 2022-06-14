# Pay with Bank Transfer feature
class BankTransfer
  def initialize(flw)
    @flw = flw
  end

  def initiate_charge(payload)
    url = 'charges?type=bank_transfer'
    response = @flw.conn.post do |req|
      req.url url
      req.body = payload.to_json
    end
    response.body
  end
end
