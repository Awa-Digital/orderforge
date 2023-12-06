# frozen_string_literal: true

# Sendgrid Emails & Email Lists
class Sendgrid
  def initialize
    @conn = CONN
  end

  def self.lists
    url = '/v3/marketing/lists'
    response = CONN.get(url)
    raise "An error with this response code #{response.status} has occurred. Response: #{response.body}" unless response.status == 200

    JSON.parse response.body
  end

  def add_contacts(user)
    url = '/v3/marketing/contacts'
    account = list(user, ENV.fetch('SENDGRID_LIST', nil))
    response = @conn.put do |req|
      req.url url
      req.body = account.to_json
    end
    raise "An error with this response code #{response.status} has occurred. Response: #{response.body}" unless response.status == 202

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

  CONN = Faraday.new(url: ENV.fetch('SENDGRID_URL', nil)) do |f|
    f.headers['Authorization'] = "Bearer #{ENV.fetch('SENDGRID_API_KEY', nil)}"
    f.headers['Content-Type'] = 'application/json'
  end
end
