module Integrations
  class Requester
    attr_accessor :conn, :base_url

    def initialize(base_url, token = nil)
      @base_url = base_url
      @conn = Faraday.new(url: @base_url) do |f|
        f.headers['Content-Type'] = 'application/json'
        f.headers['Authorization'] = "Bearer #{token}" unless token.nil?
      end
    end

    def get(url, data = nil)
      raise ApiError::BaseUrlMissing unless @base_url

      puts "url #{url}"
      puts @conn
      response = @conn.get do |req|
        req.url url.encode('ASCII', 'binary', invalid: :replace, undef: :replace, replace: '')
        req.body = data.to_json
      end
    rescue StandardError => e
      raise ApiError::RequestFailed, e
    else
      parse_response(response)
    end

    def post(url, data = nil)
      raise ApiError::BaseUrlMissing unless @base_url

      # puts("################ Sending a post request to: #{url}")

      response = @conn.post do |req|
        req.url url.encode('ASCII', 'binary', invalid: :replace, undef: :replace, replace: '')
        req.body = data.to_json unless data.nil?
      end
    rescue StandardError => e
      message = JSON.parse(e.message)['message'] || JSON.parse(e.message)
      raise ApiError::RequestFailed, message
    else
      parse_response(response)
    end

    def parse_response(response)
      body = JSON.parse(response.body)

      case response.status
      when 200...300
        body
      when 300...400
        raise ApiError::RequestFailed, body
      when 400...500
        raise ApiError::ClientError, (body['message'] || body)
      when 500...600
        raise ApiError::ProviderError, (body['message'] || body)
      else
        raise ApiError::UnexpectedResponse, "Unexpected status code: #{response.status}"
      end
    end
  end
end
