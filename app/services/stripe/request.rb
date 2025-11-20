# frozen_string_literal: true

# app/services/stripe/request.rb

require 'net/http'
require 'uri'
require 'json'
require 'base64'

module Stripe
  class Request
    attr_reader :base_url, :api_key

    def initialize(base_url, api_key = nil)
      @base_url = base_url
      @api_key = api_key
    end

    def request(method:, path:, data: nil, content_type: 'form')
      request, uri = make_request(path, method)

      case content_type
      when 'form'
        request.set_form_data(data) if data && method == :post
        request['Content-Type'] = 'application/x-www-form-urlencoded'
      when 'json'
        request.body = data.to_json if data
        request['Content-Type'] = 'application/json'
      end

      perform_request(uri, request)
    end

    def parse_error(error)
      raw = error.message.gsub('=>', ':')

      JSON.parse(raw)
    rescue StandardError
      nil
    end

    private

    def make_request(path, request_type)
      uri = URI.join(@base_url, path)
      request = case request_type
                when :get
                  Net::HTTP::Get.new(uri)
                when :post
                  Net::HTTP::Post.new(uri)
                when :put
                  Net::HTTP::Put.new(uri)
                when :delete
                  Net::HTTP::Delete.new(uri)
                when :patch
                  Net::HTTP::Patch.new(uri)
                else
                  raise Stripe::Error::InvalidRequestType, "Invalid request type: #{request_type}"
                end

      apply_headers(request)

      [request, uri]
    end

    def apply_headers(request)
      raise Stripe::Error::ApiKeyMissing unless @api_key

      request.basic_auth(@api_key, '')
      request['Stripe-Version'] = '2025-04-30.basil; fx_quote_preview=v1'
    end

    def perform_request(uri, request)
      # print "uri: #{uri}\n"
      # print "request: #{request}\n"
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
      end

      parse_response(response)
    rescue StandardError => e
      raise Stripe::Error::RequestFailed, e.message
    end

    def parse_response(response)
      body = JSON.parse(response.body)

      case response.code.to_i
      when 200...300
        body
      when 300...400
        raise Stripe::Error::RequestFailed, parse_error(body)
      when 400...500
        raise Stripe::Error::ClientError, (body['message'] || body)
      when 500...600
        raise Stripe::Error::ProviderError, (body['message'] || body)
      else
        raise Stripe::Error::UnexpectedResponse, "Unexpected status code: #{response.code}"
      end
    end
  end
end
