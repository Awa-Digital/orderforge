# frozen_string_literal: true

Rack::Attack.throttle('ip limit', limit: 10, period: 5.seconds, &:ip)

bad_ips = ENV.fetch("BLOCKED_IPS", "0.0.0.1").split(',')

Rack::Attack.blocklist 'Block IPs from Environment Variable' do |req|
  bad_ips.include?(req.ip)
end

Rack::Attack.blocklist('allow2ban scrapers') do |req|
  Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 40, findtime: 30.seconds, bantime: 10.minutes) do
    true
  end
end

ActiveSupport::Notifications.subscribe('throttle.rack_attack') do |_name, _start, _finish, _request_id, req|
  Rails.logger.error("----- ----- ----- ----- ----- Rack::Attack::Throttle Too many Throttling Requests from IP: #{req[:request].ip}")
end

ActiveSupport::Notifications.subscribe('blocklist.rack_attack') do |_name, _start, _finish, _request_id, req|
  Rails.logger.error("----- ----- ----- ----- ----- Rack::Attack::Ban IP: #{req[:request].ip} has been Banned!")
end
