class Flutterwave
  attr_accessor :public_key, :secret_key, :encryption_key, :live, :base_url, :conn

  def initialize(pub, sec, enc)
    @public_key = pub
    @secret_key = sec
    @encryption_key = enc
    @live = confirm_live
    @base_url = rave_url
    @conn = Faraday.new(url: @base_url) do |f|
      f.headers['Authorization'] = "Bearer #{@secret_key}"
      f.headers['Content-Type'] = 'application/json'
    end
  end

  def confirm_live
    ENV['MEDIA_SUBFOLDER'] == 'production'
  end

  def rave_url
    if @live
      'https://api.flutterwave.com/v3/'
    else
      'https://rave-api-v2.herokuapp.com/v3/'
    end
  end

  def verify_by_reference(tx_ref)
    url = "transactions/verify_by_reference?tx_ref=#{tx_ref}"
    response = @conn.get url
    JSON.parse response.body
  end
end
