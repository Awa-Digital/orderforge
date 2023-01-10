Rack::Attack.throttle('ip limit', limit: 5, period: 5.seconds) do |request|
  request.ip
end

LOGGER = Logger.new("log/rack-attack.log")
ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, req|

  LOGGER.info "SUSPECT!"
  LOGGER.info req.ip
  # if [:throttle].include?(req.env['rack.attack.match_type'])
  #   LOGGER.info [match, req.ip, req.request_method, req.fullpath, ('"' + req.user_agent.to_s + '"')].join(' ')
  # end
end

bad_ips = ENV['BLOCKED_IPS'].split(',')
Rack::Attack.blocklist "Block IPs from Environment Variable" do |req|
  bad_ips.include?(req.ip)
end


# Lockout IP addresses that are hammering your login page.
# After 20 requests in 1 minute, block all requests from that IP for 1 hour.
Rack::Attack.blocklist('allow2ban scrapers') do |req|
  # `filter` returns false value if request is to your login page (but still
  # increments the count) so request below the limit are not blocked until
  # they hit the limit.  At that point, filter will return true and block.
  Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 3, findtime: 1.minute, bantime: 1.hour) do
    # The count for the IP is incremented if the return value is truthy.
    true
  end
end
