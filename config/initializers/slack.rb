Slack.configure do |config|
  config.token = ENV.fetch('SLACK_API_TOKEN', nil)
end

Slack::Web::Client.configure do |config|
  config.user_agent = "#{AppBranding::NAME} Backend/1.0"
end
