# frozen_string_literal: true

Rack::Attack.throttle('ip limit', limit: 10, period: 5.seconds) do |request|
  Rails.logger.error("----- ----- ----- ----- ----- Rack::Attack Too many Requests from IP: #{request.ip}")
  request.ip
end

bad_ips = ENV['BLOCKED_IPS'].split(',')
Rack::Attack.blocklist 'Block IPs from Environment Variable' do |req|
  bad_ips.include?(req.ip)
end

Rack::Attack.blocklist('allow2ban scrapers') do |req|
  Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 60, findtime: 30.seconds, bantime: 10.minutes) do
    true
  end
end
