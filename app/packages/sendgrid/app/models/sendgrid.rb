# frozen_string_literal: true

# Sendgrid Emails & Email Lists
class Sendgrid
  def initialize
    @conn = CONN
  end

  def self.lists
    url = '/v3/marketing/lists'
    response = CONN.get(url)
    unless response.status == 200
      raise "An error with this response code #{response.status} has occurred. Response: #{response.body}"
    end

    JSON.parse response.body
  end

  def add_contacts(user)
    url = '/v3/marketing/contacts'
    account = list(user, ENV['SENDGRID_LIST'])
    response = @conn.put do |req|
      req.url url
      req.body = account.to_json
    end
    unless response.status == 202
      raise "An error with this response code #{response.status} has occurred. Response: #{response.body}"
    end

    response.body
  end

  def list(user, list)
    list_id = Sendgrid.lists['result'].detect { |l| l['name'] == list }['id']
    {
      'list_ids' => [list_id],
      'contacts' => [{
        'email' => user.email,
        'first_name' => user.first_name,
        'last_name' => user.last_name
      }]
    }
  end

  CONN = Faraday.new(url: ENV['SENDGRID_URL']) do |f|
    f.headers['Authorization'] = "Bearer #{ENV['SENDGRID_API_KEY']}"
    f.headers['Content-Type'] = 'application/json'
  end
end
