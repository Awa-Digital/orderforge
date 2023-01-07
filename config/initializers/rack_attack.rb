Rack::Attack.throttle('ip limit', limit: 10, period: 5) do |request|
  request.ip
end

# Track it using ActiveSupport::Notification
ActiveSupport::Notifications.subscribe("track.rack_attack") do |name, start, finish, request_id, payload|
  req = payload[:request]
  Rails.logger.info "special_agent: #{req.path}"
end
