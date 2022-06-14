class SendgridApi
  def initialize
    @conn = Faraday.new(url: ENV['SENDGRID_URL']) do |f|
      f.headers['Authorization'] = "Bearer #{ENV['SENDGRID_API_KEY']}"
      f.headers['Content-Type'] = 'application/json'
    end
  end

  def get_lists
    url = '/v3/marketing/lists'
    response = @conn.get(url)
    if response.status == 200
      list = JSON.parse(response.body)['result']
    else
      raise "An error with this response code #{response.status} has occurred. Response: #{response.body}"
    end
  end

  def yaaaga_main_list
    list = get_lists
    list.select { |li| li['name'] == 'Yaaaga Users' }[0]
  end

  def add_waiter(email)
    url = '/v3/marketing/contacts'
    account = {
      'list_ids' => ['1a5bcba1-a2ec-4e17-883f-1b022f9c66dd'],
      'contacts' => [{
        'email' => email
      }]
    }
    response = @conn.put do |req|
      req.url url
      req.body = account.to_json
    end
    if response.status == 202
      response.body
    else
      raise "An error with this response code #{response.status} has occurred. Response: #{response.body}"
    end
  end

  def add_contact(user)
    url = '/v3/marketing/contacts'
    id = yaaaga_main_list['id']
    account = {
      'list_ids' => [id],
      'contacts' => [{
        'email' => user.email,
        'first_name' => user.first_name,
        'last_name' => user.last_name,
        'phone_number' => user.phone
      }]
    }
    response = @conn.put do |req|
      req.url url
      req.body = account.to_json
    end
    if response.status == 202
      response.body
    else
      raise "An error with this response code #{response.status} has occurred. Response: #{response.body}"
    end
  end
end
