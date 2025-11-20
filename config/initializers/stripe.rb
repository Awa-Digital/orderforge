# frozen_string_literal: true

Rails.application.config.to_prepare do
  require_dependency Rails.root.join('app/services/stripe')
  Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY', nil)
end
